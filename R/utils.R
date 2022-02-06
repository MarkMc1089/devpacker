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
