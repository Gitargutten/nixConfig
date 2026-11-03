{ config, pkgs, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/virtualisation/proxmox-lxc.nix")
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  programs.zsh.enable = true;

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  users.mutableUsers = true;

  users.users.andreas = {
    isNormalUser = true;
    description = "Dev account";
    extraGroups = [ "wheel" "video" "render" "networkmanager" ];
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCjcUkwnShwD8b/5JV/CfXNNtkcTnjRvIM/KpNM3U+CXzuynzOPFR2ZpsYh7ZhLeZLiMbplOYiZaGzcqmeuNjVy3W8JM4yuvom/Qi2ImgRtTZH8Ylr8Fbe/DciGmi0E0kfIJx7PsI1bn2uadt6KbyOTyiSUW0Uiqjdqlv64mvWJBgQg/MsP53vLt+Z+RgHuHyS4wzEdhcx3WC19NJM/ZJwcL1Z6IF63qnyPStOCFwEHhn2CJ0gnX22eicwIQRI2Df7mti6Zkng6ftOnxTNTsQL+Yhe+WZg1hHNMkbukSFuLC1H4/TEs/eC2m6MYs8ATUibHc+1lLaQAIIZGyHjcxAofl585aID+ZF5qdIxtClbulh6l+N/j75AGFhhbsUvnyKGz8NL1VtR5dBlqbn8ENJc9Bca++mDxZV9lpqYzLp8Rt+J0/jG+/P2bQtTIYkU2XSl0Pcl+DVspUqaTL+r/f8KR4dF7MnMBCqfWPAdO7h+UgTv67rr7u3Whgc3SYMjpb63lUPmh+ImW96TZQOBI08ZExp42Zd3zWHiT+5PP40x30L8rPaVpiZvypZcpgcYPoSEFVBLn8WKyVlg+zHdo3IZr5YfXr4j1A6O98OKEIja7ug0bCFQOmeOFwmqxC4lhf4Tj3CRGrOI8oap3vGC8ffO6IwxaatBeYkfMy4eyLXRcGQ== andreas.fosshaug@gmail.com
    " ];
  };

  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "yes";
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
  ];

  programs.nix-ld.enable = true;
  system.stateVersion = "26.05";
}
