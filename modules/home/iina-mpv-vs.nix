{ pkgs, ... }:

{
  programs.mpv = {
    enable = true;
    package = pkgs.mpv-vs;
    config = {
      vo = "gpu-next";
      hwdec = "videotoolbox";
      scale = "ewa_lanczossharp";
      cscale = "ewa_lanczossharp";
      video-sync = "display-resample";
      interpolation = "no";
      input-ipc-server = "/tmp/iinasocket";
      hr-seek-framedrop = "no";
    };
  };
}
