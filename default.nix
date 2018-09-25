{ desktop ? true }:

{ config, pkgs, lib, ... }:
with lib;
let
  gui = import ./gui.nix;
in {
  imports = [
    ./tui.nix
    (gui {
      desktop=desktop;
    })
  ];
}
