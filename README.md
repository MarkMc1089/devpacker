
# devpacker

_Initialise A Blank R Package With Good Practice Configuration_

devpacker aims to provide a solid foundation for building an R package, ready to go with test directories, continuous integration and various other development best practices configured.

<!-- badges: start -->
[![Lifecycle: experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![R-CMD-check](https://github.com/MarkMc1089/devpacker/workflows/R-CMD-check/badge.svg)](https://github.com/MarkMc1089/devpacker/actions)
[![Codecov test coverage](https://codecov.io/gh/MarkMc1089/devpacker/branch/master/graph/badge.svg)](https://codecov.io/gh/MarkMc1089/devpacker?branch=master)
<!-- badges: end -->

# R Package Setup Notes

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

## Optional requirements
```
available
```

## Project setup
0. Choose name for package. Can use `available::available("potentialpackagename")` to find existing packages and any potential unwanted associations. MUST use A-z0-9. Best practice is to use all [lowercase letters](https://r-pkgs.org/workflows101.html#naming).
1. Open Rstudio > File > New Project... > New Directory > R package using devtools.
2. Enter name for project > Browse to desired parent folder > Create - this creates an empty package with git repository initialised and using `roxygen` (documentation and NAMESPACE management).
3. `usethis::use_mit_license("Joe Bloggs")` - add a license from the many available (MIT basically means use the code any way you want). See [here](https://choosealicense.com/) for details of existing licenses and for available options in `usethis` see [here](https://usethis.r-lib.org/reference/licenses.html).
4. `usethis::use_testthat()` - sets up test directories and config.
5. `reticulate::install_miniconda()` > `precommit::use_precommit()` - set up precommit hooks to run checks before committing to git. This ensures consistency for styling and syntax in addition to other checks. If anything fails, you HAVE to fix it to enable the commit to succeed! NOTE: Since `roxygen` is being used, you will get a message to run `precommit::snippet_generate('additional-deps-roxygenize')`. At this stage this is not needed, as we have no code written yet, but once you start adding code you will need to run it and add the snippet it generates to the `.pre-commit-config.yaml`.
6. `usethis::use_r("functions")` - simply creates an empty R file named "functions" in the R folder, and opens it for editing.
7. `usethis::use_test()` - creates a test R file with example code for the currently focused R file, and opens it in the editor.
8. (Console) `touch .lintr` - creates `lintr` [config file](https://cran.r-project.org/web/packages/lintr/readme/README.html#project-configuration).
A basic setup to paste into this (note a newline is needed at end) is:
```
linters: with_defaults(line_length_linter(90))
exclude: "# Exclude Linting"
exclude_start: "# Begin Exclude Linting"
exclude_end: "# End Exclude Linting"

```
9. `usethis::use_build_ignore(".lintr")` - prevent `lintr` config from being saved in built package.
10. `usethis::use_github()` > `usethis::use_readme_md()` - create a remote repository on GitHub, followed by a template README.
11. `usethis::use_github_actions()` - sets up GitHub Actions to run `R CMD CHECK` and adds badge to README.
12. `usethis::use_github_action("test-coverage")` - sets up GitHub Actions to run code coverage.
13. `usethis::use_coverage()` - sets up `covr`, to use [codecov](https://docs.codecov.com/docs), and adds badge to README.
14. (Console) `git add .` > `git commit -m "Initial commit"` - put everything on GitHub. You now have a ready to use blank project with all the bells and whistles. Enjoy!

## Installation (AVAILABLE SOON!)

You can install the released version of `devpacker` from this repository with:

``` r
devtools::install.git_hub("devpacker")
```

## Usage

Simply run the below, with the desired parent folder as working directory:

``` r
devpacker::go("packagename")
```

