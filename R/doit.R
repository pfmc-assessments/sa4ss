#' Internal Code to Build, Load, and Render the sa Template
#'
#' A non-exported function used by Kelli F. Johnson to
#' build and load \pkg{sa4ss} and copy and render the template
#' for a stock assessment document.
#'
#' @param dirgit A file path to where the sa4ss repository is cloned.
#' @template authors
#' @author Kelli F. Johnson
#'
doit <- function(dirgit = "c:/stockAssessment/ss/sa4ss",
	authors = c(
		"Kelli F. Johnson",
		"Chantel R. Wetzel",
		"Joseph J. Bizzarro"
	)) {
	oldwd <- getwd()
	on.exit(setwd(oldwd), add = TRUE)
	setwd(dirgit)
	devtools::build()
	if ("package:sa4ss" %in% search()) pkgload::unload(package = "sa4ss")
	utils::install.packages(
		utils::tail(
			n = 1,
			dir(dirname(dirgit),
				pattern = "sa4ss_[0-9\\.]+\\.tar.gz",
				full.names = TRUE
			)
		),
		type = "source"
	)
	library(sa4ss)
	unlink("doc", recursive = TRUE)
	sa4ss::draft(
		authors = authors,
		create_dir = TRUE
	)
	setwd("doc")
	bookdown::render_book("00a.Rmd", clean = FALSE)
}
