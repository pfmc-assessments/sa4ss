#' Get Affiliations for Authors
#' 
#' Get addresses for each author using a look-up function, where
#' addresses are stored internally.
#' @template authors
#' @author Kelli Faye Johnson
#' @export
#' @returns A vector the same length as \code{authors} is returned,
#' providing the matching address for each entry as a text string.
#' @examples
#' get_affiliation("Kelli F. Johnson")
#' get_affiliation(c("Kelli F. Johnson", "Chantel R. Wetzel"))
#' # Returns an NA for the unknown name
#' testthat::expect_true(is.na(get_affiliation("Kelli Johnson")))

get_affiliation <- function(authors) {
  e1 <- new.env()
  utils::data(authors, package = "sa4ss", envir = e1)

  abbreviations <- match(authors, get("authors", envir = e1)[, "author"])
  doc <- "U.S. Department of Commerce"
  noaa <- "National Oceanic and Atmospheric Administration"
  nmfs <- "National Marine Fisheries Service"
  nwfsc <- "Northwest Fisheries Science Center"
  swfsc <- "Southwest Fisheries Science Center"
  if (any(is.na(abbreviations))) {
    warning("The following names were not found in 'data-raw\\authors.csv'\n",
      "and will have an address of 'NA' until the csv file is fixed,\n",
      "but also check the spelling and punctuation of entries in authors:\n",
      knitr::combine_words(authors[is.na(abbreviations)]))
  }
  affiliations <- data.frame(
  # Alphabetical order of abbreviations and then affiliations must match order
    abbreviation = c(
      "CDFW",
      "NWFSC_OR",
      "NWFSC_WA",
      "ODFW",
      "SAFS",
      "SWFSC_FE",
      "SWFSC_SC",
      "WCR",
      "WDFW"),
    affiliation = c(
      "California Department of Fish and Wildlife, 350 Harbor Boulevard, Belmont, California 94002",
      paste0(nwfsc, ", ", doc, ", ", noaa, ", ", nmfs, ", ", "2032 Southeast OSU Drive, Newport, Oregon 97365"),
      paste0(nwfsc, ", ", doc, ", ", noaa, ", ", nmfs, ", ", "2725 Montlake Boulevard East, Seattle, Washington 98112"),
      "Oregon Department of Fish and Wildlife, 2040 Southeast Marine Science Drive, Newport, Oregon 97365",
      "School of Aquatic and Fishery Sciences, University of Washington, 1122 Northeast Boat Street, Seattle, Washington 98195",
      paste0(swfsc, ", ", doc, ", ", noaa, ", ", nmfs, ", ", "110 Shaffer Road, Santa Cruz, California 95060"),
      paste0(swfsc, ", ", doc, ", ", noaa, ", ", nmfs, ", ", "110 McAllister Way, Santa Cruz, California 95060"),
      paste("West Coast Region, ", doc, ", ", noaa, ", ", nmfs, ", ", "7600 Sand Point Way, Seattle, Washington 98115"),
      "Washington Department of Fish and Wildlife, 600 Capital Way North, Olympia, Washington 98501")
  )
  affiliations[match(
    get("authors", envir = e1)[abbreviations, "affiliation"],
    affiliations[, "abbreviation"]),
    "affiliation"]
}
