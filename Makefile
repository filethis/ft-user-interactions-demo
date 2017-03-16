# Some simple targets that do useful things


# Project configuration

NAME=ft-user-interactions-demo
VERSION=0.0.3
TYPE=app
PORT=3002


# Boilerplate targets

.PHONY: lint
lint:
	@if [ "${TYPE}" = "element" ]; then \
		polymer lint --input ${NAME}.html; \
	else \
		polymer lint --root src/ --input ${NAME}.html; \
	fi;

.PHONY: build
build:
	@if [ "${TYPE}" = "element" ]; then \
		echo Cannot build an element project; \
	else \
		polymer build; \
	fi;

.PHONY: test
test:
	@polymer test

.PHONY: test-chrome
test-chrome:
	@polymer test -l chrome

.PHONY: test-firefox
test-firefox:
	@polymer test -l firefox

.PHONY: test-safari
test-safari:
	@polymer test -l safari

.PHONY: serve
serve:
	@polymer serve --port ${PORT}

.PHONY: browser-sync
browser-sync:
	@if [ "${TYPE}" = "element" ]; then \
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
	@if [ "${TYPE}" = "element" ]; then \
		open http://localhost:${PORT}/components/${NAME}/demo/; \
	else \
		open http://localhost:${PORT}; \
	fi;

.PHONY: url
url:
	@if [ "${TYPE}" = "element" ]; then \
		echo http://localhost:${PORT}/components/${NAME}/demo/; \
	else \
		echo http://localhost:${PORT}; \
	fi;

.PHONY: open-published
open-published:
	@if [ "${TYPE}" = "element" ]; then \
		open https://filethis.github.io/${NAME}/components/${NAME}/demo; \
	else \
		open https://filethis.github.io/${NAME}; \
	fi;

.PHONY: url-published
url-published:
	@if [ "${TYPE}" = "element" ]; then \
		echo https://filethis.github.io/${NAME}/components/${NAME}/demo; \
	else \
		echo https://filethis.github.io/${NAME}; \
	fi;


.PHONY: open-docs
open-docs:
	@if [ "${TYPE}" = "element" ]; then \
		open http://localhost:${PORT}/components/${NAME}/; \
	else \
		echo App projects do not have documentation pages; \
	fi;

.PHONY: url-docs
url-docs:
	@if [ "${TYPE}" = "element" ]; then \
		echo http://localhost:${PORT}/components/${NAME}/; \
	else \
		echo App projects do not have documentation pages; \
	fi;

.PHONY: open-docs-published
open-docs-published:
	@if [ "${TYPE}" = "element" ]; then \
		open https://filethis.github.io/${NAME}/components/${NAME}/; \
	else \
		echo App projects do not have documentation pages; \
	fi;

.PHONY: url-docs-published
url-docs-published:
	@if [ "${TYPE}" = "element" ]; then \
		echo https://filethis.github.io/${NAME}/components/${NAME}/; \
	else \
		echo App projects do not have documentation pages; \
	fi;


.PHONY: open-github
open-github:
	@open https://github.com/filethis/${NAME}

.PHONY: url-github
url-github:
	@echo https://github.com/filethis/${NAME}


.PHONY: git-tag-version
git-tag-version:
	@git tag -a v${VERSION} -m '${VERSION}'

.PHONY: git-push-tags
git-push-tags:
	@git push --tags

.PHONY: github-pages
github-pages:
	if [ "${TYPE}" = "element" ]; then \
		set -e; \
		rm -rf ./docs-github-tmp; \
		mkdir -p docs-github-tmp; \
		cd ./docs-github-tmp; \
		gp.sh filethis ${NAME}; \
		cd ../; \
		rm -rf ./docs-github-tmp; \
	else \
		gh-pages \
			--repo https://github.com/filethis/${NAME}.git \
			--branch gh-pages \
			--dist ./ ; \
	fi;

.PHONY: publish
publish: git-tag-version git-push-tags github-pages open-docs-published
	echo Published version {VERSION};


.PHONY: register
register:
	@if [ "${TYPE}" = "element" ]; then \
		bower register ${NAME} git@github.com:filethis/${NAME}.git \
	else \
		echo App projects do not get registered; \
	fi;


.PHONY: install-tools
install-tools:
	npm install gh-pages -g;