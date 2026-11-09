{ config, lib, pkgs, inputs, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/virtualisation/proxmox-lxc.nix")
    ../../modules/common/fonts.nix
  ];

  fonts = {
    enableDefaultPackages = true;
    fontDir.enable = true;
    fontconfig = {
      enable = true;
      defaultFonts = {
        monospace = [ "FiraCode Nerd Font" "Noto Color Emoji"];
        sansSerif = [ "Noto Sans" "Symbols Nerd Font"];
      };
    };
  };
  services.avahi.enable = false;

  environment.variables = {
    LIBSEAT_BACKEND = "seatd";
    XDG_SESSION_TYPE = "wayland";
    XDG_CURRENT_DESKTOP = "niri";
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  programs.zsh.enable = true;
  programs.niri.enable = true;

  hardware.graphics = {
    enable = lib.mkForce true;
    enable32Bit = lib.mkForce true;
    extraPackages = with pkgs; [
      mesa
      libglvnd
    ];
  };

  services.udev.enable = lib.mkForce false;
  services.seatd.enable = true;
  services.dbus.enable = true;
  security.polkit.enable = true;

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.writeShellScript "start-niri-lxc" ''
          export XDG_RUNTIME_DIR=/run/user/$(id -u)
          export LIBSEAT_BACKEND=seatd
          export GBM_BACKENDS_PATH="${pkgs.mesa}/lib/gbm:/run/opengl-driver/lib/gbm"
          export LIBGL_DRIVERS_PATH="${pkgs.mesa}/lib/dri:/run/opengl-driver/lib/dri"
          export __EGL_VENDOR_LIBRARY_DIRS="${pkgs.mesa}/share/glvnd/egl_vendor.d:/run/opengl-driver/share/glvnd/egl_vendor.d"
          export MESA_LOADER_DRIVER_OVERRIDE=nouveau
          export GALLIUM_DRIVER=nouveau
          export RUST_LOG="niri=debug,smithay=debug"
	  /run/wrappers/bin/sunshine &
          exec ${pkgs.dbus}/bin/dbus-run-session ${pkgs.niri}/bin/niri --session > /tmp/niri.log 2>&1
        ''}";
        user = "andreas";
      };
    };
  };

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk pkgs.xdg-desktop-portal-gnome ];
  };

  users.mutableUsers = true;

  users.users.andreas = {
    isNormalUser = true;
    description = "Dev account";
    extraGroups = [ "wheel" "video" "audio" "seat" "input" "render" "networkmanager" ];
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCjcUkwnShwD8b/5JV/CfXNNtkcTnjRvIM/KpNM3U+CXzuynzOPFR2ZpsYh7ZhLeZLiMbplOYiZaGzcqmeuNjVy3W8JM4yuvom/Qi2ImgRtTZH8Ylr8Fbe/DciGmi0E0kfIJx7PsI1bn2uadt6KbyOTyiSUW0Uiqjdqlv64mvWJBgQg/MsP53vLt+Z+RgHuHyS4wzEdhcx3WC19NJM/ZJwcL1Z6IF63qnyPStOCFwEHhn2CJ0gnX22eicwIQRI2Df7mti6Zkng6ftOnxTNTsQL+Yhe+WZg1hHNMkbukSFuLC1H4/TEs/eC2m6MYs8ATUibHc+1lLaQAIIZGyHjcxAofl585aID+ZF5qdIxtClbulh6l+N/j75AGFhhbsUvnyKGz8NL1VtR5dBlqbn8ENJc9Bca++mDxZV9lpqYzLp8Rt+J0/jG+/P2bQtTIYkU2XSl0Pcl+DVspUqaTL+r/f8KR4dF7MnMBCqfWPAdO7h+UgTv67rr7u3Whgc3SYMjpb63lUPmh+ImW96TZQOBI08ZExp42Zd3zWHiT+5PP40x30L8rPaVpiZvypZcpgcYPoSEFVBLn8WKyVlg+zHdo3IZr5YfXr4j1A6O98OKEIja7ug0bCFQOmeOFwmqxC4lhf4Tj3CRGrOI8oap3vGC8ffO6IwxaatBeYkfMy4eyLXRcGQ== andreas.fosshaug@gmail.com"
    ];
  };

  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "yes";
  };

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  services.sunshine = {
    enable = true;
    autoStart = false;
    openFirewall = true;
    capSysAdmin = true;
    settings = {
      encoder = "software";
      capture = "wlr";
    };
  };

  networking = {
    useDHCP = false;
    defaultGateway = { address = "192.168.68.1"; interface = "eth0"; };
    nameservers = [ "192.168.68.1" "1.1.1.1" ];
    interfaces.eth0.ipv4.addresses = [{
      address = "192.168.68.30";
      prefixLength = 22;
    }];
    firewall.enable = false;
  };

  environment.systemPackages = with pkgs; [
    nano
    curl
    wget
    zed-editor

    mesa-demos
    git
    wayvnc
    alacritty
    fuzzel
    xwayland-satellite
    pipewire
    wireplumber
    inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  systemd = {
    tmpfiles.rules = [
      "d /run/user/1000 0700 andreas users -"
      "d /tmp/.X11-unix 1777 root root -"
      "L+ /run/opengl-driver - - - - ${pkgs.mesa}"
      "L+ /run/udev - - - - /mnt/host-udev"
    ];
    user.services.sunshine.enable = false;

    services.systemd-udevd.enable = false;
    sockets = {
      systemd-udevd-control.enable = false;
      systemd-udevd-kernel.enable = false;
    };
  };


  programs.nix-ld.enable = true;
  system.stateVersion = "26.05";
}
