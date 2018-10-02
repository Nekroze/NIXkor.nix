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
        "vim-nix"
        "vim-autoformat"
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
        "vim-polyglot"
        "tabular"
        "sensible"
        "vim-indent-guides"
        "Jenkinsfile-vim-syntax"
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
