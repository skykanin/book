.PHONY : clean all

all: | clean watch

build:
	@cabal build book

clean:
	@cabal run book clean

watch:
	@cabal run book watch

format:
	@fourmolu -i app/Main.hs
