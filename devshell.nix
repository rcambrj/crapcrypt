{ pkgs }:
pkgs.mkShell {
  # Add build dependencies
  packages = [
    pkgs.coreutils
    pkgs.unzip
    pkgs.openssl
    pkgs.curl
    pkgs.jq
    pkgs.imagemagick
    pkgs.pdftk
    pkgs.rar
  ];

  # Add environment variables
  env = {
    FONTCONFIG_FILE = pkgs.makeFontsConf {
      fontDirectories = [ pkgs.freefont_ttf ];
    };
   };

  # Load custom bash code
  shellHook = ''

  '';
}
