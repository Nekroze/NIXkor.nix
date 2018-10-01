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
    vim = "nvim";
    vi = "nvim";
    v = "nvim";
    man = "tldr";
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
      "laughedelic/pisces"
      "fisherman/done"
      "oh-my-fish/plugin-thefuck"
      "oh-my-fish/plugin-bang-bang"
      "oh-my-fish/plugin-vi-mode"
      "oh-my-fish/plugin-direnv"
    ];
  in {
    enable = mkForce true;
    shellAliases = aliases;
    interactiveShellInit = ''
      source ${pkgs.autojump}/share/autojump/autojump.fish
      fish_vi_key_bindings

      if not functions -q fundle; eval (curl -sfL https://git.io/fundle-install); end
      ${concatMapStringsSep "\n" (p: "fundle plugin '${p}'") plugins}
      fundle init

      set -g default_user ${defaultUser.name}
      set -g theme_powerline_fonts yes
      set -g theme_nerd_fonts no
      set -g theme_color_scheme solarized-dark
      set -g theme_display_date yes
    '';
  };

  environment.systemPackages = with pkgs; [
    mosh
    libnotify
    gnupg
    fzf
    direnv
    gitAndTools.gitFull
    thefuck
  ]
  ++ optional config.virtualisation.docker.enable docker_compose
  ++ aliasDeps;

  programs.ssh.startAgent = mkForce false;
  programs.gnupg.agent = {
    enable = mkForce true;
    enableSSHSupport = true;
  };
}
