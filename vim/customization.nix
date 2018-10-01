{ pkgs }:

let
  # this is the vimrc.nix from above
  vimrc   = pkgs.callPackage ./vimrc.nix {};

  # and the plugins.nix from above
  plugins = pkgs.callPackage ./plugins.nix {};
in
{
  customRC = vimrc;
  vam = {
    knownPlugins = pkgs.vimPlugins // plugins;

    pluginDictionaries = [
      # from pkgs.vimPlugins
      { names = [
        "fugitive"
          "youcompleteme"
          "syntastic"
          "gitgutter"
          "sensible"
          "vim-airline"
          "vim-airline-themes"
          "fzf-vim"
          "fzfWrapper"
          "vim-go"
          "vim-better-whitespace"
          "NeoSolarized"
      ]; }
    ];
  };
}
