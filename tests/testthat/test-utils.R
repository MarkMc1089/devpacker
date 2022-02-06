test_that("check_dependent_args_works", {
  tmp_pkg <- paste0(tempdir(), "/tmppkg")
  expect_equal(
    create_package(tmp_pkg,
      use_git = FALSE, use_github = TRUE,
      use_ci = FALSE, use_precommit = FALSE
    ),
    FALSE
  )
  expect_equal(
    create_package(tmp_pkg, FALSE, FALSE, FALSE, TRUE), FALSE
  )
  expect_equal(
    create_package(tmp_pkg, TRUE, FALSE, TRUE, FALSE), FALSE
  )
  testthat::skip_on_ci()
  expect_equal(
    basename(create_package(tmp_pkg, TRUE, FALSE, FALSE, TRUE)), "tmppkg"
  )
  unlink(tmp_pkg, recursive = TRUE)
  usethis::proj_get()
})
