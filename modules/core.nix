{ pkgs
, lib
, ...
}:
# configuration shared by all hosts
{
  documentation.dev.enable = true;

  i18n = {
    defaultLocale = "en_US.UTF-8";
  };

  # graphics drivers / HW accel
  hardware.opengl.enable = true;

  # enable programs
  programs = {
    less.enable = true;
  };

  # don't touch this
  system.stateVersion = lib.mkDefault "23.11";

  time.timeZone = lib.mkDefault "Asia/Singapore";

  users.users.beans = {
    isNormalUser = true;
    shell = pkgs.bash;
    extraGroups = [ "libvirtd" "networkmanager" "wheel" ];
  };

  virtualisation = {
    libvirtd.enable = true;
  };
  
  virtualisation = {
    libvirtd.enable = true;
  };

  # compresses half the ram for use as swap
  zramSwap.enable = true;
}
