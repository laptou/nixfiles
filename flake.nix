{
  description = "nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-24.11-darwin";
    nix-darwin.url = "github:nix-darwin/nix-darwin/nix-darwin-24.11";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager/release-24.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nix-homebrew = {
      url = "github:zhaofengli-wip/nix-homebrew";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
    homebrew-bundle = {
      url = "github:homebrew/homebrew-bundle";
      flake = false;
    };
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, home-manager, nix-homebrew, homebrew-core, homebrew-cask, homebrew-bundle }:
  let
    configuration = { pkgs, ... }: {
      security.pam.enableSudoTouchIdAuth = true;
      
      environment.systemPackages =
        with pkgs; [ 
        	vim 
        	micro
        	ffmpeg
        	cargo
        	rustc
        ];
        
      homebrew = {
          enable = true;
          onActivation.cleanup = "uninstall";
      
          taps = [];
          brews = [ ];
          casks = [ "cursor" "visual-studio-code" "zed" "raycast" "spotify" "rekordbox" ];

          masApps = {
          	"Bitwarden" = 1352778147;
          };
      };

	  # Create /etc/zshrc that loads the nix-darwin environment.
	  programs = {
	    gnupg.agent.enable = true;
	    zsh.enable = true;  # default shell on catalina
	  };
      
      # disable nix-darwin management of nix b/c it conflicts with determinate nix
      nix.enable = false;
      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Enable alternative shell support in nix-darwin.
      # programs.fish.enable = true;

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 5;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";
      nixpkgs.config.allowUnfree = true;

      users.users.ibiyemi = {
      	name = "ibiyemi";
      	home = "/Users/ibiyemi";
      };

      system.defaults = {
          # a finder that tells me what I want to know and lets me work
          finder = {
            AppleShowAllExtensions = true;
            ShowPathbar = true;
            FXEnableExtensionChangeWarning = false;
          };
          # Tab between form controls and F-row that behaves as F1-F12
          NSGlobalDomain = {
            AppleKeyboardUIMode = 3;
            "com.apple.keyboard.fnState" = true;
          };
        };
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#ibimbp
    darwinConfigurations."ibimbp" = nix-darwin.lib.darwinSystem {
      modules = [ 
      	configuration
      	home-manager.darwinModules.home-manager
        {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.ibiyemi = import ./home.nix;

            # Optionally, use home-manager.extraSpecialArgs to pass
            # arguments to home.nix
    	}
    	nix-homebrew.darwinModules.nix-homebrew
    	{
    	  nix-homebrew = {
    	    enable = true;
    	    # Apple Silicon Only: Also install Homebrew under the default Intel prefix for Rosetta 2
    	    # enableRosetta = true;
    	    user = "ibiyemi";
    	
    	    taps = {
    	      "homebrew/homebrew-core" = homebrew-core;
    	      "homebrew/homebrew-cask" = homebrew-cask;
    	      "homebrew/homebrew-bundle" = homebrew-bundle;
    	    };
    	    mutableTaps = false;
    	  };
    	}
      ];
    };
  };
}
