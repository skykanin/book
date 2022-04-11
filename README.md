# The Haskell Programming Language

Repository for "The Haskell Programming Language" book.

## Development

This project provides a development environment using [Nix](https://nixos.org/download.html).
If you don't want to use Nix you will need to provide the build tools yourself. See the `flake.nix` file
for neccessary dependencies. If you want to use the new Nix CLI you will need to use Nix v2.7+.

### Entering the development environment

To enter the development environment run:

```sh
nix develop -j<N>
```

if you're using the new CLI or

```sh
nix-shell -j<N> -A outputs.devShells.<SYSTEM>.default
```

if you're using the old CLI where `<SYSTEM>` is your system architecture i.e. `x86_64-linux`. See the `flake.nix` file for all supported system architectures.

If you can't be bothered to specify your system architecture manually you can run this Nix expression which will pass your current system architecture automatically

```sh
nix-shell -j<N> -E "with import <nixpkgs> { }; with import ./shell.nix; outputs.devShells.\${system}.default"
```

Note that this uses `nixpkgs` from your `$NIX_PATH`.

### Building

Then install necessary dependencies using

```sh
make install
```

To build the project run

```sh
make build
```

and if you want a development server for watching the files run

```sh
make watch
```

## Contributing

TODO
