{
  inputs,
  config,
  pkgs,
  lib,
  ...
}:
with lib; {
  disabledModules = ["services/hardware/udev.nix"];

  imports =
    [
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
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  environment.systemPackages = with pkgs; [
    micro
    git
    wget
  ];

  powerManagement.cpuFreqGovernor = "performance";

  services.openssh.enable = true;
  documentation.man.man-db.enable = false;

  nix.settings.trusted-users = ["root" "marshall"];

  networking.firewall.allowedTCPPorts = [ 3020 ];
  networking.firewall.allowedUDPPorts = [ 3020 ];
  
  system.stateVersion = "23.05";
}
