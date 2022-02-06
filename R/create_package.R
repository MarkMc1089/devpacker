#' Create a package
#' @description Creates a new package at given path; the package is named as the
#'   last folder in the path. Currently there are no configuration options beyond
#'   what is exposed by `usethis::createpackage()`.
#'
#' @param path A path. If it exists, it is used. If it does not exist, it is
#'   created, provided that the parent path exists.
#' @param ... Additional arguments passed to `usethis::create_package()`
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
#' @inheritParams usethis::create_package
#' @return The path to the created package, invisibly.
#'
#' @export
create_package <- function(path, use_git = TRUE, use_github = use_git,
                           use_ci = use_github, use_precommit = use_ci,
                           use_coverage = use_ci, use_lintr = TRUE,
                           use_tests = TRUE, ..., open = FALSE) {
  if (!check_create_package_args(as.list(match.call())[3:6])) {
    return(invisible(FALSE))
  }

  usethis::create_package(path, ..., open = open)
  usethis::local_project(path)

  usethis::use_mit_license()

  file.copy(system.file("basefiles", "functions.R", package = "devpacker"), ".")
  if (use_tests) usethis::use_test("functions", open = FALSE)

  if (use_lintr) {
    file.copy(system.file("config", "lintr", package = "devpacker"), ".")
    file.rename("lintr", ".lintr")
    usethis::use_build_ignore(".lintr")
  }

  if (use_git) {
    gert::git_init(usethis::proj_get())
    usethis::use_git_ignore(".Rhistory")
    gert::git_add(".")
    gert::git_commit("Initial commit")
  }

  if (use_precommit) {
    precommit::use_precommit(
      config_source = system.file(
        "config", "pre-commit-config.yaml",
        package = "devpacker"
      ),
      open = FALSE, ci = NA
    )
  }

  use_gh <- function() {
    protocol <- usethis::git_protocol()
    usethis:::check_protocol(protocol)
    whoami <- suppressMessages(gh::gh_whoami())
    if (is.null(whoami)) {
      usethis::ui_stop(
        "\n      Unable to discover a GitHub personal access token
         \n      A token is required in order to create and push to a new repo
         \n      Call {usethis::ui_code('gh_token_help()')} for help configuring a token"
      )
    }
    owner <- whoami$login
    repo_name <- usethis:::project_name()
    usethis:::check_no_github_repo(owner, repo_name, NULL)
    repo_desc <- usethis:::package_data()$Title
    repo_desc <- gsub("\n", " ", repo_desc)
    repo_spec <- glue::glue("{owner}/{repo_name}") # Exclude Linting
    usethis::ui_done("Creating GitHub repository {usethis::ui_value(repo_spec)}")
    create <- gh::gh("POST /user/repos", name = repo_name, description = repo_desc)
    origin_url <- switch(protocol,
      https = create$clone_url,
      ssh = create$ssh_url
    )
    withr::defer(usethis:::view_url(create$html_url))
    usethis::ui_done(
      "Setting remote {usethis::ui_value('origin')} to {usethis::ui_value(origin_url)}"
    )
    usethis::use_git_remote("origin", origin_url)
    default_branch <- usethis::git_branch_default() # Exclude Linting
    remref <- glue::glue("origin/{default_branch}") # Exclude Linting
    usethis::ui_done(
      "\n    Pushing {usethis::ui_value(default_branch)} branch to GitHub and setting
       \n    {usethis::ui_value(remref)} as upstream branch"
    )
    gert::git_push(remote = "origin", verbose = TRUE)
  }

  if (use_github) {
    use_gh()
    usethis::use_readme_md(open = FALSE)
  }

  if (use_coverage) usethis::use_coverage()

  if (use_ci) {
    usethis::use_github_actions()
    if (use_coverage) usethis::use_github_action("test-coverage")
  }

  if (use_git) {
    gert::git_add(".")
    gert::git_commit("Additional initial config")
  }

  if (use_github) gert::git_push()

  invisible(path)
}

check_create_package_args <- function(args) {
  # use_git dependency of use_github and use_ci
  if (!check_dependent_args(args[1], args[2:3])) {
    return(invisible(FALSE))
  }
  # use_github dependency of use_ci
  if (!check_dependent_args(args[2], args[3])) {
    return(invisible(FALSE))
  }
  # use_git dependency of use_precommit
  if (!check_dependent_args(args[1], args[4])) {
    return(invisible(FALSE))
  }
  TRUE
}
