# home server configuration
{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    #./mailserver.nix
    ./services.nix
  ];

  boot.loader.grub = {
    enable = true;
    version = 2;
    device = "/dev/sda";
  };

  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
    "net.ipv6.conf.all.forwarding" = 1;
  };

  # network
  networking.hostName = "homesv";

  services = {
    # don't suspend when lid is closed
    logind.lidSwitch = "ignore";

    # keep journal
    journald.extraConfig = lib.mkForce "";
  };

  users.users = {
    user.isSystemUser = true;
    user.group = "user";
  };
  users.groups.user = { };

  system.stateVersion = lib.mkForce "21.05";
}
