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
        "LnL7/vim-nix"
        "Chiel92/vim-autoformat"
        "fugitive"
        "syntastic"
        "gitgutter"
        "sensible"
        "vim-airline"
        "vim-airline-themes"
        "fzf-vim"
        "fzfWrapper"
        "vim-go"
        "vim-better-whitespace"
        "Solarized"
        "sheerun/vim-polyglot
        "godlygeek/tabular"
        "tpope/vim-sensible"
        "nathanaelkane/vim-indent-guides"
        "martinda/Jenkinsfile-vim-syntax"
        #"chrisbra/Colorizer"
        #"myusuf3/numbers.vim"
        #"buoto/gotests-vim"
        #"prabirshrestha/asyncomplete.vim"
        #"prabirshrestha/async.vim"
        #"prabirshrestha/vim-lsp"
        #"prabirshrestha/asyncomplete-lsp.vim"
      ]; }
    ];
  };
}
