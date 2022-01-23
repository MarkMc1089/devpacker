#' Create a package
#' @description Creates a new package at given path; the package is named as the
#'   last folder in the path. Currently there are no configuration options beyond
#'   what is exposed by `usethis::createpackage()`.
#'
#' @param path A path. If it exists, it is used. If it does not exist, it is
#'   created, provided that the parent path exists.
#' @param ... Additional arguments passed to `usethis::create_package()`
#' @inheritParams usethis::create_package
#' @return The path to the created package, invisibly.
#'
#' @export
create_package <- function(path, ..., open = FALSE) {
  usethis::create_package(path, ..., open = open)
  usethis::local_project(path)

  gert::git_init(usethis::proj_get())
  usethis::use_git_ignore(".Rhistory")
  gert::git_add(".")
  gert::git_commit("Initial commit")

  author <- eval(str2lang(trimws(usethis:::package_data()$`Authors@R`)))
  usethis::use_mit_license(paste(author$given, author$family))

  file.copy(system.file("basefiles", "functions.R", package = "devpacker"), ".")
  usethis::use_test("functions", open = FALSE)

  file.copy(system.file("config", "lintr", package = "devpacker"), ".")
  file.rename("lintr", ".lintr")
  usethis::use_build_ignore(".lintr")

  precommit::use_precommit(
    config_source = system.file(
      "config", "pre-commit-config.yaml",
      package = "devpacker"
    ),
    open = FALSE, ci = NA
  )
  gert::git_add(".")
  gert::git_commit("Add precommit / lintr / testthat / license")

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
    usethis::ui_done("Creating GitHub repository {ui_value(repo_spec)}")
    create <- gh::gh("POST /user/repos", name = repo_name, description = repo_desc)
    origin_url <- switch(protocol,
      https = create$clone_url,
      ssh = create$ssh_url
    )
    withr::defer(usethis:::view_url(create$html_url))
    usethis::ui_done("Setting remote {ui_value('origin')} to {ui_value(origin_url)}")
    usethis::use_git_remote("origin", origin_url)
    default_branch <- usethis::git_branch_default() # Exclude Linting
    remref <- glue::glue("origin/{default_branch}") # Exclude Linting
    usethis::ui_done(
      "\n    Pushing {usethis::ui_value(default_branch)} branch to GitHub and setting
       \n    {usethis::ui_value(remref)} as upstream branch"
    )
    gert::git_push(remote = "origin", verbose = TRUE)
  }

  use_gh()

  usethis::use_readme_md(open = FALSE)

  usethis::use_coverage()
  usethis::use_github_actions()
  usethis::use_github_action("test-coverage")

  gert::git_add(".")
  gert::git_commit("Add code coverage / CI config / README")
  gert::git_push()

  invisible(path)
}
