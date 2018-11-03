{ pkgs, lib, ...}:
with lib;
let
  neovimPackages = import ./neovimPackages.nix pkgs;
in {
  environment.systemPackages = neovimPackages;
  environment.variables.EDITOR = mkForce "nvim";
  environment.variables.PAGER = mkForce "nvim -R";
  environment.variables.MANPAGER = mkForce "nvim -R -c 'set ft=man nomod nolist nonu noma' -";
}
