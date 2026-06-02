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
          sha256 = "f96cb71a1635f02ea2ae4a3947a1969f57b828c9208b6047e22a9d012f4c2ad3";
        };
        x86_64-darwin = {
          target = "x86_64-apple-darwin";
          sha256 = "31a5de40f4bfe14ada2c4a61f0845fde726a12aba367addbf46ff3ad955a641e";
        };
        x86_64-linux = {
          target = "x86_64-unknown-linux-gnu";
          sha256 = "511c96331f4ce02d2963e5ed4ffd782bef31f37ddafaec67c3a5df4b88469555";
        };
        i686-linux = {
          target = "i686-unknown-linux-gnu";
          sha256 = "f674445e296c4d1f658e86f365aeea72f08ae8e0d67d9dc7c4691059c28c9578";
        };
      };
    in eachSystem (mapAttrsToList (n: v: n) systems) (system: {
      packages.default = with import nixpkgs { inherit system; };

        stdenv.mkDerivation rec {
          name = "crude-${version}";
          version = "0.1.5";

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
