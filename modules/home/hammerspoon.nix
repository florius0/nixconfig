{ config, ... }:

{
  home.file."${config.me.xdg.config}/hammerspoon/init.lua".text = ''
    --
    -- Hammerspoon Script to enforce the audio input.
    --
    -- Useful documentation:
    --   https://www.hammerspoon.org/docs/hs.audiodevice.html
    --   https://www.hammerspoon.org/docs/hs.audiodevice.watcher.html
    --

    local MICROPHONE_DEVICE_NAME = "MacBook Pro Microphone"

    local log = hs.logger.new('init','debug')
    log.i('Initializing')

    function audioDeviceCallback(event)
        log.f('audioDeviceCallback: "%s"', event)
        if (event == "dIn ") then -- That trailing space is not a mistake
            local defaultInputDevice = hs.audiodevice.defaultInputDevice()
            log.f("Input device has changed to %s", defaultInputDevice)

            local microphone = hs.audiodevice.findDeviceByName(MICROPHONE_DEVICE_NAME)
            if (microphone ~= nil) then
                log.i("Setting microphone to be the default again")
                microphone:setDefaultInputDevice()
            else
                log.w("Microphone is not connected!")
            end
        end
    end

    hs.audiodevice.watcher.setCallback(audioDeviceCallback)
    hs.audiodevice.watcher.start()

    log.i('Initialized!')
  '';
}
