{ config, ... }:

{
  home.file."${config.me.xdg.config}/hammerspoon/init.lua".text = ''
    --
    -- Hammerspoon Script to enforce the audio input.
    --
    -- Behavior:
    --   - Keep a priority-ordered list of preferred input devices
    --   - Whenever audio devices, watched files, or watched applications change,
    --     pick the first available device
    --   - Optional per-device guards:
    --       * processes = list of process/app names that must all be running
    --       * files     = list of file paths that must all exist
    --   - If none of the preferred devices are available, do nothing
    --

    local MICROPHONE_DEVICE_PRIORITY = {
        {
            device = "Loopback Audio",
            processes = { "Audio Hijack" },
            files = { "/tmp/audio-hijack-active" },
        },
        {
            device = "fifine Microphone",
        },
        {
            device = "MacBook Pro Microphone",
        },
    }

    local log = hs.logger.new("audio-input-priority", "debug")
    log.i("Initializing")

    local function fileExists(path)
        return hs.fs.attributes(path) ~= nil
    end

    local function shellQuote(str)
        local q = string.char(39)
        return q .. tostring(str):gsub(q, function()
            return q .. "\\" .. q .. q
        end) .. q
    end

    local function processRunning(processName)
        local quoted = shellQuote(processName)
        local _, _, _, rc = hs.execute("/usr/bin/pgrep -x -- " .. quoted, true)
        return rc == 0
    end

    local function allFilesExist(paths)
        if paths == nil then
            return true
        end

        for _, path in ipairs(paths) do
            if not fileExists(path) then
                log.df('Missing required file "%s"', path)
                return false
            end
        end

        return true
    end

    local function allProcessesRunning(processNames)
        if processNames == nil then
            return true
        end

        for _, processName in ipairs(processNames) do
            if not processRunning(processName) then
                log.df('Required process "%s" is not running', processName)
                return false
            end
        end

        return true
    end

    local function findInputDeviceByName(name)
        local device = hs.audiodevice.findInputByName(name)
        if device ~= nil then
            return device
        end

        -- Fallback in case the device lookup API behaves differently for some devices
        local generic = hs.audiodevice.findDeviceByName(name)
        if generic ~= nil and generic:inputChannels() > 0 then
            return generic
        end

        return nil
    end

    local function deviceIsAvailable(entry)
        local device = findInputDeviceByName(entry.device)
        if device == nil then
            log.df('Device "%s" not found', entry.device)
            return nil
        end

        if not allProcessesRunning(entry.processes) then
            log.df('Skipping "%s": process requirements not satisfied', entry.device)
            return nil
        end

        if not allFilesExist(entry.files) then
            log.df('Skipping "%s": file requirements not satisfied', entry.device)
            return nil
        end

        return device
    end

    local function getBestAvailableInputDevice()
        for _, entry in ipairs(MICROPHONE_DEVICE_PRIORITY) do
            local device = deviceIsAvailable(entry)
            if device ~= nil then
                return device, entry.device, entry
            end
        end

        return nil, nil, nil
    end

    local function ensurePreferredInputDevice()
        local preferredDevice, preferredDeviceName, preferredEntry = getBestAvailableInputDevice()

        if preferredDevice == nil then
            log.w("No preferred input devices are currently available")
            return
        end

        local currentInputDevice = hs.audiodevice.defaultInputDevice()
        local currentInputDeviceName = currentInputDevice and currentInputDevice:name() or "<none>"

        if currentInputDeviceName == preferredDeviceName then
            log.i(string.format('Preferred input "%s" is already selected', preferredDeviceName))
            return
        end

        log.i(string.format(
            'Switching input from "%s" to preferred available device "%s"',
            currentInputDeviceName,
            preferredDeviceName
        ))

        if preferredEntry.processes ~= nil then
            log.df('  required processes: %s', hs.inspect(preferredEntry.processes))
        end

        if preferredEntry.files ~= nil then
            log.df('  required files: %s', hs.inspect(preferredEntry.files))
        end

        local ok = preferredDevice:setDefaultInputDevice()
        if not ok then
            log.ef('Failed to switch input to "%s"', preferredDeviceName)
        end
    end

    local function uniq(list)
        local seen = {}
        local out = {}

        for _, value in ipairs(list) do
            if value ~= nil and not seen[value] then
                seen[value] = true
                table.insert(out, value)
            end
        end

        return out
    end

    local function dirname(path)
        return string.match(path, "^(.*)/[^/]+$") or "."
    end

    local function basename(path)
        return string.match(path, "([^/]+)$")
    end

    local watchedFiles = {}
    local watchedDirectories = {}
    local watchedApplications = {}

    for _, entry in ipairs(MICROPHONE_DEVICE_PRIORITY) do
        if entry.files ~= nil then
            for _, path in ipairs(entry.files) do
                table.insert(watchedFiles, path)
                table.insert(watchedDirectories, dirname(path))
            end
        end

        if entry.processes ~= nil then
            for _, processName in ipairs(entry.processes) do
                table.insert(watchedApplications, processName)
            end
        end
    end

    watchedFiles = uniq(watchedFiles)
    watchedDirectories = uniq(watchedDirectories)
    watchedApplications = uniq(watchedApplications)

    local watchedFileSet = {}
    for _, path in ipairs(watchedFiles) do
        watchedFileSet[path] = true
    end

    local function reevaluate(reason)
        log.df('Reevaluating preferred input (%s)', reason or "unknown")
        ensurePreferredInputDevice()
    end

    local function audioDeviceCallback(event)
        log.df('audioDeviceCallback: "%s"', tostring(event))
        reevaluate("audio-device-change")
    end

    local audioWatcher = hs.audiodevice.watcher
    audioWatcher.setCallback(audioDeviceCallback)
    audioWatcher.start()

    local pathWatchers = {}
    for _, dir in ipairs(watchedDirectories) do
        log.df('Watching directory "%s" for required file changes', dir)

        local watcher = hs.pathwatcher.new(dir, function(paths)
            for _, changedPath in ipairs(paths) do
                if watchedFileSet[changedPath] then
                    log.df('Observed watched file change: "%s"', changedPath)
                    reevaluate("file-change")
                    return
                end

                -- Some events may come through as directory-related paths; also match by basename in the same dir
                local changedBase = basename(changedPath)
                for watchedPath, _ in pairs(watchedFileSet) do
                    if dirname(watchedPath) == dir and basename(watchedPath) == changedBase then
                        log.df('Observed watched file-related change: "%s"', changedPath)
                        reevaluate("file-change")
                        return
                    end
                end
            end
        end)

        watcher:start()
        table.insert(pathWatchers, watcher)
    end

    local appEventNames = {
        [hs.application.watcher.launched] = "launched",
        [hs.application.watcher.terminated] = "terminated",
        [hs.application.watcher.hidden] = "hidden",
        [hs.application.watcher.unhidden] = "unhidden",
        [hs.application.watcher.activated] = "activated",
        [hs.application.watcher.deactivated] = "deactivated",
    }

    local watchedApplicationSet = {}
    for _, appName in ipairs(watchedApplications) do
        watchedApplicationSet[appName] = true
    end

    local applicationWatcher = hs.application.watcher.new(function(appName, eventType, appObject)
        if watchedApplicationSet[appName] then
            log.df(
                'applicationWatcher: app="%s" event="%s"',
                tostring(appName),
                appEventNames[eventType] or tostring(eventType)
            )
            reevaluate("application-change")
        end
    end)
    applicationWatcher:start()

    -- Enforce once at startup too
    ensurePreferredInputDevice()

    log.i("Initialized!")
  '';
}
