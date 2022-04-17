test_that("create_package", {
  tmp_pkg <- file.path(tempdir(), "tmppkg")
  print(paste("testing create_package:", tmp_pkg))

  expect_equal(
    basename(create_package(tmp_pkg, use_github = FALSE)), "tmppkg"
  )

  unlink(tmp_pkg, recursive = TRUE)
})
