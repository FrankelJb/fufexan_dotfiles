lib: {
  browser = "firefox";
  launcher = "anyrun";

  terminal = {
    font = "JetBrainsMono Nerd Font";
    name = "foot";
    opacity = 0.9;
    size = 10;
  };

  wallpaper = let
    url = "https://www.nasa.gov/sites/default/files/thumbnails/image/stsci-01h44ay5ztcv1npb227b2p650j.png";
    sha256 = "158iyidmz2pvcp0yinq4yzhny3wmrc2isrs39ilh5r345dkinzj1";
    ext = lib.last (lib.splitString "." url);
  in
    builtins.fetchurl {
      name = "wallpaper-${sha256}.${ext}";
      inherit url sha256;
    };
}
