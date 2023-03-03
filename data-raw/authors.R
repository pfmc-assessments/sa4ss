## code to prepare `authors` dataset goes here

authors <- utils::read.csv(
  file = file.path("data-raw", "authors.csv"),
  header = TRUE
)

usethis::use_data(authors, overwrite = TRUE)
