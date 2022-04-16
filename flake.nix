{
  description = "Dev environment for The Haskell Language book";

  inputs = {

    # Utility library for backwards compatibility with the old Nix CLI.
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };

    # Unofficial library of utilities for managing Nix Flakes.
    flake-utils.url = "github:numtide/flake-utils";

    nixpkgs.url =
      "github:nixos/nixpkgs?rev=bef07673d323a9c489a664ba7dee3dd10468a293";

    # TODO: Provide HLS from their flake
  };

  outputs = { self, flake-compat, flake-utils, nixpkgs, ... }:
    flake-utils.lib.eachSystem [
      "x86_64-linux"
      "x86_64-darwin"
      "aarch64-linux"
      "aarch64-darwin"
    ] (system:
      let
        compiler-version = "ghc922";
        pkgs = nixpkgs.legacyPackages.${system};
      in {
        # Setup development environment
        devShells.default = let
          hs = pkgs.haskell.packages.${compiler-version};
          tools = [
            pkgs.binutils-unwrapped
            pkgs.gnumake
            pkgs.nodejs-17_x
            (pkgs.aspellWithDicts (d: [ d.en d.en-computers d.en-science ]))
            pkgs.hlint
            hs.ghc
            hs.cabal-install
            hs.ghcid
            hs.fourmolu
          ];
          libraries = with pkgs; [ zlib ];
          libraryPath = "${pkgs.lib.makeLibraryPath libraries}";
        in pkgs.mkShell {
          buildInputs = tools ++ libraries;
          shellHook = ''
            export MAKEFLAGS="-j2"
            export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:${libraryPath}"
            export LIBRARY_PATH="${libraryPath}"
          '';
        };
      });
}
