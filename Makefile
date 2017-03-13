# Some simple targets that do useful things


# Project configuration

NAME=ft-user-interactions-demo
TYPE=app
PORT=3002


# Boilerplate targets

.PHONY: lint
lint:
	if [ "${TYPE}" = "element" ]; then \
		polymer lint --input ${NAME}.html; \
	else \
		polymer lint --root src/ --input ${NAME}/${NAME}.html; \
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

.PHONY: register
register:
	bower register ${NAME} git://github.com/filethis/${NAME}.git
