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
          sha256 = "dc7543ed097f418948bac39739232110117867db420fd901d8912e01e1aef8b3";
        };
        x86_64-darwin = {
          target = "x86_64-apple-darwin";
          sha256 = "d7a25aa144379f39637978bfc99a4247e9f87373bee2cf0c135e628efed251c3";
        };
        x86_64-linux = {
          target = "x86_64-unknown-linux-gnu";
          sha256 = "39c3b500da83383cd49062bd03a8e5aeab671791cab0735c0c81ea5952954fcd";
        };
        i686-linux = {
          target = "i686-unknown-linux-gnu";
          sha256 = "9cc1f0d143417d82341a2d0f76706e873382f938e811840b05b17428405cf88e";
        };
      };
    in eachSystem (mapAttrsToList (n: v: n) systems) (system: {
      packages.default = with import nixpkgs { inherit system; };

        stdenv.mkDerivation rec {
          name = "crude-${version}";
          version = "0.1.0";

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
