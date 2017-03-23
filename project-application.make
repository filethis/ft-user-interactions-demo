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

build-docs: ./docs/index.html  ## Build application project documentation page

.PHONY: clean-docs
clean-docs:  ## Clean application documentation page
	@rm -f ./docs/index.html;

./docs/index.html: ${PROJECT_PAGE_SOURCE}
	@pandoc ${PROJECT_PAGE_SOURCE} \
		-f markdown \
		-t html \
		-s \
		--css=./docs.css \
		-o ./docs/index.html; \
	echo ./docs/index.html;


# Running -----------------------------------------------------------------------------------

.PHONY: run-browser-sync
run-browser-sync:  ## Run BrowserSync against local files
	@browser-sync start \
		--server \
		--port ${LOCAL_PORT} \
		--files "*.html, *.css, src/*.html, src/*.css, demo/*.json, test/*.html";


# Docs -----------------------------------------------------------------------------------

.PHONY: open-url-docs-local
open-url-docs-local:  ## Open URL of local application documentation
	@open file://`pwd`/docs/index.html;

.PHONY: print-url-docs-local
print-url-docs-local:  ## Print URL of local application documentation
	@echo file://`pwd`/docs/index.html;

.PHONY: open-url-docs-github-pages
open-url-docs-github-pages:  ## Open URL of application documentation published on GitHub Pages
	@open https://filethis.github.io/${NAME};

.PHONY: print-url-docs-github-pages
print-url-docs-github-pages:  ## Print URL of application documentation published on GitHub Pages
	@echo https://filethis.github.io/${NAME};


# Application -----------------------------------------------------------------------------------

.PHONY: open-url-app-local
open-url-app-local:  ## Open URL of local application
	@open http://localhost:${LOCAL_PORT};

.PHONY: print-url-app-local
print-url-app-local:  ## Print URL of local application
	@echo http://localhost:${LOCAL_PORT};

.PHONY: open-url-app-github-pages
open-url-app-github-pages:  ## Open URL of application published on GitHub Pages
	@open https://filethis.github.io/${NAME};

.PHONY: print-url-app-github-pages
print-url-app-github-pages:  ## Print URL of application published on GitHub Pages
	@echo https://filethis.github.io/${NAME};


# Publish -----------------------------------------------------------------------------------

.PHONY: publish-docs-github-pages
publish-docs-github-pages: build-docs  ## Publish application docs on GitHub Pages. Overrides publish-app-github-pages.
	@gh-pages \
		--repo https://github.com/filethis/${NAME}.git \
		--branch gh-pages \
		--dist ./docs/ \
		--remove ./docs/README.md; \
	echo Published documentation for version ${VERSION} of application \"${NAME}\" to GitHub Pages at https://filethis.github.io/${NAME}; \
	open https://filethis.github.io/${NAME};

.PHONY: publish-app-github-pages
publish-app-github-pages: build-docs  ## Publish application itself on GitHub Pages. Overrides publish-docs-github-pages.
	@gh-pages \
		--repo https://github.com/filethis/${NAME}.git \
		--branch gh-pages \
		--dist ./build/bundled; \
	echo Published version ${VERSION} of application \"${NAME}\" to GitHub Pages at https://filethis.github.io/${NAME}; \
	open https://filethis.github.io/${NAME};

