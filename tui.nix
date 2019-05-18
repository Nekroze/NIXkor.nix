{ config, pkgs, lib, ... }:
with lib;
let
  pkgInstalled = pkg: (count (x: x == pkg) config.environment.systemPackages) == 1;

  aliases = {
    la = "exa -la --git -header";
    ll = "exa -l --git --header";
    ls = "exa";
    lt = "exa -lT --git --header";
    lx = "exa -bghHliS --git";
    vi = "vim";
    #nix-shell = "nix-shell --command fish";
  };
  aliasDeps = with pkgs; [
    exa
    tldr
  ];

  allUsers = (attrValues config.users.users);
  defaultUser = findSingle (u: u.isNormalUser) "nekroze" "nekroze" allUsers;

in {
  users.defaultUserShell = mkForce pkgs.fish;

  programs.fish = let
    plugins = [
      "edc/bass"
      "tuvistavie/fish-fastdir"
      "oh-my-fish/theme-bobthefish"
      "oh-my-fish/plugin-bang-bang"
      "oh-my-fish/plugin-direnv"
      "oh-my-fish/plugin-aws"
      "jethrokuan/fzf"
      "rominf/omf-plugin-fzf-autojump"
      "rominf/omf-plugin-autojump"
    ];
  in {
    enable = mkForce true;
    shellAliases = aliases;
    interactiveShellInit = ''
      source ${pkgs.autojump}/share/autojump/autojump.fish

      if not functions -q fundle; eval (curl -sfL https://git.io/fundle-install); end
      ${concatMapStringsSep "\n" (p: "fundle plugin '${p}'") plugins}
      fundle init

      set -g default_user ${defaultUser.name}
      set -g theme_powerline_fonts yes
      set -g theme_nerd_fonts no
      set -g theme_color_scheme solarized-dark
      set -g theme_display_date yes
      set -g theme_date_format "+%H:%M:%S %Z"
      fish_vi_key_bindings
      set fish_plugins autojump vi-mode
    '';
  };

  environment.systemPackages = with pkgs; [
    ranger
    highlight
    mosh
    libnotify
    gnupg
    fzf
    direnv
    gitAndTools.gitFull
    ripgrep
    entr
    autojump
    bat
  ]
  ++ optional config.virtualisation.docker.enable docker_compose
  ++ aliasDeps;
  environment.variables.FZF_DEFAULT_OPTS = "--preview 'bat --decorations never --color always {}'";
  environment.variables.PAGER = "bat --decorations never --color always";

  programs.ssh.startAgent = mkForce false;
  programs.gnupg.agent = {
    enable = mkForce true;
    enableSSHSupport = true;
  };
}
