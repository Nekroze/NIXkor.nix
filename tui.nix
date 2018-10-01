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

    users = (attrValues config.users.users);
    defaultUser = findSingle (u: u.isNormalUser) "nekroze" "nekroze" users;

in {
  #users.defaultUserShell = mkForce pkgs.zsh;
  users.defaultUserShell = mkForce pkgs.fish;

  programs.fish = let
    plugins = [
      "edc/bass"
      "tuvistavie/fish-fastdir"
      "oh-my-fish/theme-bobthefish"
      "laughedelic/pisces"
    ];
  in {
    enable = true;
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

  programs.zsh = {
    enable = mkDefault true;
    shellAliases = aliases;
    enableCompletion = true;
    enableAutosuggestions = true;
    syntaxHighlighting = {
      enable = true;
      highlighters = [
        "main"
        "brackets"
        "cursor"
        "root"
      ];
    };

    ohMyZsh = {
      enable = true;
      theme = mkDefault "agnoster";
      plugins = [
        "bgnotify" # pkgs.libnotify
        "dotenv"
        "fzf" # pkgs.fzf
        "gitfast" # pkgs.git
        "gpg-agent" # pkgs.gnupg
        "history-substring-search"
        "mosh" # pkgs.mosh
        "per-directory-history"
        "safe-paste"
        "systemd"
        "vi-like"
        "vi-mode"
        "common-aliases"
      ]
      ++ optional (pkgInstalled pkgs.httpie) "httpie"
      ++ optional (pkgInstalled pkgs.go) "golang"
      ++ optional (pkgInstalled pkgs.go) "nmap"
      ++ optionals config.virtualisation.docker.enable ["docker" "docker_compose"];
    };

    interactiveShellInit = ''
      source ${pkgs.autojump}/share/autojump/autojump.zsh
      [ "$IN_NIX_SHELL" ] && export PS1="nix-shell@$PS1"
    '';
    shellInit = "[ -r ~/.localrc ] && source ~/.localrc";
  };

  environment.systemPackages = with pkgs; [
    mosh
    libnotify
    nmap
    gnupg
    fzf
    gitAndTools.gitFull
  ]
  ++ optional config.virtualisation.docker.enable docker_compose
  ++ aliasDeps;

  programs.ssh.startAgent = mkForce false;
  programs.gnupg.agent = {
    enable = mkForce true;
    enableSSHSupport = true;
  };

  environment.variables = {
    EDITOR = mkForce "nvim";
  };
}
