#
# Copyright 2018 FileThis, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

SHELL := /bin/bash


# Targets common to both application and element projects
include project-common.make


#------------------------------------------------------------------------------
# Source
#------------------------------------------------------------------------------

# Lint

.PHONY: source-lint-polymerlint
source-lint-polymerlint:  ## Run Polymer linter over project source files
	@echo polymer lint; \
	polymer lint --input index.html || true;

.PHONY: source-lint-eslint
source-lint-eslint:  ## Run ESLint tool over project source files
	@echo eslint; \
    eslint --ext .html,.js ./ || true;

.PHONY: source-lint
source-lint: source-lint-polymerlint source-lint-eslint ## Shortcut for source-lint-polymerlint and source-lint-eslint
	@echo source-lint;

# Serve

.PHONY: source-serve-python
source-serve-python:  ## Serve application using Python 2.7
	@echo http:localhost:${LOCAL_PORT}; \
	python -m SimpleHTTPServer ${LOCAL_PORT};

.PHONY: source-serve-ruby
source-serve-ruby:  ## Serve application using Ruby
	@echo http:localhost:${LOCAL_PORT}; \
	ruby -run -ehttpd . -p${LOCAL_PORT};

.PHONY: source-serve-node
source-serve-node:  ## Serve application using Node "static-server" tool
	@echo http:localhost:${LOCAL_PORT}; \
	static-server --port ${LOCAL_PORT};

.PHONY: source-serve-php
	@echo http:localhost:${LOCAL_PORT}; \
	php -S 127.0.0.1:${LOCAL_PORT};

.PHONY: source-serve-browsersync
source-serve-browsersync:  ## Serve application using BrowserSync
	@browser-sync start \
		--config "bs-config.js" \
		--server

# Browse

.PHONY: source-browse
source-browse:  ## Open locally-served app in browser
	@open http:localhost:${LOCAL_PORT};

.PHONY: source-browse-browsersync
source-browse-browsersync:  ## Run BrowserSync, proxied against an already-running local server
	@if lsof -i tcp:${LOCAL_PORT} > /dev/null; then \
		echo Found running Polymer server; \
	else \
		echo No Polymer server running for element demo. Use \"make serve\"; \
		exit 1; \
	fi; \
	browser-sync start \
		--config "bs-config.js" \
		--proxy "http://localhost:${LOCAL_PORT}/${QUERY_STRING}" \
		--port ${LOCAL_PORT} \
		--startPath "/";

.PHONY: project-test-browsersync
project-test-browsersync:  ## Run BrowserSync for tests
	@if lsof -i tcp:${LOCAL_PORT} > /dev/null; then \
		echo Found running Polymer server; \
	else \
		echo No Polymer server running for element demo. Use \"make serve\"; \
		exit 1; \
	fi; \
	browser-sync start \
		--config "bs-config.js" \
		--proxy "http://localhost:${LOCAL_PORT}" \
		--port ${LOCAL_PORT} \
		--startPath "/components/${NAME}/test/" \
		--index "${NAME}_test.html";


#------------------------------------------------------------------------------
# Distribution
#------------------------------------------------------------------------------

# Serve

.PHONY: dist-serve-dev
dist-serve-dev:  ## Serve dev application in local build directory using "polymer serve". Useful to check before releasing.
	@echo http:localhost:${LOCAL_PORT}; \
	polymer serve build/dev --port ${LOCAL_PORT} --open;

.PHONY: dist-serve-prod
dist-serve-prod:  ## Serve production application in local build directory using "polymer serve". Useful to check before releasing.
	@echo http:localhost:${LOCAL_PORT}; \
	polymer serve build/prod --port ${LOCAL_PORT} --open;

.PHONY: dist-serve-debug
dist-serve-debug:  ## Serve debug application in local build directory using "polymer serve". Useful to check before releasing.
	@echo http:localhost:${LOCAL_PORT}; \
	polymer serve build/debug --hostname localhost --port ${LOCAL_PORT} --open;

.PHONY: dist-serve-custom
dist-serve-custom:  ## Serve application in local build directory using Python 2.7. Useful to check before releasing.
	@echo http:localhost:${LOCAL_PORT}; \
	cd ./dist && python -m SimpleHTTPServer ${LOCAL_PORT};

