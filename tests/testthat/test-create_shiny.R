test_that("create_shiny", {
  tmp_pkg <- file.path(tempdir(), "tmpshiny")
  print(paste("testing create_shiny:", tmp_pkg))

  expect_equal(
    basename(create_shiny(tmp_pkg, FALSE, FALSE, FALSE, FALSE)), "tmpshiny"
  )

  unlink(tmp_pkg, recursive = TRUE)
})
