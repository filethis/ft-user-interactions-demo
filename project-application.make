# Targets common to both application and element projects
include project-common.make


# Validation -----------------------------------------------------------------------------------

.PHONY: lint
lint:  ## Lint project files
	@polymer lint --root src/ --input ${NAME}.html;


# Building -----------------------------------------------------------------------------------

.PHONY: build
build:  ## Build application
	@polymer build;

build-doc-page: ./doc-page/index.html  ## Build application project documentation page

.PHONY: clean-doc-page
clean-doc-page:  ## Clean application documentation page
	@rm -f ./doc-page/index.html;

./doc-page/index.html: ${PROJECT_PAGE_SOURCE}
	@pandoc ${PROJECT_PAGE_SOURCE} \
		-f markdown \
		-t html \
		-s \
		--css=./doc-page.css \
		-o ./doc-page/index.html; \
	echo ./doc-page/index.html;


# Running -----------------------------------------------------------------------------------

.PHONY: run-browser-sync
run-browser-sync:  ## Run BrowserSync against local files
	@browser-sync start \
		--server \
		--port ${LOCAL_PORT} \
		--files "*.html, *.css, src/*.html, src/*.css, demo/*.json, test/*.html";


# Viewing -----------------------------------------------------------------------------------

.PHONY: open-url
open-url:  ## Open URL of local application
	@open http://localhost:${LOCAL_PORT};

.PHONY: print-url
print-url:  ## Print URL of local application
	@echo http://localhost:${LOCAL_PORT};

.PHONY: open-url-published
open-url-published:  ## Open URL of published application
	@open https://filethis.github.io/${NAME};

.PHONY: print-url-published
print-url-published:  ## Print URL of published application
	@echo https://filethis.github.io/${NAME};

.PHONY: open-url-doc-page
open-url-doc-page:  ## Open URL of local documentation page
	@open file://`pwd`/doc-page/index.html;

.PHONY: print-url-doc-page
print-url-doc-page:  ## Print URL of local documentation page
	@echo file://`pwd`/doc-page/index.html;

.PHONY: open-url-doc-page-published
open-url-doc-page-published:  ## Open URL of published project documentation page
	@open https://filethis.github.io/${NAME};

.PHONY: print-url-doc-page-published
print-url-doc-page-published:  ## Print URL of published project documentation page
	@echo https://filethis.github.io/${NAME};


# Publishing -----------------------------------------------------------------------------------

.PHONY: tag-release
tag-release:  ## Tag the git project for the next release.
	@git tag -a v${VERSION} -m '${VERSION}'

.PHONY: git-push-tags
git-push-tags:
	@git push --tags

publish-doc-page:
	@gh-pages \
		--repo https://github.com/filethis/${NAME}.git \
		--branch gh-pages \
		--dist ./doc-page/ \
		--remove ./doc-page/README.md;

.PHONY: publish
publish: test-chrome build-doc-page tag-release git-push-tags publish-doc-page open-url-doc-page-published  ## Publish project. Bump value of "VERSION" variable at top of project Makefile.
	@echo Published version ${VERSION} of ${NAME};

