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
          sha256 = "f807c11094652e9e4aeb2de47f8506ca0f34c9d0882b70f9b31e0b658bfadaa9";
        };
        x86_64-darwin = {
          target = "x86_64-apple-darwin";
          sha256 = "230f3ac564e1eb132cdf172ca167814484c3ef715969af25ef4186684ef7f401";
        };
        x86_64-linux = {
          target = "x86_64-unknown-linux-gnu";
          sha256 = "7cd2747855e68b84fb5278f1ed702326456424afbbca49715a671f477c54e074";
        };
        i686-linux = {
          target = "i686-unknown-linux-gnu";
          sha256 = "91d33a00acfeb9c543242739824b7d96273fd8bfbc119470bc60fd5afb1108c9";
        };
      };
    in eachSystem (mapAttrsToList (n: v: n) systems) (system: {
      packages.default = with import nixpkgs { inherit system; };

        stdenv.mkDerivation rec {
          name = "crude-${version}";
          version = "0.1.4";

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
