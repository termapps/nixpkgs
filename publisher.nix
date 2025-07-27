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
          sha256 = "29f881a9a1d1c075b99b3b8a3ac3a9fa84a8d466927b92129ff2573c07ddbeab";
        };
        x86_64-darwin = {
          target = "x86_64-apple-darwin";
          sha256 = "9479f00717be9c294804a847e0df92d3a58fef2fc8cf08b62acc408c863fa344";
        };
        x86_64-linux = {
          target = "x86_64-unknown-linux-gnu";
          sha256 = "f3f372638d4bc504632d3cef8f6510263b2a882263a680b5458e0f98e97d23d6";
        };
        i686-linux = {
          target = "i686-unknown-linux-gnu";
          sha256 = "cbd12fc0771f0c8a6f76731aa1cfe061ddbe122b6ff31fc56190575af4ecea98";
        };
      };
    in eachSystem (mapAttrsToList (n: v: n) systems) (system: {
      packages.default = with import nixpkgs { inherit system; };

        stdenv.mkDerivation rec {
          name = "publisher-${version}";
          version = "0.1.13";

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
