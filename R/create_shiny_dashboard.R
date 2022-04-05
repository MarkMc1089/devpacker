#' Create a shiny dashboard
#' @description Creates a new shiny dashboard as a  package at given path; the
#'   package is named as the last folder in the path.
#'
#' @param path A path. If it exists, it is used. If it does not exist, it is
#'   created, provided that the parent path exists.
#' @param ... Additional arguments passed to `golem::create_golem()`
#' @param use_git Initialise and make initial commits to a local git
#'   repository. By default is `TRUE`.
#' @param use_github Create and push to a GitHub repository. By default takes
#'   value of `use_git`. If set to `TRUE`, `use_git` must also be `TRUE`.
#' @param use_ci Set up a GitHub Action job to run R CMD CHECK. By default takes
#'   value of `use_github`. If set to `TRUE`, `use_github` must also be `TRUE`.
#' @param use_precommit Set up `precommit` to run checks before any commit. By
#'   default takes value of `use_ci`. If set to `TRUE`, `use_git` must also
#'   be `TRUE`.
#' @param use_coverage Set up `covr` and, if using GitHub, a GitHub Action to run
#'   code coverage and use the Codecov service. By default takes value of `use_ci`.
#' @param use_lintr Set up lintr. By default is `TRUE`.
#' @param use_tests Set up testthat. By default is `TRUE`.
#' @inheritParams golem::create_golem
#' @return The path to the created package, invisibly.
#'
#' @export
create_shiny_dashboard <- function(path, use_git = TRUE, use_github = use_git,
                                   use_ci = use_github, use_precommit = use_ci,
                                   use_coverage = use_ci, use_lintr = TRUE,
                                   use_tests = TRUE, ..., open = FALSE,
                                   overwrite = FALSE) {
  stop("no")
  if (!check_create_package_args(as.list(environment())[2:5])) {
    return(invisible(FALSE))
  }

  if (dir.exists(path) && !overwrite) { # Exclude Linting
    stop(
      paste(
        "Project directory already exists. \n",
        "Set `overwrite = TRUE` to overwrite anyway.\n",
        "Be careful this will restore a brand new golem. \n",
        "You might be at risk of losing your work !"
      ),
      call. = FALSE
    )
  }

  golem_success <- golem::create_golem(path, ..., open = open)
  if (is.null(golem_success)) {
    usethis::ui_stop("Unable to create golem - aborting")
  }
  usethis::local_project(path)

  usethis::use_mit_license()

  init_sample_files(use_tests = use_tests)

  if (use_lintr) init_lintr()

  if (use_git) init_git()

  if (use_precommit) init_precommit()

  if (use_github) {
    init_gh(basename(path))
    usethis::use_readme_md(open = FALSE)
  }

  if (use_coverage) usethis::use_coverage()

  if (use_ci) {
    usethis::use_github_actions()
    if (use_coverage) usethis::use_github_action("test-coverage")
  }

  if (use_git && any(use_github, use_ci, use_coverage)) {
    gert::git_add(".")
    gert::git_commit("Additional initial config")
  }

  if (use_github) gert::git_push()

  invisible(path)
}
