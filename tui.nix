{ config, pkgs, lib, ... }:
with lib;
let

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
    neovim
    tldr
  ];

in {
  users.defaultUserShell = mkDefault pkgs.zsh;

  programs.zsh = {
    enable = mkDefault true;
    shellAliases = aliases;
    enableCompletion = true;
    enableAutosuggestions = true;
    syntaxHighlighting.enable = true;
    ohMyZsh = {
      enable = true;
      theme = mkDefault "agnoster";
      plugins = [
        "bgnotify" # pkgs.libnotify
        "dotenv"
        "fzf" # pkgs.fzf
        "gitfast" # pkgs.git
        "golang" # pkgs.go
        "gpg-agent" # pkgs.gnupg
        "history-substring-search"
        "mosh" # pkgs.mosh
        "nmap" # pkgs.nmap
        "per-directory-history"
        "safe-paste"
        "systemd"
        "vi-like"
        "vi-mode"
      ] ++ optionals config.virtualisation.docker.enable ["docker" "docker_compose"];
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
    go
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
