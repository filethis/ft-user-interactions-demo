# Project Initialization -----------------------------------------------------------------------------------

.PHONY: github-init
github-init:  ## Initialize GitHub project
	@check GitHub repo exists first; \
	git init; \
	git add .; \
	git commit -m "First commit"; \
	git remote add origin https://github.com/${GITHUB_USER}/${NAME}.git; \
	git push -u origin master

.PHONY: bower-install
bower-install:  ## Install all Bower dependencies specified in bower.json file
	@bower install --save

.PHONY: bower-update
bower-update:  ## Update all Bower dependencies specified in bower.json file
	@bower update --save


# Testing -----------------------------------------------------------------------------------

.PHONY: test
test:  ## Run tests on all browsers
	@polymer test

.PHONY: test-chrome
test-chrome:  ## Run tests on Chrome only
	@polymer test -l chrome

.PHONY: test-firefox
test-firefox:  ## Run tests on Firefox only
	@polymer test -l firefox

.PHONY: test-safari
test-safari:  ## Run tests on Safari only
	@polymer test -l safari


# Running -----------------------------------------------------------------------------------

.PHONY: serve-polymer
serve-polymer:  ## Serve project locally using the Polymer server
	@polymer serve --port ${PORT}


# GitHub

.PHONY: open-url-github-page
open-url-github-page:  ## Open URL of project GitHub repository page
	@open https://github.com/filethis/${NAME}

.PHONY: print-url-github-page
print-url-github-page:  ## Print URL of project GitHub repository page
	@echo https://github.com/filethis/${NAME}


# Publishing -----------------------------------------------------------------------------------

.PHONY: tag-release
tag-release:  ## Tag the git project for the next release.
	@git tag -a v${VERSION} -m '${VERSION}'

.PHONY: git-push-tags
git-push-tags:
	@git push --tags


# Help -----------------------------------------------------------------------------------

.PHONY: help
help:  ## Print Makefile usage. See: https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
	@grep -h -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.DEFAULT_GOAL := help
