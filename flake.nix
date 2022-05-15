{
  description = "Dev environment for The Haskell Language book";

  inputs = {

    # Utility library for backwards compatibility with the old Nix CLI.
    flake-compat = {
      url =
        "github:edolstra/flake-compat?rev=b4a34015c698c7793d592d66adbab377907a2be8";
      flake = false;
    };

    # Unofficial library of utilities for managing Nix Flakes.
    flake-utils.url =
      "github:numtide/flake-utils?rev=12806d31a381e7cd169a6bac35590e7b36dc5fe5";

    nixpkgs.url =
      "github:nixos/nixpkgs?rev=bef07673d323a9c489a664ba7dee3dd10468a293";

    # The Haskell Language Server IDE tooling.
    hls = {
      inputs.flake-compat.follows = "flake-compat";
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
      url =
        "github:haskell/haskell-language-server?rev=b1bf5499155e259341e4868863b0fd743b6bd65f";
    };
  };

  outputs = { self, flake-compat, flake-utils, hls, nixpkgs }:
    flake-utils.lib.eachSystem [
      "x86_64-linux"
      "x86_64-darwin"
      #TODO: HLS' flake doesn't support this arch for some reason, perhaps create an issue for this
      #"aarch64-linux"
      "aarch64-darwin"
    ] (system:
      let
        lib = nixpkgs.lib;
        compiler-version = "ghc922";
        pkgs = nixpkgs.legacyPackages.${system};
        haskell-language-server =
          hls.packages.${system}."haskell-language-server-${
            lib.removePrefix "ghc" compiler-version
          }";
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
            haskell-language-server
          ];
          libraries = with pkgs; [ zlib ];
          libraryPath = "${lib.makeLibraryPath libraries}";
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
