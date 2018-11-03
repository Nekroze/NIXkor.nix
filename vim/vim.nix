{ pkgs, ...}:
with lib;
let
  vimPackages = import ./vimPackages.nix pkgs;
in {
  environment.systemPackages = vimPackages;
  environment.variables.EDITOR = mkForce "vim";
  environment.variables.PAGER = mkForce "vim -R";
  environment.variables.MANPAGER = mkForce "vim -R -c 'set ft=man nomod nolist nonu noma' -";
}
