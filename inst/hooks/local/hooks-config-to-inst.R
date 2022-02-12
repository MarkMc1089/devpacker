#!/usr/bin/env Rscript

# We must put this
# file under inst/ because otherwise it cannot be accessed (leaving it on top
# level will fail r cmd check, the same when used as hidden file in inst/)
fs::file_copy(
  ".pre-commit-hooks.yaml", "inst/pre-commit-hooks.yaml",
  overwrite = TRUE
)
