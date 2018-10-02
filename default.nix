{ desktop ? true, neovim ? true }:

{ config, pkgs, lib, ... }:
with lib;
let
  gui = import ./gui.nix;
  editor = if neovim then ./vim/neovim.nix else ./vim/vim.nix;
in {
  imports = [
    ./tui.nix
    editor
    (gui {
      desktop=desktop;
    })
  ];
}
