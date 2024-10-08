{
  lib,
  pkgs,
  ...
}: let
  username = "rk";
  # To generate a hashed password run `mkpasswd -m scrypt`.
  # this is the hash of the password "rk3588"
  hashedPassword = "$y$j9T$V7M5HzQFBIdfNzVltUxFj/$THE5w.7V7rocWFm06Oh8eFkAKkUFb5u6HVZvXyjekK6";
in {
  nix.settings = {
    experimental-features = ["nix-command" "flakes"];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    git # used by nix flakes
    curl

    neofetch
    lm_sensors # `sensors`
    btop # monitor system resources

    # Peripherals
    mtdutils
    i2c-tools
    minicom

    # MY STUFF
    #hyprland
    #yarn
		parted
		gparted
    wget
		minizip
    git
		git-lfs
    #vulkan-tools
    vulkan-loader
    #godot_4
    foot
    #adwaita-icon-theme
    waybar
    #xdg-desktop-portal
    grim
    slurp
    pipewire
    wireplumber
    pavucontrol
    #xfce.thunar
    #hyprpaper
    gnome-themes-extra
    #vlc
    #imv
    rofi-wayland
    #ranger
    neofetch
    #gamescope
    mpv
    mako
    #weechat
    gamemode
    p7zip
    #unrar
    wl-clipboard
    #brightnessctl
    killall
    #playerctl
    #mpc-cli

    unzip
    #discord
    #prismlauncher
    ffmpeg
    xarchiver
    obs-studio
    polkit
    polkit-kde-agent
		#jdk
		vscodium
  ];

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = lib.mkDefault true;
    settings = {
      X11Forwarding = lib.mkDefault true;
      PasswordAuthentication = lib.mkDefault true;
    };
    openFirewall = lib.mkDefault true;
  };

  # MY STUFF

  # ENV VARS
  environment.sessionVariables = {
    MOZ_ENABLE_WAYLAND = "1";
    TERM = "foot";
    TERMINAL = "foot";
    BROWSER = "firefox";
    VISUAL = "nvim";
		NIXOS_OZONE_WL = "1";
		ELECTRON_OZONE_PLATFORM_HINT = "wayland";
  };

  # firefox
	programs.firefox.enable = true;

	# hyprland
	programs.hyprland.enable = true;

  # Fish Shell
  programs.fish.enable = true;
  users.defaultUserShell = pkgs.fish;
  environment.shells = with pkgs; [ fish ];

  # Nvim default
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    configure = {
      customRC = ''
        set number
        set tabstop=2
				set shiftwidth=2
      '';
    };
  };

  # Enable networking
  #networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n.defaultLocale = "de_DE.utf8";

  # Enable the X11 windowing system.
  # services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  # services.xserver.displayManager.gdm.enable = true;
  # services.xserver.desktopManager.gnome.enable = true;
  services.xserver.displayManager.lightdm.enable = false;

  # Greeter
  # Run GreetD on TTY2
  services.greetd = {
    enable = true;
    vt = 7;
    settings = {
      default_session = {
        command = "${lib.makeBinPath [pkgs.greetd.tuigreet] }/tuigreet --user-menu --time --cmd Hyprland";
        user = "greeter";
      };
    };
  };

  # Configure keymap in X11
  #services.xserver = {
  #  xkb.layout = "de";
  #  xkb.variant = "";
  #};

  # Configure console keymap
  console.keyMap = "de";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Fonts
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    liberation_ttf
    fira-code
    fira-code-symbols
    dina-font
    proggyfonts
    font-awesome
    meslo-lgs-nf
    ubuntu_font_family
    (nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" ]; })
  ];

  # XDG stuff

  services.dbus.enable = true;
  xdg.portal = {
    enable = true;
    # gtk portal needed to make gtk apps happy
    extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
    config.common.default = "*";
  };

  # Enable gvfs (mount, trash...) for thunar
  services.gvfs.enable = true; # Mount, trash, and other functionalities
  services.tumbler.enable = true; # Thumbnail support for images

  # Enable sound with pipewire.
  #sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Docker
	virtualisation.docker.enable = true;

  # =========================================================================
  #      Users & Groups NixOS Configuration
  # =========================================================================

  # TODO Define a user account. Don't forget to update this!
  users.users."${username}" = {
    inherit hashedPassword;
    isNormalUser = true;
    home = "/home/${username}";
    extraGroups = ["users" "wheel"];
  };

  system.stateVersion = "23.11";
}
