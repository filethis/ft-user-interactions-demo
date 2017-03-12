# Some simple targets that do useful things


# Project configuration

PORT=3000
NAME=ft-user-interaction-form


# Boilerplate targets

.PHONY: build
build:
	polymer build

.PHONY: lint
lint:
	polymer lint

.PHONY: push
push:
	git push origin

.PHONY: pull
pull:
	git pull origin

.PHONY: register
register:
	bower register ${NAME} git://github.com/filethis/${NAME}.git

.PHONY: serve
serve:
	polymer serve --port ${PORT}

.PHONY: open-app
open-app:
	open http://localhost:${PORT}

.PHONY: open-demo
open-demo:
	open http://localhost:${PORT}/demo/

.PHONY: open-docs
open-docs:
	open http://localhost:${PORT}/components/${NAME}

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

.PHONY: test-interactive
test-interactive:
	open http://localhost:${PORT}/components/${NAME}/test/${NAME}_test.html
