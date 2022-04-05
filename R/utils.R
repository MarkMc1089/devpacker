check_dependent_args <- function(arg, dependent_args) {
  if (!arg[[1]] && any(unlist(dependent_args))) {
    any_of <- if (length(dependent_args) > 1) "any of " else "" # Exclude Linting
    msg_template <- paste0(
      "{usethis::ui_code(names(arg))} must be {usethis::ui_code('TRUE')} for {any_of}",
      "{paste(lapply(names(dependent_args), usethis::ui_code), collapse = ',')} to be ",
      "set to {usethis::ui_code('TRUE')}"
    )
    usethis::ui_oops(msg_template)

    FALSE
  } else {
    TRUE
  }
}


check_create_package_args <- function(args) {
  # use_git dependency of use_github and use_ci
  if (!check_dependent_args(args[1], args[2:3])) {
    return(FALSE)
  }
  # use_github dependency of use_ci
  if (!check_dependent_args(args[2], args[3])) {
    return(FALSE)
  }
  # use_git dependency of use_precommit
  if (!check_dependent_args(args[1], args[4])) {
    return(FALSE)
  }
  TRUE
}


init_lintr <- function() {
  file.copy(system.file("config", "lintr", package = "devpacker"), ".")
  file.rename("lintr", ".lintr")
  usethis::use_build_ignore(".lintr")
}


init_git <- function() {
  gert::git_init()
  usethis::use_git_ignore(".Rhistory")
  gert::git_add(".")
  gert::git_commit("Initial commit")
}


init_precommit <- function() {
  precommit::use_precommit(
    config_source = system.file(
      "config", "pre-commit-config.yaml",
      package = "devpacker"
    ),
    open = FALSE, ci = NA
  )
}


check_protocol <- function(protocol) {
  if (!rlang::is_string(protocol) || !(tolower(protocol) %in% c("https", "ssh"))) {
    options(usethis.protocol = NULL)
    usethis::ui_stop(
      "{ui_code('protocol')} must be either {ui_value('https')} or {ui_value('ssh')}"
    )
  }
  invisible(NULL)
}


check_no_github_repo <- function(owner, repo) {
  repo_found <- tryCatch(
    {
      gh::gh("/repos/{owner}/{repo}", owner = owner, repo = repo)
      TRUE
    },
    http_error_404 = function(err) FALSE
  )
  if (!repo_found) {
    return(invisible(NULL))
  }
  owner_repo <- paste0("owner", "/", "repo") # Exclude Linting
  usethis::ui_stop("Repo {ui_value(owner_repo)} already exists on GitHub!")
}


package_data <- function(path) {
  desc <- desc::description$new(path)
  as.list(desc$get(desc$fields()))
}


view_url <- function(url) {
  usethis::ui_done("Opening URL {ui_value(url)}")
  utils::browseURL(url)
  invisible(url)
}


init_gh <- function(repo_name) {
  protocol <- usethis::git_protocol()
  check_protocol(protocol)

  whoami <- suppressMessages(gh::gh_whoami())
  if (is.null(whoami)) {
    usethis::ui_stop(
      "\n      Unable to discover a GitHub personal access token
       \n      A token is required in order to create and push to a new repo
       \n      Call {usethis::ui_code('gh_token_help()')} for help configuring a token"
    )
  }
  owner <- whoami$login

  check_no_github_repo(owner, repo_name)
  repo_spec <- paste0(owner, "/", repo_name) # Exclude Linting
  usethis::ui_done("Creating GitHub repository {usethis::ui_value(repo_spec)}")
  create <- gh::gh("POST /user/repos", name = repo_name)
  origin_url <- switch(protocol,
    https = create$clone_url,
    ssh = create$ssh_url
  )
  withr::defer(view_url(create$html_url))
  usethis::ui_done(
    "Setting remote {usethis::ui_value('origin')} to {usethis::ui_value(origin_url)}"
  )
  usethis::use_git_remote("origin", origin_url)
  default_branch <- usethis::git_branch_default()
  remref <- paste0("origin/", default_branch) # Exclude Linting
  usethis::ui_done(
    "\n    Pushing {usethis::ui_value(default_branch)} branch to GitHub and setting
     \n    {usethis::ui_value(remref)} as upstream branch"
  )
  gert::git_push(remote = "origin", verbose = TRUE)
}


init_sample_files <- function(use_tests) {
  file.copy(system.file("basefiles", "functions.R", package = "devpacker"), "R")
  if (use_tests) usethis::use_test("functions", open = FALSE)
}
