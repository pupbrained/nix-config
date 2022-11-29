{
  inputs,
  config,
  pkgs,
  lib,
  ...
}:
with lib; {
  disabledModules = ["services/hardware/udev.nix"];

  imports = [
    ./hardware-configuration.nix
    ../generic.nix
    ../patches/udev.nix
  ];

  boot = {
    loader = {
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot/efi";
      };
      grub = {
        enable = true;
        device = "nodev";
        efiSupport = true;
        useOSProber = false;
        version = 2;
      };
    };

    kernelPackages = pkgs.linuxPackages_zen;
  };

  networking = {
    hostName = "dell";
    networkmanager.enable = true;
  };

  time.timeZone = "America/New_York";

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  services.logind = {
    lidSwitch = "ignore";
    lidSwitchDocked = "ignore";
  };

  hardware = {
    nvidia = {
      modesetting.enable = true;
      open = true;
      powerManagement.enable = true;
      package = config.boot.kernelPackages.nvidiaPackages.beta;
    };

    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
      extraPackages = with pkgs; [
        vaapiVdpau
        libvdpau-va-gl
        nvidia-vaapi-driver
      ];
    };

    i2c.enable = true;
  };

  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = ["nix-command" "flakes"];

  environment.systemPackages = with pkgs; [
    micro
    vim
    git
    wget
    nodejs-19_x
    redis
    ffmpeg
    elasticsearch7
    nodePackages.pm2
    python311
    direnv
    nvfetcher
    nodePackages.yarn
    alejandra
    comma
    python311Packages.pip
    python311Packages.miniupnpc
  ];

  services.postgresql = {
    enable = true;
    package = pkgs.postgresql;
    enableTCPIP = true;
    authentication = lib.mkOverride 10 ''
      local   all             postgres                                trust
      local   giteadb    		gitea    							trust

      # TYPE  DATABASE        USER            ADDRESS                 METHOD

      # "local" is for Unix domain socket connections only
      local   all             all                                     trust
      # IPv4 local connections:
      host    all             all             127.0.0.1/32            trust
      # IPv6 local connections:
      host    all             all             ::1/128                 trust
      # Allow replication connections from localhost, by a user with the
      # replication privilege.
      local   replication     all                                     trust
      host    replication     all             127.0.0.1/32            trust
      host    replication     all             ::1/128                 trust
    '';
  };

  services.caddy = {
    enable = true;
    extraConfig = ''
      mk.pupbrained.xyz {
      	tls /etc/letsencrypt/live/mk.pupbrained.xyz/fullchain.pem /etc/letsencrypt/live/mk.pupbrained.xyz/privkey.pem
      	reverse_proxy 127.0.0.1:3020
      	encode zstd gzip
      }

      git.pupbrained.xyz {
      	tls /etc/letsencrypt/live/git.pupbrained.xyz/fullchain.pem /etc/letsencrypt/live/git.pupbrained.xyz/privkey.pem
      	reverse_proxy 127.0.0.1:3099
      }

      code.pupbrained.xyz {
      	tls /etc/letsencrypt/live/code.pupbrained.xyz/fullchain.pem /etc/letsencrypt/live/code.pupbrained.xyz/privkey.pem
      	reverse_proxy 127.0.0.1:3152
      }

      img.pupbrained.xyz {
      	tls /etc/letsencrypt/live/img.pupbrained.xyz/fullchain.pem /etc/letsencrypt/live/img.pupbrained.xyz/privkey.pem
      	reverse_proxy 127.0.0.1:8071
      }

      zbin.pupbrained.xyz {
      	encode gzip
      	tls /etc/letsencrypt/live/zbin.pupbrained.xyz/fullchain.pem /etc/letsencrypt/live/zbin.pupbrained.xyz/privkey.pem

      	handle_path /api/* {
      		reverse_proxy 127.0.0.1:4320
      	}

      	handle {
      		root * /home/marshall/zer0bin/frontend/dist
      		try_files {path} /index.html
      		file_server
      	}
      }
    '';
  };

  powerManagement.cpuFreqGovernor = "performance";

  services.openssh.enable = true;
  documentation.man.man-db.enable = false;

  nix.settings.trusted-users = ["root" "marshall"];

  networking.firewall.enable = false;

  system.stateVersion = "23.05";
}
