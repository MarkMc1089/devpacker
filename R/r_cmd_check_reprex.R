reprex <- function(path) {
  usethis::create_package(path, open = FALSE)
  usethis::local_project(path)

  gert::git_init()
  precommit::use_precommit(open = FALSE, ci = NA)

  invisible(path)
}
