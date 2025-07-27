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
          sha256 = "7a05314093a6385f499d907a3b860b995877daae517564c180f6c7ea7c68827b";
        };
        x86_64-darwin = {
          target = "x86_64-apple-darwin";
          sha256 = "8a170e3a0f7c99da2de433a3f2816862d6763d17233f662d72bfe6f57fd4253b";
        };
        x86_64-linux = {
          target = "x86_64-unknown-linux-gnu";
          sha256 = "b3238d3649b0692aff8a955a4752d5fe925c9d32d4ec43ee0e9a86917a84748b";
        };
        i686-linux = {
          target = "i686-unknown-linux-gnu";
          sha256 = "63870da1c6a964cc09dc4d59481ce2e77962319ff7c86c4a5a0751bc54398e16";
        };
      };
    in eachSystem (mapAttrsToList (n: v: n) systems) (system: {
      packages.default = with import nixpkgs { inherit system; };

        stdenv.mkDerivation rec {
          name = "crude-${version}";
          version = "0.1.1";

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
