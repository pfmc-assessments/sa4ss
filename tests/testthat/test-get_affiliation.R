test_that("Unknown author returns NA", {
	expect_true(is.na(get_affiliation("Kelli Johnson")))
})
