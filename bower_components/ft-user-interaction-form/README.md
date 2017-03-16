# \<ft-user-interaction-form\>

FileThis UserInteraction form

## Install the Polymer-CLI

First, make sure you have the [Polymer CLI](https://www.npmjs.com/package/polymer-cli) installed. Then run `polymer serve` to serve your application locally.

## Viewing Your Application

```
$ polymer serve
```

## Building Your Application

```
$ polymer build
```

This will create a `build/` folder with `bundled/` and `unbundled/` sub-folders
containing a bundled (Vulcanized) and unbundled builds, both run through HTML,
CSS, and JS optimizers.

You can serve the built versions by giving `polymer serve` a folder to serve
from:

```
$ polymer serve build/bundled
```

## Running Tests

```
$ polymer test
```

Your application is already set up to be tested via [web-component-tester](https://github.com/Polymer/web-component-tester). Run `polymer test` to run your application's test suite locally.


# TODO: Move this somewhere general

## Releasing a new version:

Bump version number in bower.json, Makefile

    make tag-version
    make push-tags

The last step seems to automatically create a release, perhaps because the tag pattern 
has a sem-ver form.

## When have created a new element, publish GitHub gh-pages

Release the first version, like "0.0.1", using instructions above.

    make docs-gh
