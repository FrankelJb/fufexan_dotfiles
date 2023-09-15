{
  config,
  lib,
  ...
}:
# networking configuration
{
  networking = {
    # firewall = {
    #   trustedInterfaces = ["tailscale0"];
    #   # required to connect to Tailscale exit nodes
    #   checkReversePath = "loose";
    #
    #   allowedUDPPorts = [
    #     # allow the Tailscale UDP port through the firewall
    #     config.services.tailscale.port
    #     5353
    #     # syncthing QUIC
    #     22000
    #     # syncthing discovery broadcast on ipv4 and multicast ipv6
    #     21027
    #   ];
    #
    #   allowedTCPPorts = [
    #     42355
    #     # syncthing
    #     22000
    #   ];
    # };
    nameservers = ["127.0.0.1" "::1" "192.168.1.200"];

    networkmanager = {
      enable = true;
      dns = "systemd-resolved";
    };
  };

  services = {
    # network discovery, mDNS
    avahi = {
      enable = true;
      nssmdns = true;
      publish = {
        enable = true;
        domain = true;
        userServices = true;
      };
    };

    # DNS resolver
    resolved.enable = true;

    # inter-machine VPN
    tailscale.enable = true;
  };

  # Don't wait for network startup
  systemd.services.NetworkManager-wait-online.enable = lib.mkForce false;
}
