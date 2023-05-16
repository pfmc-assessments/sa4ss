#' Compile the stock assessment document(s) for a given species
#'
#' @description
#' Compile the stock assessment document(s) for a given species where the number of
#' documents depends on the number of directories that you pass to dir.
#' Typically, this happens in the directory called `doc` that stores a single
#' directory for each stock.
#' [bookdown::render_book] will be called inside on each directory in `dir`.
#'
#' @details status:
#' This function is currently in beta testing, which means that it
#' * might be helpful,
#' * could contain bugs,
#' * will more than likely have non-descript error and warning messages.
#' Please post an [issue](https::/github.com/pfmc-assessments/sa4ss/issues)
#' or email the author of this function.
#' Thank you for helping test it out, and we hope the pain is worth the gain!
#'
#' @details index.Rmd
#' When specifying a directory to [bookdown::render_book], the
#' file `index.Rmd` is normally used as the master file for rendering the book
#' and all other files are brought in as chapters in alphabetical order.
#' Here, in the \pkg{sa4ss} package we use `00a.Rmd` as the indexing file and
#' all other .Rmd files are sourced in alphabetical order.
#' The renaming is done automatically for you in the call to [draft] and just
#' mentioned here for completeness.
#'
#' @param dir A vector of file paths pointing to directories that
#' contain draft files, i.e., alphabetized .Rmd files to write the
#' stock assessment(s).
#' It is fine to just pass a single directory.
#' The terminal directory of each value in `dir` is used to name the output files.
#' For example if you pass `dir = 'doc/North'`,
#' then the pdf will be named _North.pdf.
#' The underscore is used to move the pdf,
#' or whatever type of output you are using,
#' to the top of the stack for easier searching.
#'
#' @author Kelli F. Johnson and undergoing testing by Kelli F. Johnson
#' @export
#' @seealso See [compile_internal] for the non-vectorized version of what happens
#' inside each directory.
#' @family compile
#' @examples
#' \dontrun{
#' # An example for lingcod in 2021, where there are some internal function
#' # that help make this easier for finding the directories that won't be
#' # available in your environment but that is okay. Just remove the call
#' # to get_groups() and add a vector of directories inside of doc that
#' # store model files.
#' compile(dir = file.path("doc", get_groups(info_groups)))
#' }
#'
compile <- function(dir = file.path("doc", get_groups(info_groups))) {
	mapply(
		FUN = compile_internal,
		dir = dir
	)
}

#' A non-vectorized version of [compile]
#'
#' A non-vectorized version of [compile] that acts as internal
#' code for the wrapper [compile]. Users typically will not interact
#' with this function, but the code is exported for easier viewing.
#'
#' @param dir A *SINGLE* directory where the draft files are located.
#' @param time The number of seconds you will have to close the pdf
#' if it is found to be open.
#' The integer value is passed to [base::Sys.sleep].
#' @param ... Arguments passed to [bookdown::render_book]
#'
#' @author Kelli F. Johnson
#' @family compile
#' @export
#'
compile_internal <- function(dir,
	time = 10,
	...) {
	# Set working directory back to getwd() upon exit
	stopifnot(length(dir) == 1)
	stopifnot(utils::file_test("-d", dir))
	olddir <- getwd()
	setwd(dir)
	on.exit(setwd(olddir), add = TRUE)

	# Create the file name for the output based on in dir name
	hidden_book_filename <- paste0("_", ifelse(
		basename(dir) == ".",
		basename(getwd()),
		basename(dir)
	))
	tmp_yml <- compile_changebookname(hidden_book_filename)

	# Check if the pdf file exists and if it is open
	test <- tryCatch(
		grDevices::pdf(dir(
			pattern = paste0(hidden_book_filename, ".pdf"),
			full.names = TRUE
		)),
		error = function(e) {
			message(
				"You have ", time, " seconds to close the pdf named ",
				file.path(dir, hidden_book_filename)
			)
			utils::flush.console()
			Sys.sleep(time)
			return(FALSE)
		},
		finally = TRUE
	)
	if (is.null(test)) grDevices::dev.off()

	# Make the document
	bookdown::render_book(
		"00a.Rmd",
		output_dir = getwd(),
		config_file = tmp_yml,
		...
	)

	return(invisible(TRUE))
}

#' Change bookname in the _bookdown.yml file
#'
#' Change the name of the bookdown yaml file that sets up the call
#' to [bookdown::render_book] as suggested on
#' [this Rstudio community thread](https://community.rstudio.com/t/is-it-possible-to-use-variables-set-in-index-rmd-in-the-other-yaml-files/78483/5).
#'
#' @param bookname A character value that will be used to name the output from
#' [bookdown::render_book], which is normally called `_main[ext]`.
#' This value will overwrite whatever you have in `_bookdown.yml` for `bookname`.
#'
#' @author Kelli F. Johnson
#' @family compile
compile_changebookname <- function(bookname) {
	ori_yml <- "_bookdown.yml"
	tmp_yml <- tempfile(fileext = ".yml")
	if (file.exists(ori_yml)) {
		yml_content <- yaml::read_yaml(ori_yml)
	} else {
		yml_content <- list(book_filename = "x")
	}
	yml_content[["book_filename"]] <- bookname
	yaml::write_yaml(yml_content, tmp_yml)
	return(tmp_yml)
}
