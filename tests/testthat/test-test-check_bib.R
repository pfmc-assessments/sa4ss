test_that("check_bib returns Success", {
  test <- check_bib(bibtex:::findBibFile("bibtex"))
  expect_equal(test, "Success")
})
