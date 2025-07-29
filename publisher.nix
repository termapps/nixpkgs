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
          sha256 = "7c033ac90e174f8e3c75f884032c1a37a9bde16b31028ff9698f83e7591c2241";
        };
        x86_64-darwin = {
          target = "x86_64-apple-darwin";
          sha256 = "ff7ed5f13d794c7e157ffe0aa6bd67d02d49d4aa7a087ca2d778db89c343b8a3";
        };
        x86_64-linux = {
          target = "x86_64-unknown-linux-gnu";
          sha256 = "59bba724afdfdc9f1ef948c5076d6c8960fbc2b2f29bc2abc26d3ecf1ecd497c";
        };
        i686-linux = {
          target = "i686-unknown-linux-gnu";
          sha256 = "c281c764257f242770d839ef836d952a0fabcd7b48395ff7cde08bedd1934353";
        };
      };
    in eachSystem (mapAttrsToList (n: v: n) systems) (system: {
      packages.default = with import nixpkgs { inherit system; };

        stdenv.mkDerivation rec {
          name = "publisher-${version}";
          version = "0.1.14";

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
