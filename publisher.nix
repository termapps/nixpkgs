{
  description = "Tool to publish & distribute CLI tools";

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
          sha256 = "fe79f3736f61ef0dc818ece359a04b60e5eabbf7212e5d02ec85c5873d890d50\n";
        };
        x86_64-darwin = {
          target = "x86_64-apple-darwin";
          sha256 = "c554c0546f778b8a309dc367517fc9dce746a09b16957c5b773988981ab1bc3b\n";
        };
        x86_64-linux = {
          target = "x86_64-unknown-linux-gnu";
          sha256 = "d6bd904ce5ba43c2131ded756031bcbece1f081740ef65ac96f565bd7ca6bd01\n";
        };
        i686-linux = {
          target = "i686-unknown-linux-gnu";
          sha256 = "5df019fc45a81f55d4b1dddb79d0c63981db338ff84d5e8da7739eb1dad11576\n";
        };
      };
    in eachSystem (mapAttrsToList (n: v: n) systems) (system: {
      packages.default = with import nixpkgs { inherit system; };

        stdenv.mkDerivation rec {
          name = "publisher-${version}";
          version = "0.1.12";

          nativeBuildInputs = [ unzip ];

          src = pkgs.fetchurl {
            url = "https://github.com/termapps/publisher/releases/download/v${version}/publisher-v${version}-${systems.${system}.target}.zip";
            inherit (systems.${system}) sha256;
          };

          sourceRoot = ".";

          installPhase = ''
            install -Dm755 publisher $out/bin/publisher
            install -Dm755 LICENSE $out/share/licenses/publisher/LICENSE
          '';

          meta = {
            description = "Tool to publish & distribute CLI tools";
            homepage = "https://github.com/termapps/publisher";
            platforms = [ system ];
          };
        };
    });
}
