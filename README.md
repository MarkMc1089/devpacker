
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

## 'I Want it All!' Project setup

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

## Custom Project Setup

```
create_package(
  path,                    # A path - if it does not exist, it is created, provided that the parent path exists
  use_git = TRUE,          # initialise and commit everything to a local git repository
  use_github = use_git,    # create and push to a new repository on Github, along with a starting README
  use_ci = use_github,     # set up a CI action with GitHub Actions to run R CMD CHECK on each push
  use_precommit = use_ci,  # set up precommit to automatically perform styling and checks before each commit
  use_coverage = use_ci,   # set up code coverage, and if using GitHub, adds a CI action using Codecov service
  use_lintr = TRUE,        # set up lintr
  use_tests = TRUE,        # set up testthat
  fields = list(),         # usethis option for setting DESCRIPTION fields - for better option see below
  roxygen = TRUE,          # usethis option to use roxygen (for automating a lot of documentation tasks) or not
  check_name = TRUE,       # usethis option to check valid name for CRAN
  open = FALSE             # set to TRUE if you want to immediately open your new project
)
```

## Setting Default DESCRIPTION Fields

From the documentation for `usethis::use_description`:

If you create a lot of packages, consider storing personalized defaults as a named list in an option named `usethis.description`. Here's an example of code to include in `.Rprofile`, which can be opened via `usethis::edit_r_profile()`:

```
options(
  usethis.description = list(
    `Authors@R` = 'person("Jane", "Doe", email = "jane@example.com",
                          role = c("aut", "cre"),
                          comment = c(ORCID = "YOUR-ORCID-ID"))',
    License = "MIT + file LICENSE",
    Language =  "es"
  )
)
```

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

- [ ] Add tests.
- [x] Add configuration - currently there is none.
- [ ] Automate the updating of roxygen dependencies for `precommit`.
- [ ] Extend the package by adding a similar function for `shiny`, making use of best practices like modules and tools like `golem`.


