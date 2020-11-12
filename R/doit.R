doit <- function (dirgit = "c:/stockAssessment/ss/sa4ss") {
  setwd(dirgit)
  build()
  if ("package:sa4ss" %in% search()) unload(package = "sa4ss")
  install.packages(file.path(dirname(dirgit), "sa4ss_0.0.0.9001.tar.gz"),
    type = "source")
  library(sa4ss)
  unlink("doc", recursive = TRUE)
  sa4ss::draft(
    authors = c("Kelli F. Johnson", "Chantel R. Wetzel", "Joeseph Bizzarro"),
    create_dir = TRUE)
  setwd("doc")
  bookdown::render_book("00a.Rmd", clean = FALSE)
}
