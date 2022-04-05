test_that("check_dependent_args", {
  number_of_args <- 4
  args <- expand.grid(rep(list(list(TRUE, FALSE)), number_of_args))

  for (i in seq_len(nrow(args))) {
    expect_equal(
      check_dependent_args(args[[i, 1]], args[i, 2:number_of_args]),
      if (args[[i, 1]]) {
        TRUE
      } else {
        !any(unlist(args[i, 2:4]))
      }
    )
  }
})


test_that("check_create_package_args", {
  args <- list(
    # use_git dependency of use_github and use_ci
    list(use_git = TRUE, use_github = TRUE, use_ci = TRUE, use_precommit = FALSE),
    list(use_git = FALSE, use_github = TRUE, use_ci = TRUE, use_precommit = FALSE),
    # use_github dependency of use_ci
    list(use_git = TRUE, use_github = TRUE, use_ci = TRUE, use_precommit = FALSE),
    list(use_git = TRUE, use_github = FALSE, use_ci = TRUE, use_precommit = FALSE),
    # use_git dependency of use_precommit
    list(use_git = TRUE, use_github = FALSE, use_ci = FALSE, use_precommit = TRUE),
    list(use_git = FALSE, use_github = FALSE, use_ci = FALSE, use_precommit = TRUE)
  )

  lapply(
    seq_along(args),
    function(i) expect_equal(check_create_package_args(args[[i]]), as.logical(i %% 2))
  )
})
