{ pkgs, ...}:
let
  vimPackages = import ./vimPackages.nix pkgs;
  neovimPackages = import ./neovimPackages.nix pkgs;
in {
  environment.systemPackages = vimPackages ++ neovimPackages;
}
