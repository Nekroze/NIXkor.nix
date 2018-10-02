{ pkgs, }:

let
  buildVimPlugin = pkgs.vimUtils.buildVimPluginFrom2Nix;
in {

  "vim-better-whitespace" = buildVimPlugin rec {
    name = "vim-better-whitespace";
    src = pkgs.fetchFromGitHub {
      owner = "ntpeters";
      repo = name;
      rev = "984c8da518799a6bfb8214e1acdcfd10f5f1eed7";
      sha256 = "10l01a8xaivz6n01x6hzfx7gd0igd0wcf9ril0sllqzbq7yx2bbk";
    };
  };

  "NeoSolarized" = buildVimPlugin rec {
    name = "NeoSolarized";
    src = pkgs.fetchFromGitHub {
      owner = "icymind";
      repo = name;
      rev = "1af4bf6835f0fbf156c6391dc228cae6ea967053";
      sha256 = "05d3lmd1shyagvr3jygqghxd3k8a4vp32723fvxdm57fdrlyzcm1";
    };
  };

  "IndentLine" = buildVimPlugin rec {
    name = "IndentLine";
    src = pkgs.fetchFromGitHub {
      owner = "Yggdroot";
      repo = name;
      rev = "82ec57f8df3f642b0b3d43361e7b1a70f1a406d0";
      sha256 = "05d3lmd1shyagvr3jygqghxd3k8a4vp32723fvxdm57fdrlyzcm1";
    };
  };


  "Colorizer" = buildVimPlugin rec {
    name = "Colorizer";
    src = pkgs.fetchFromGitHub {
      owner = "chrisbra";
      repo = name;
      rev = "abce308f7a7e5b66dabdcafa3757e07e34e277fd";
      sha256 = "05d3lmd1shyagvr3jygqghxd3k8a4vp32723fvxdm57fdrlyzcm1";
    };
  };

  "numbers.vim" = buildVimPlugin rec {
    name = "numbers.vim";
    src = pkgs.fetchFromGitHub {
      owner = "myusuf3";
      repo = name;
      rev = "1867e76e819db182a4fb71f48f4bd36a5e2c6b6e";
      sha256 = "05d3lmd1shyagvr3jygqghxd3k8a4vp32723fvxdm57fdrlyzcm1";
    };
  };

  "gotests-vim" = buildVimPlugin rec {
    name = "gotests-vim";
    src = pkgs.fetchFromGitHub {
      owner = "buoto";
      repo = name;
      rev = "a804ad39f9ee95f3d7e487b220113d258c8db313";
      sha256 = "05d3lmd1shyagvr3jygqghxd3k8a4vp32723fvxdm57fdrlyzcm1";
    };
  };

}
