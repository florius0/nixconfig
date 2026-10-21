{ lib, pkgs, ... }:
let
  abc = "^com\\.apple\\.keylayout\\.ABC$";
  russian = "^com\\.apple\\.keylayout\\.Russian$";
  caps = inputSource: {
    type = "basic";
    from = {
      key_code = "caps_lock";
      modifiers.optional = [ "any" ];
    };
    to = [
      {
        key_code = "left_control";
        modifiers = [
          "left_option"
          "left_shift"
        ];
        lazy = true;
      }
    ];
    to_if_alone = [
      { select_input_source.input_source_id = inputSource; }
    ];
  };

  karabinerConfig = (pkgs.formats.json { }).generate "karabiner.json" {
    global.show_in_menu_bar = false;
    profiles = [
      {
        name = "Nix";
        selected = true;
        virtual_hid_keyboard.keyboard_type_v2 = "ansi";
        complex_modifications.rules = [
          {
            description = "Caps Lock: tap to switch language, hold for Ctrl+Alt+Shift";
            manipulators = [
              (
                (caps abc)
                // {
                  conditions = [
                    {
                      type = "input_source_if";
                      input_sources = [ { input_source_id = russian; } ];
                    }
                  ];
                }
              )
              (caps russian)
            ];
          }
        ];
      }
    ];
  };
in
{
  # Karabiner cannot watch changes through a symlink to karabiner.json.
  home.activation.configureKarabiner = lib.mkIf pkgs.stdenv.hostPlatform.isDarwin (
    lib.hm.dag.entryAfter [ "linkGeneration" ] ''
      run mkdir -p "$HOME/.config/karabiner"
      run ${pkgs.coreutils}/bin/install -m600 ${karabinerConfig} "$HOME/.config/karabiner/karabiner.json"
    ''
  );
}
