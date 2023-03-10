#' Create a caption for a longtable that is continued
#'
#' Create a caption that can be used on the repeated pages of a longtable
#' that spans multiple pages.
#' The value returned from this function should be used in
#' [kableExtra::kable_styling] or passed to [kable_styling_sa4ss].
#'
#' @param caption The caption you want on the subsequent pages.
#' Typically, you will want more than the default argument of nothing,
#' which leads to `... continued.` because this text is pasted onto
#' whatever you pass to this argument.
#' @param max The maximum number of words you want to pull from your
#' caption that you supplied.
#' The default is eight words because this typically leads to just one line.
#'
#' @author Kelli F. Johnson
#' @export
#'
kable_captioncontinue <- function(caption = "", max = 8) {
  subcaption <- strsplit(caption, "\\s")[[1]]
  out <- paste(
    paste(
      collapse = " ",
      subcaption[1:min(c(max, length(subcaption)))]
    ),
    "... \\emph{continued}."
  )
  return(out)
}

#' Formatting for a long table with repeated headers
#'
#' @param ktable A table from [kableExtra::kbl].
#' @param caption The caption you want to be repeated on the continuing pages
#' of a longtable that spans more than one page.
#'
#' @author Kelli F. Johnson
#' @export
#'
#' @details repeat_header_continued:
#' The argument `repeat_header_continued`,
#' which is passed to [kableExtra::kable_styling],
#' creates a horizontal line at the bottom of your long table on every page.
#' Whereas, when this is `FALSE`, which is the default,
#' then the bottom of a long table is open insinuating that the table continues.
#' You can also add text to this argument that will be displayed below the
#' horizontal line.
#'
#'
kable_styling_sa4ss <- function(ktable, caption) {
  ktable %>% kableExtra::kable_styling(
    latex_options = c("repeat_header"),
    repeat_header_method = "replace",
    repeat_header_continued = FALSE,
    repeat_header_text = caption
  )
}
