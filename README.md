
# devpacker

_Initialise A Blank R Package With Good Practice Configuration_

`devpacker` aims to provide a solid foundation for building an R package, ready to go with test directories, continuous integration and various other development best practices configured.

<!-- badges: start -->
[![Lifecycle: experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![R-CMD-check](https://github.com/MarkMc1089/devpacker/workflows/R-CMD-check/badge.svg)](https://github.com/MarkMc1089/devpacker/actions)
[![Codecov test coverage](https://codecov.io/gh/MarkMc1089/devpacker/branch/master/graph/badge.svg)](https://codecov.io/gh/MarkMc1089/devpacker?branch=master)
<!-- badges: end -->

## Requirements
```
devtools
usethis
roxygen2
precommit
reticulate (for miniconda, used by precommit)
lintr
styler
covr
```

## Project setup

Given a `path`, `createpackage()` will create an R package. The actions taken are:

1. Call `usethis::create_package()` with `path`, using default arguments.
2. Uses `gert` to initialise a git repo.
3. Adds the MIT license.
4. Creates a sample R file `functions.R`, which includes a `roxygen` documentation block.
5. Adds `testthat` folders and files.
6. Adds a `lintr` configuration.
7. Sets up `precommit`, to run automated checks before commits can succeed.
8. Creates a remote repo on GitHub and pushes the package.
9. Adds a README.
10. Sets up code coverage with `covr`, to use the codecov service.
11. Adds GitHub Actions for running R CMD CHECK and code coverage report on commits. Badges for these are added to the README.
12. A final push to GitHub is made.

## Development lifecycle

1. Choose a name for the package. Can use `available::available("potentialpackagename")` to find existing packages and any potential unwanted associations. MUST use A-z0-9. Best practice is to use all [lowercase letters](https://r-pkgs.org/workflows101.html#naming).
2. Run `devpacker::createpackage("path/to/awesomepackagename")`.
3. Write your code in the `R` folder - `usethis::use_r(code)` -> creates and opens `code.R` for editing.
4. Add tests - with `code.R` focused in RStudio, run `usethis::use_test()` -> creates and opens `test-code.R` for editing.
5. When using a package for the first time - `usethis::use_package("packagename")` to add it to imports in `DESCRIPTION`.
6. Use functions from packages by pre-pending them with `packagename::`, or, especially if you use a lot of functions from a package, add `@import packagename` into the roxygen documentation block of a function to avoid need for the `::` syntax.
7. Regularly commit to git, at least locally. This is just good practice anyway, but with `precommit` running automated tests and styling your code consistently regular committing helps to prevent the complexity of having to resolve many bugs all in one go!
8. There is a step that is needed to keep the `pre-commit_config.yaml` up to date. Any packages that your package imports need to be added to this. Use `precommit::snippet_generate('additional-deps-roxygenize')` to generate the needed config before committing, if you have added any packages since last commit.

## Installation

You can install `devpacker` from this repository with:

``` r
devtools::install.git_hub("MarkMc1089/devpacker")
```

## Usage

Simply run the below, ensuring you name the last folder on the path what you want the package to be called:

``` r
devpacker::createpackage("path/to/new/package")
```

## TODO

1. Add tests.
2. Add configuration - currently there is none.
3. Automate the updating of roxygen dependencies for `precommit`.
4. Extend the package by adding a similar function for `shiny`, making use of best practices like modules and tools like `golem`.


