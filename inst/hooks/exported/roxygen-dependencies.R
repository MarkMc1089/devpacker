#!/usr/bin/env Rscript

root <- here::here()

imports <- trimws(usethis:::package_data()$Imports)
imports <- unlist(strsplit(imports, ",\n    "))
imports <- paste0(
  "        -    ", paste0(imports, collapse = "\n        -    "), "\n"
)
roxy_block <- paste0(
  "    -   id: roxygenize\n",
  "        additional_dependencies:\n",
  imports
)

pc_yaml <- paste0(readLines(paste0(root, "/.pre-commit-config.yaml")), collapse = "\n")
new_pc_yaml <- gsub(
  "\\s{4}-\\s*id:\\sroxygenize\\n((\\s{8}.*\\n)*(\\s*-\\s*.*\\n)*)",
  roxy_block, pc_yaml,
  perl = TRUE
)

writeLines(new_pc_yaml, con = paste0(root, "/.pre-commit-config.yaml"))
