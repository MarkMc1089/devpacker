check_dependent_args <- function(arg, dependent_args) {
  if (!arg[[1]] && any(unlist(dependent_args))) {
    any_of <- if (length(dependent_args) > 1) "any of" else "" # Exclude Linting
    msg_template <- paste(
      "{usethis::ui_code(names(arg))} must be {usethis::ui_code('TRUE')} for {any_of}",
      "{paste(lapply(names(dependent_args), usethis::ui_code), collapse = ',')} to be",
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
