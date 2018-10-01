with import <nixpkgs> {};
let
  customPlugins.vim-better-whitespace = pkgs.vimUtils.buildVimPlugin {
    name = "vim-better-whitespace";
    src = pkgs.fetchFromGitHub {
      owner = "ntpeters";
      repo = "vim-better-whitespace";
      rev = "984c8da518799a6bfb8214e1acdcfd10f5f1eed7";
      sha256 = "10l01a8xaivz6n01x6hzfx7gd0igd0wcf9ril0sllqzbq7yx2bbk";
    };
  };
  customPlugins.vim-colors-solarized = pkgs.vimUtils.buildVimPlugin {
    name = "vim-colors-solarized";
    src = pkgs.fetchFromGitHub {
      owner = "altercation";
      repo = "vim-colors-solarized";
      rev = "528a59f26d12278698bb946f8fb82a63711eec21";
      sha256 = "05d3lmd1shyagvr3jygqghxd3k8a4vp32723fvxdm57fdrlyzcm1";
    };
  };
in vim_configurable.customize {
  name = "vim";
  vimrcConfig.vam.knownPlugins = vimPlugins // customPlugins;
  vimrcConfig.vam.pluginDictionaries = [
    { name = "fugitive"; }
    { name = "syntastic"; }
    { name = "gitgutter"; }
    { name = "sensible"; }
    { name = "airline"; }
    { name = "vim-colors-solarized"; }
    { name = "vim-better-whitespace"; }
  ];
  vimrcConfig.customRC = ''
    syntax enable
    let g:is_posix=1
    set number
    set ruler
    set expandtab tabstop=4 shiftwidth=4

    set t_Co=256
    set background=dark
    colorscheme solarized

    if has('gui_running')
      set guioptions-=m  "remove menu bar
      set guioptions-=T  "remove toolbar
      set guioptions-=r  "remove right-hand scroll bar
      set guioptions-=L  "remove left-hand scroll bar
    endif
    if filereadable(expand("$HOME/.vimrc"))
      source ~/.vimrc
    endif
  '';
}
