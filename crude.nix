{
  description = "Migration toolkit for databases";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    with flake-utils.lib;
    with nixpkgs.lib;

    let
      systems = {
        aarch64-darwin = {
          target = "aarch64-apple-darwin";
          sha256 = "91c0dba9a63c7d15c148784b5889c80f2626b1c0f42153ec8bf070633b905c67";
        };
        x86_64-darwin = {
          target = "x86_64-apple-darwin";
          sha256 = "1d24e8f2ec600b544f3acda8004a21810b302fbdb8588e6e64c240a9d7a494a2";
        };
        x86_64-linux = {
          target = "x86_64-unknown-linux-gnu";
          sha256 = "3a743186b5e71fddbbec532037942c6c81d0d1bfd9351f0f1bc05c7c193ec5ea";
        };
        i686-linux = {
          target = "i686-unknown-linux-gnu";
          sha256 = "ee90df6ddd7e4ee0cb79a57434b90b2f5b481cc99b25f95e32ec9fed8e292db7";
        };
      };
    in eachSystem (mapAttrsToList (n: v: n) systems) (system: {
      packages.default = with import nixpkgs { inherit system; };

        stdenv.mkDerivation rec {
          name = "crude-${version}";
          version = "0.1.2";

          nativeBuildInputs = [ unzip ];

          src = pkgs.fetchurl {
            url = "https://github.com/termapps/crude/releases/download/v${version}/crude-v${version}-${systems.${system}.target}.zip";
            inherit (systems.${system}) sha256;
          };

          sourceRoot = ".";

          installPhase = ''
            install -Dm755 crude $out/bin/crude
            install -Dm755 LICENSE $out/share/licenses/crude/LICENSE
          '';

          meta = {
            description = "Migration toolkit for databases";
            homepage = "https://github.com/termapps/crude";
            platforms = [ system ];
          };
        };
    });
}
