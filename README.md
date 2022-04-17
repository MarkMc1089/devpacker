
# devpacker

_Initialise A Blank R Package Or {shiny} App With Good Practice Configuration_

`devpacker` aims to provide a solid foundation for building an R package or `{shiny}` app, ready to go with test directories, continuous integration and various other development best practices configured.

<!-- badges: start -->
[![Lifecycle: experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![pre-commit](https://img.shields.io/badge/pre--commit-enabled-brightgreen?logo=pre-commit&logoColor=white)](https://github.com/pre-commit/pre-commit)
[![R-CMD-check](https://github.com/MarkMc1089/devpacker/workflows/R-CMD-check/badge.svg)](https://github.com/MarkMc1089/devpacker/actions)
[![Codecov test coverage](https://codecov.io/gh/MarkMc1089/devpacker/branch/master/graph/badge.svg)](https://codecov.io/gh/MarkMc1089/devpacker?branch=master)
<!-- badges: end -->

## Installation

You can install `devpacker` from this repository with:

``` r
devtools::install.git_hub("MarkMc1089/devpacker")
```

## Usage

Simply run one of the below, ensuring you name the last folder on the path what you want the package to be called:

``` r
devpacker::create_package("path/to/new/package")
devpacker::create_shiny("path/to/new/app")
```


### 'I Want it All!' Project Setup

Given a `path`, `create_package` will create an R package and `create_shiny` will create a `{shiny}` app as a package. The actions taken are:

1. Call `usethis::create_package` or `golem::create_golem` with `path`, using default arguments.
2. Use `{gert}` to initialise a git repo.
3. Add the MIT license.
4. Create a sample R file `functions.R`, which includes a `{roxygen2}` documentation block.
5. Add `{testthat}` folders and files.
6. Add a `{lintr}` configuration.
7. Set up `{precommit}`, to run automated checks before commits can succeed.
8. Create a remote repo on GitHub and pushes the package.
9. Add a README.
10. Set up code coverage with `{covr}`, to use the codecov service.
11. Add GitHub Actions for running R CMD CHECK and code coverage report on commits. Badges for these are added to the README.
12. A final push to GitHub is made.

### Custom Project Setup

```
create_package(            # Or create_shiny
  path,                    # A path, whose final folder will be the package name
  use_git = TRUE,          # initialise and commit everything to a local git repository
  use_github = use_git,    # create and push to a new repository on Github, along with a starting README
  use_ci = use_github,     # set up a CI action with GitHub Actions to run R CMD CHECK on each push
  use_precommit = use_ci,  # set up precommit to automatically perform checks before each commit
  use_coverage = use_ci,   # set up code coverage; if using GitHub, adds a CI action using Codecov service
  use_lintr = TRUE,        # set up lintr
  use_tests = TRUE,        # set up testthat
  fields = list(),         # {usethis} option for setting DESCRIPTION fields - for better option see below
  roxygen = TRUE,          # {usethis} option to use roxygen (for automating a lot of documentation tasks)
  check_name = TRUE,       # {usethis} option to check valid name for CRAN
  open = FALSE             # set to TRUE if you want to immediately open your new project
  project_hook = {hook}    # For create_shiny only; allows to pass a custom project_hook "hook" to {golem}
)
```

#### Using a custom `project_hook` with `create_shiny`

See `vignette("f_extending_golem", package = "golem")` for details of customising what `{golem}` creates.

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

## Development Lifecycle

1. Choose a name for the package. Can use `available::available("potentialpackagename")` to find existing packages and any potential unwanted associations. MUST use A-z0-9. Best practice is to use all [lowercase letters](https://r-pkgs.org/workflows101.html#naming).
2. Run `devpacker::createpackage("path/to/awesomepackagename")`.
3. Write your code in the `R` folder - `usethis::use_r(code)` -> creates and opens `code.R` for editing.
4. Add tests - with `code.R` focused in RStudio, run `usethis::use_test()` -> creates and opens `test-code.R` for editing.
5. When using a package for the first time - `usethis::use_package("packagename")` to add it to imports in `DESCRIPTION`.
6. Use functions from packages by pre-pending them with `packagename::`, or, especially if you use a lot of functions from a package, add `@import packagename` into the roxygen documentation block of a function to avoid need for the `::` syntax.
7. Regularly commit to git, at least locally. This is just good practice anyway, but with `precommit` running automated tests and styling your code consistently regular committing helps to prevent the complexity of having to resolve many bugs all in one go!

## TODO

- [x] Add some tests.
- [x] Add configuration options.
- [x] Automate the updating of roxygen dependencies for `{precommit}`. DONE IN FORK OF [lorenzwalthert/precommit](https://github.com/lorenzwalthert/precommit)
- [ ] Use the templating functions of `{usethis}` to handle various config files used.
- [X] Extend the package by adding a similar function for `{shiny}`, making use of best practices like modules and tools like `{golem}`.
- [ ] Increase test coverage.
