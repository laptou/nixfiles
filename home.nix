{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
    telegram-desktop
    nixfmt-classic
    ffmpeg
    htop
    jq
    ripgrep
    tree
    slack
    discord
    jetbrains-mono
    # nerdfonts
    alt-tab-macos
    uv
    nil
    nixd
    nrfutil
    google-cloud-sdk
    ghidra
    git-filter-repo
    kondo
    du-dust
    blueutil
    jdk
    android-tools
    swiftlint
    tuist
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # You can also manage environment variables but you will have to manually
  # source
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/davish/etc/profile.d/hm-session-vars.sh
  #
  # if you don't want to manage your shell through Home Manager.
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # home.shell.enableShellIntegration = true;
  # home.shell.enableZshIntegration = true;
  # home.shell.enableNushellIntegration = true;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.nushell = {
    enable = true;
    shellAliases = {
      switch = "darwin-rebuild switch --flake ~/.config/nix-darwin";
    };
  };

  programs.java = {
    enable = true;
    # package = pkgs.jdk;
  };

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    historySubstringSearch.enable = true;
    syntaxHighlighting.enable = true;
    initContent = ''
      devinit() { nix flake init -t github:the-nix-way/dev-templates#$1; direnv allow; }
      export PATH="/Users/ibiyemi/.local/bin:$PATH"
    '';
    shellAliases = {
      switch = "sudo darwin-rebuild switch --flake ~/.config/nix-darwin";
    };
  };
  programs.micro = {
    enable = true;
  };

  programs.broot = {
    enable = true;
  };

  programs.git = {
    enable = true;
    userName = "Ibiyemi Abiodun";
    userEmail = "ibiyemi@intulon.com";
    ignores = [ ".DS_Store" ".direnv" ];
    lfs.enable = true;
    signing.signByDefault = true;
    signing.key = "576B5BFD3CA393AF536C5FED21DEBD9FED09B62F";
    extraConfig = {
      init.defaultBranch = "main";
      push.autoSetupRemote = true;
    };
  };

  programs.bun = { enable = true; };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.kitty = {
    enable = true;
    # shellIntegration = {
    #   enableZshIntegration = true;
    #   enableNushellIntegration = true;
    # };
  };

  programs.lsd = {
    enable = true;
  };

  programs.fzf = { 
    enable = true;
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.vscode = {
    enable = true;
  };
}
