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
    hashedPassword = "$6$7T6zSJLl5wYQWz0W$hDTWqSOrE484WnOea/Ucj9iz7HRU9IqwdM1RMPfPb2J7eim9rd4gI3JSlwE1OG.eabFeHsMrjJictMexMzweB1";
  };

  virtualisation = {
    libvirtd.enable = true;
  };

  # compresses half the ram for use as swap
  zramSwap.enable = true;
}
