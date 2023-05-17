test_that("session_test is successful", {
	test <- suppressWarnings(session_test())
	expect_false(
		inherits(test, "error")
	)
})
