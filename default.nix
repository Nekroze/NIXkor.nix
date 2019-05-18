{ desktop ? false }:

{ config, pkgs, lib, ... }:
with lib;
let
  gui = import ./gui.nix;
  editor = ./vim/vim.nix;
in {
  imports = [
    ./tui.nix
    editor
    (gui {
      desktop=desktop;
    })
  ];
}
