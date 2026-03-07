{ config, ... }:

{
  home.file."${config.me.xdg.config}/hammerspoon/init.lua".text = ''
    --
    -- Hammerspoon Script to enforce the audio input.
    --
    -- Behavior:
    --   - Keep a priority-ordered list of preferred input devices
    --   - Whenever audio devices change, pick the first available device
    --   - If none of the preferred devices are connected, do nothing
    --
    -- Useful documentation:
    --   https://www.hammerspoon.org/docs/hs.audiodevice.html
    --   https://www.hammerspoon.org/docs/hs.audiodevice.watcher.html
    --

    local MICROPHONE_DEVICE_PRIORITY = {
        "fifine Microphone",
        "MacBook Pro Microphone",
    }

    local log = hs.logger.new("audio-input-priority", "debug")
    log.i("Initializing")

    local function getBestAvailableInputDevice()
        for _, deviceName in ipairs(MICROPHONE_DEVICE_PRIORITY) do
            local device = hs.audiodevice.findDeviceByName(deviceName)
            if device ~= nil then
                return device, deviceName
            end
        end
        return nil, nil
    end

    local function ensurePreferredInputDevice()
        local preferredDevice, preferredDeviceName = getBestAvailableInputDevice()

        if preferredDevice == nil then
            log.w("No preferred input devices are currently connected")
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
        preferredDevice:setDefaultInputDevice()
    end

    local function audioDeviceCallback(event)
        log.f('audioDeviceCallback: "%s"', event)

        -- Commonly useful to react to both device connection changes and input changes.
        -- "dIn " = default input device changed
        -- Other device events may also occur when hardware is plugged/unplugged,
        -- so we simply re-evaluate on every callback.
        ensurePreferredInputDevice()
    end

    hs.audiodevice.watcher.setCallback(audioDeviceCallback)
    hs.audiodevice.watcher.start()

    -- Enforce once at startup too
    ensurePreferredInputDevice()

    log.i("Initialized!")
  '';
}
