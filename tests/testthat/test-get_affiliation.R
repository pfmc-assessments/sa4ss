test_that("Unknown author returns NA", {
  expect_warning(
    is.na(get_affiliation("Kelli Johnson"))
  )
  expect_true(
    suppressWarnings(is.na(get_affiliation("Kelli Johnson")))
  )
})
