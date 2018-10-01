{ pkgs, ...}:
let
  neovimPackages = import ./neovimPackages.nix pkgs;
in {
  environment.systemPackages = neovimPackages;
}
