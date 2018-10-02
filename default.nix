{ desktop ? true }:

{ config, pkgs, lib, ... }:
with lib;
let
  gui = import ./gui.nix;
in {
  imports = [
    ./tui.nix
    ./vim/neovim.nix
    (gui {
      desktop=desktop;
    })
  ];
}
