test_that("create_shiny", {
  tmp_pkg <- file.path(tempdir(), "tmppkg")

  expect_equal(
    basename(create_shiny(tmp_pkg, FALSE, FALSE, FALSE, FALSE)), "tmppkg"
  )

  unlink(tmp_pkg, recursive = TRUE)
})
