test_that("create_package", {
  tmp_pkg <- file.path(tempdir(), "tmppkg")

  expect_equal(
    basename(create_package(tmp_pkg, FALSE, FALSE, FALSE, FALSE)), "tmppkg"
  )

  unlink(tmp_pkg, recursive = TRUE)
})
