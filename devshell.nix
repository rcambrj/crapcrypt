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
  env = { };

  # Load custom bash code
  shellHook = ''

  '';
}
