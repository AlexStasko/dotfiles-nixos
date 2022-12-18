{ config, pkgs, ... }: {
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.enable = true;

  fonts = {
    fontconfig = {
      defaultFonts = {
        monospace = [ "Meslo LG M Regular Nerd Font Complete Mono" ];
      };

      enable = true;
    };

    fonts = with pkgs; [ (nerdfonts.override { fonts = [ "Meslo" ]; }) ];
  };

  environment.systemPackages = with pkgs; [
    curl
    dunst
    libnotify
    lxappearance
    pavucontrol
    wget
    xclip
  ];

  environment.pathsToLink = [ "/libexec" "/share/zsh" ];

  hardware.opengl.enable = true;
  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.extraConfig = "unload-module module-suspend-on-idle";
  hardware.pulseaudio.support32Bit = true;

  i18n.defaultLocale = "en_US.UTF-8";

  networking = {
    firewall.enable = false;
    hostName = "EPBYVITW00DDV02";
    interfaces.ens33.useDHCP = true;
    networkmanager.enable = true;
    useDHCP = false;
  };

  nix = {
    extraOptions = ''
      experimental-features = nix-command flakes
      keep-outputs = true
      keep-derivations = true
      warn-dirty = false
    '';
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    package = pkgs.nixUnstable;
    settings = { auto-optimise-store = true; };
  };

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.pulseaudio = true;
  nixpkgs.overlays = [ (import ../../home-manager/overlays.nix) ];

  programs.dconf.enable = true;
  programs.geary.enable = true;

  security.sudo = {
    enable = true;
    wheelNeedsPassword = false;
  };

  services.logind.extraConfig = ''
    RuntimeDirectorySize=16G
  '';

  services.openssh.enable = true;
  services.openssh.passwordAuthentication = false;
  services.openssh.permitRootLogin = "no";

  services.picom.enable = true;
  services.globalprotect-openconnect.enable = true;

  services.xserver = {
    enable = true;
    layout = "us";

    desktopManager = {
      xterm.enable = false;
      wallpaper.mode = "fill";
    };

    displayManager = {
      autoLogin = {
        enable = true;
        user = "astasko";
      };
      defaultSession = "none+i3";
      lightdm.enable = true;
    };

    windowManager.i3 = {
      enable = true;
      package = pkgs.i3-gaps;
      extraPackages = [ pkgs.i3status pkgs.i3lock pkgs.i3blocks pkgs.rofi ];
    };
  };

  sound.enable = true;

  system.stateVersion = "22.11";

  time.timeZone = "Asia/Tbilisi";

  users.mutableUsers = false;

  users.users.astasko = {
    extraGroups = [ "audio" "docker" "wheel" ];
    hashedPassword = "";
    home = "/home/astasko";
    isNormalUser = true;
    shell = pkgs.zsh;
  };

  virtualisation = {
    containerd = {
      enable = true;
      settings = 
        let
          fullCNIPlugins = pkgs.buildEnv {
            name = "full-cni";
            paths = with pkgs;[
              cni-plugins
              cni-plugin-flannel
            ];
          };
        in {
          plugins."io.containerd.grpc.v1.cri".cni = {
            bin_dir = "${fullCNIPlugins}/bin";
            conf_dir = "/var/lib/rancher/k3s/agent/etc/cni/net.d/";
          };
        };
    };

    docker.enable = true;

    podman = {
      enable = true;
      extraPackages = with pkgs; [ zfs ];
    };
  };

  programs._1password-gui.enable = true;
  programs.teams.enable = true;
}
