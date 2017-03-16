# Some simple targets that do useful things


# Project configuration

NAME=ft-user-interactions-demo
VERSION=0.0.2
TYPE=app
PORT=3002


# Boilerplate targets

.PHONY: lint
lint:
	if [ "${TYPE}" = "element" ]; then \
		polymer lint --input ${NAME}.html; \
	else \
		polymer lint --root src/ --input ${NAME}.html; \
	fi;

.PHONY: build
build:
	if [ "${TYPE}" = "element" ]; then \
		echo Cannot build an element project; \
		exit 1; \
	fi; \
	polymer build

.PHONY: test
test:
	polymer test

.PHONY: test-chrome
test-chrome:
	polymer test -l chrome

.PHONY: test-firefox
test-firefox:
	polymer test -l firefox

.PHONY: test-safari
test-safari:
	polymer test -l safari

.PHONY: serve
serve:
	polymer serve --port ${PORT}

.PHONY: browser-sync
browser-sync:
	if [ "${TYPE}" = "element" ]; then \
		browser-sync start \
			--proxy "http://localhost:${PORT}" \
			--port ${PORT} \
			--startPath "/components/${NAME}/demo/" \
			--files "*.html, *.css, demo/*.html, demo/*.css, test/*.html"; \
	else \
		browser-sync start \
			--proxy "http://localhost:${PORT}" \
			--port ${PORT} \
			--files "*.html, *.css, src/*.html, src/*.css, test/*.html"; \
	fi;

.PHONY: open
open:
	if [ "${TYPE}" = "element" ]; then \
		open http://localhost:${PORT}/components/${NAME}/demo/; \
	else \
		open http://localhost:${PORT}; \
	fi;

.PHONY: open-docs
open-docs:
	if [ "${TYPE}" = "app" ]; then \
		echo App projects do not have documentation pages; \
		exit 1; \
	fi; \
	open http://localhost:${PORT}/components/${NAME}/

.PHONY: open-docs-github
open-docs-github:
	if [ "${TYPE}" = "app" ]; then \
		echo App projects do not have documentation pages; \
		exit 1; \
	fi; \
	open https://filethis.github.io/${NAME}/components/${NAME}/;

.PHONY: open-landing-github
open-landing-github:
	open https://github.com/filethis/${NAME}

.PHONY: tag-version
tag-version:
	git tag -a v${VERSION} -m '${VERSION}'

.PHONY: push-tags
push-tags:
	git push --tags

.PHONY: docs-github
docs-github:
	if [ "${TYPE}" = "app" ]; then \
		echo App projects do not have documentation pages; \
		exit 1; \
	fi; \
	set -e; \
	rm -rf ./docs-github-tmp; \
	mkdir -p docs-github-tmp; \
	cd ./docs-github-tmp; \
	gp.sh filethis ${NAME}; \
	cd ../; \
	rm -r ./docs-github-tmp

.PHONY: register
register:
	bower register ${NAME} git://github.com/filethis/${NAME}.git

.PHONY: release
release: tag-version push-tags docs-github open-docs-github
	echo Released version {VERSION};
