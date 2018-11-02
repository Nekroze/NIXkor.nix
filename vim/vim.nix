{ pkgs, ...}:
with lib;
let
  vimPackages = import ./vimPackages.nix pkgs;
in {
  environment.systemPackages = vimPackages;
  environment.variables.EDITOR = mkForce "vim";
  environment.variables.PAGER = mkForce "vim -c 'set ro' -R";
  environment.variables.MANPAGER = mkForce "vim -c 'set ft=man ro nomod nolist nonu noma' -";
}
