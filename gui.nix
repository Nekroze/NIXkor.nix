{ desktop ? false }:
{ config, pkgs, lib, ... }:
with lib;
{
  environment.etc."X11/Xresources".text = ''
    rofi.color-enabled:     true
    rofi.theme:             solarized
    rofi.location:          0
    rofi.font:              Fira Code 10
    rofi.terminal:          kitty
    rofi.case-sensitive:    false
    rofi.scroll-method:     1
    rofi.modi:              drun
    rofi.parse-known-hosts: false
    rofi.matching:          glob
  '';
}