.PHONY: dist-serve
dist-serve: dist-serve-dev  ## Shortcut for dist-serve-dev
	@echo dist-serve;

# Build

# polymer-bundler: https://github.com/Polymer/tools/tree/master/packages/bundler
# crisper: https://github.com/PolymerLabs/crisper
# babel: https://babeljs.io/
# uglifyjs: https://github.com/mishoo/UglifyJS2
# WebPack: https://webpack.js.org/
# NOTE: If use this again, it will need to be fit into the new dist and build folder structure
.PHONY: dist-build-custom
dist-build-custom:  ## Build distribution
	@mkdir ./build/; \
	mkdir ./dist/; \
	echo Dependencies...; \
	echo Vulcanizing...; \
	polymer-bundler \
	    --in-file ./src/${NAME}.html \
	    --rewrite-urls-in-templates \
	    --inline-scripts \
	    --inline-css \
	    --out-file ./build/${NAME}.vulcanized.html; \
    pushd ./build > /dev/null; \
	echo Splitting...; \
	crisper \
	    --source ${NAME}.vulcanized.html \
	    --html ${NAME}.split.html \
	    --js ${NAME}.js; \
	echo Transpiling...; \
	babel \
	    ${NAME}.js \
	    --out-file ${NAME}.es5.js; \
	echo Minifying...; \
	cp \
	    ${NAME}.es5.js \
	    ${NAME}.minified.js; \
    popd > /dev/null; \
	echo Distribution...; \
	[ ! -z "src/" ] && mkdir ./dist/src/; \
    cp ./build/${NAME}.split.html ./dist/src/${NAME}.html; \
    cp ./build/${NAME}.minified.js ./dist/src/${NAME}.js; \
    cp index.html ./dist/index.html;

#	echo Minifying...; \
#	uglifyjs \
#	    ${NAME}.es5.js \
#	    --compress \
#	    --output ${NAME}.minified.js; \

#	echo Minifying...; \
#	cp \
#	    ${NAME}.es5.js \
#	    ${NAME}.minified.js; \


#------------------------------------------------------------------------------
# Publications
#------------------------------------------------------------------------------

# Browse

.PHONY: publication-browse-dev
publication-browse-dev:  ## Open the published dev application
	@open https://${PUBLICATION_DOMAIN}/${NAME}/${VERSION}/dev/index.html;

.PHONY: publication-browse-prod
publication-browse-prod:  ## Open the published prod application
	@open https://${PUBLICATION_DOMAIN}/${NAME}/${VERSION}/index.html;

.PHONY: publication-browse-debug
publication-browse-debug:  ## Open the published debug application
	@open https://${PUBLICATION_DOMAIN}/${NAME}/${VERSION}/debug/index.html;

# URL

.PHONY: publication-url-dev
publication-url-dev:  ## Print URL of the published dev application
	@echo https://${PUBLICATION_DOMAIN}/${NAME}/${VERSION}/dev/index.html;

.PHONY: publication-url-prod
publication-url-prod:  ## Print URL of the published prod application
	@echo https://${PUBLICATION_DOMAIN}/${NAME}/${VERSION}/index.html;

.PHONY: publication-url-debug
publication-url-debug:  ## Print URL of the published debug application
	@echo https://${PUBLICATION_DOMAIN}/${NAME}/${VERSION}/debug/index.html;


#------------------------------------------------------------------------------
# Other
#------------------------------------------------------------------------------

.PHONY: update-polymerjson
update-polymerjson:  ## Internal. Used when polymer.json templates have changed.
	@pushd ../../ > /dev/null; \
	NAME=${NAME} ./bin/moustache ./project-templates/application/polymer.json ./applications/${NAME}/polymer.json; \
	popd > /dev/null; \
	echo Updated polymer.json;


#------------------------------------------------------------------------------
# Shortcuts
#------------------------------------------------------------------------------


#------------------------------------------------------------------------------
# Bower
#------------------------------------------------------------------------------

.PHONY: bower-register
bower-register:  # Internal target: Register element in public Bower registry. Usually invoked as part of a release via 'release' target.
	@echo TODO: Should Polymer applications be registered in Bower?;



