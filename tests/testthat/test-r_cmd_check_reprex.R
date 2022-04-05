test_that("test_reprex", {
  path <- paste0(tempdir(), "/tmppkg")

  expect_equal(reprex(path), path)

  unlink(path, recursive = TRUE)
})
