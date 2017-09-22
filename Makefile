default: js

ELM_FILES = $(shell find src -type f -name '*.elm' -not -name '.\#*')

all: elm.js wine-club-app.css
wine-club-app.css: sass css/wine-club-app.sass css/wine-club-app.css
js: elm.js

elm.js: $(ELM_FILES)
	elm-make --yes src/Main.elm --output ./elm.js

clean-deps:
	rm -rf ./elm-stuff

clean:
	rm -f elm.js
	rm -rf elm-stuff/build-artifacts

debug:
	elm-make --debug --yes src/Main.elm --output ./elm.js

realclean: clean clean-deps

watch:
	@make js || true
	@echo "Watching for changes..."
	@fswatch src/ css/wine-club-app.sass | grep --line-buffered -v '.\#' | while read -r changed; do date; echo "MODIFIED: $$changed"; make all || true; done

.PHONY: js
.PHONY: realclean