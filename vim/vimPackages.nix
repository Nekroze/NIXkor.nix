{ pkgs, lib, ... }:

let
  customization = {
    vimrcConfig = (import ./customization.nix { pkgs = pkgs; });
  } // { name = "vim"; };

  custom_vim = pkgs.vim_configurable.customize customization;

  vim = lib.overrideDerivation custom_vim (o: {
    aclSupport              = false;
    cscopeSupport           = true;
    darwinSupport           = false;
    fontsetSupport          = true;
    ftNixSupport            = true;
    gpmSupport              = true;
    gui                     = false;
    hangulinputSupport      = false;
    luaSupport              = true;
    multibyteSupport        = true;
    mzschemeSupport         = true;
    netbeansSupport         = false;
    nlsSupport              = false;
    perlSupport             = false;
    pythonSupport           = true;
    rubySupport             = true;
    sniffSupport            = false;
    tclSupport              = false;
    ximSupport              = false;
    xsmpSupport             = false;
    xsmp_interactSupport    = false;
  });

in [
  vim
  pkgs.python
  pkgs.ctags
]
