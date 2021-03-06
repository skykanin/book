.PHONY : all watch

watch: | watch-css watch-book

all: | clean build

install:
	@npm install

build:
	@npm run build:css
	@cabal build exe:book

clean:
	rm css/__global.css 2>/dev/null
	@cabal run book clean

watch-css:
	@npm run watch:css

watch-book: |
	@cabal run book clean
	@cabal run book watch

format:
	@fourmolu -i app/Main.hs
