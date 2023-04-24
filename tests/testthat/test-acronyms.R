test_that("Acronyms compile with hyperlink", {
  file_glossaries <- system.file(
    "rmarkdown", "templates", "sa", "skeleton", "sa4ss_glossaries.tex",
    package = "sa4ss"
  )
  dir_build <- file.path(tempdir(), "sa4ss")
  file_doc <- file.path(dir_build, "sa4ss_doc.tex")
  dir.create(dir_build, showWarnings = FALSE)
  file.copy(
    file_glossaries,
    file.path(dir_build, basename(file_glossaries)),
    overwrite = TRUE
  )
  writeLines(
    text = c(
      "\\documentclass{report}",
      "\\usepackage{glossaries}",
      "\\usepackage[colorlinks]{hyperref}",
      "\\makeglossaries",
      "\\loadglsentries{sa4ss_glossaries.tex}",
      "\\begin{document}",
      "Some test text \\glsentrytext{mlml}.",
      "\\printglossaries",
      "\\end{document}"
    ),
    con = file_doc
  )
  old_wd <- getwd()
  on.exit(setwd(old_wd))
  on.exit(unlink(dir_build, recursive = TRUE), add = TRUE)
  setwd(dir_build)
  end <- system(
    paste("lualatex", basename(file_doc))
  )
  expect_equal(end, 0)
})
