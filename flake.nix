{
  description = "Dev environment for The Haskell Language book";

  inputs = {

    # Unofficial library of utilities for managing Nix Flakes.
    flake-utils.url = "github:numtide/flake-utils";

    nixpkgs.url =
      "github:nixos/nixpkgs?rev=bef07673d323a9c489a664ba7dee3dd10468a293";
  };

  outputs = { self, flake-utils, nixpkgs, ... }:
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
            # TODO: Provide HLS from their flake
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
            export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:${libraryPath}"
            export LIBRARY_PATH="${libraryPath}"
          '';
        };
      });
}
