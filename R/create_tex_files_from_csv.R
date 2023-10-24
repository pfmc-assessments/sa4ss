#' Create .tex file(s) from a .csv file of specifications
#'
#' First, a .csv file is read in that contains a set of table specifications
#' per row. Second, each set of specifications is passed to
#' [kableExtra::kable()] to create .tex file(s). Third,
#' [kableExtra::save_kable()] is used to save each table. All of the relevant
#' information is returned in a data frame.
#'
#' @details
#' ## Formatting
#' ### Decimal places
#' Decimals are removed from all columns containing integer values with four
#' digits because they are presumed to represent a year. Decimals by default
#' are followed by two digits. If any value in a column is 0.00 after rounding
#' to two digits, additional digits are added on until the entry of interest
#' no longer equals zero and then all values within that row are formatted to
#' have the same number of digits as the "small" value. The previous algorithm
#' is limited to 10 digits.
#' ### Alignment
#' All character columns are left aligned and all numeric columns are right
#' aligned.
#' ## Future development
#' * The automatic determination of how many decimal points a column is
#'   formatted to could use some work. Currently, there is no help for
#'   scientific notation or how to mix scientific notation with fixed values.
#' * How wide a column is printed is automated within [kableExtra::kable()] but
#'   could potentially be defined using a helper function but that would need
#'   to be written.
#' @param file_name A path to the file that stores the table information. The
#'   path can be relative to the current working directory, just the file name
#'   without any directories if it is in the current working directory, or a
#'   full file path starting with the drive. The extension of this path must
#'   end in `".csv"` because only comma separated values can be read in by this
#'   function. Additionally, the file must contain the following headers:
#'   * caption,
#'   * altcaption (optional and currently unused),
#'   * label,
#'   * filename, and
#'   * loc (optional if you pass the full file name in the previous column).
#' @param save_location A path to a directory where you want the output saved.
#'   The path can be relative to your current location or an absolute path. If
#'   `NULL`, which is the default, then the results of this function will be
#'   saved in the same directory as `file_name`. In this case, if the path
#'   given for `filename` is just the file and does not include the directory,
#'   then the result will be `"."`, which references the current working
#'   directory, and will be valid.
#' @author Kelli F. Johnson
#' @export
#' @return
#' A data frame is returned with the following eight columns:
#' * `caption`: a character column containing the captions,
#' * `altcaption`: `NA`
#' * `label`: a character column containing the LaTeX labels for referencing
#'     table in the document,
#' * `filename`: a character column containing the basename of the file path,
#' * `loc`: a character column containing the file paths to `filename`,
#' * `full_location`: a character column containing the full file path to
#'     `filename`,
#' * `x`: a list column containing one data frame per row of the data used to
#'     create the table, and
#' * `tex`: a list column containing output from [kableExtra::kable()] for each
#'     table. The table specifications stored in this column are used
#'     internally to create .tex file(s) that are saved either in the same
#'     directory that `file_name` is located in or in the directory specified
#'     by `save_here_instead`.
create_tex_files_from_csv <- function(file_name, save_here_instead = NULL) {
  save_location <- if (is.null(save_here_instead)) {
    dirname(file_name)
  } else {
    save_here_instead
  }
  # Create the save_loc directory to ensure it exists
  fs::dir_create(save_location)

  # Read in the information,
  # no need to check for file existence b/c that is done in utils::read.csv
  data_all <- utils::read.csv(file = file_name)
  lower_case_column_names <- tolower(colnames(data_all))
  colnames(data_all) <- lower_case_column_names
  correct_column_names <- c("caption", "label", "filename")
  # Check that the correct headers exist in data_all
  if (!any(correct_column_names %in% lower_case_column_names)) {
    purrr::walk(
      correct_column_names[correct_column_names %in% lower_case_column_names],
      .f = \(x) cli::cli_alert_danger(
        paste0("{.var ", x, "} is not a column name of {.var file_name}")
      )
    )
  }

  # Create legitimate file names. If users do not specify loc, then it is
  # assumed that all files will be in the same directory as the csv file
  loc_column_number <- grep("loc", colnames(data_all))
  stopifnot(length(loc_column_number) < 2)
  if (length(loc_column_number) == 0) {
    data_all[, "loc"] <- dirname(data_all[["filename"]])
    data_all[data_all[["loc"]] == ".", "loc"] <- dirname(file_name)
  }
  data_all[["full_location"]] <- fs::path(
    data_all[["loc"]],
    data_all[["filename"]]
  )
  # Print warning bullets for each file that is not found
  bad_files <- !fs::file_exists(data_all[["full_location"]])
  purrr::walk(
    .x = data_all[which(bad_files), "filename"],
    .f = \(x) cli::cli_alert_warning(
      wrap = TRUE,
      text = paste0(
        "File {.var ", x, "} does not exist and thus no associated .tex file",
        " will be created."
      )
    )
  )

  # Create the individual tex files
  data_files <- data_all[!bad_files, ] |>
    dplyr::mutate(
      x = purrr::map(
        .x = full_location,
        .f = \(x) utils::read.csv(x, check.names = FALSE)
      ),
      tex = purrr::pmap(
        .l = list(x, label, caption),
        .f = function(a, b, c) sa4ss::table_format(
          x = as.data.frame(a),
          label = b,
          caption = c,
          longtable = FALSE,
          align = determine_alignment(as.data.frame(a))
        )
      ),
      save = purrr::map2(
        .x = tex,
        .y = gsub(pattern = "\\.csv$", "\\.tex", full_location),
        .f = kableExtra::save_kable
      )
    )
  return(data_files |> dplyr::select(-save))
}

determine_alignment <- function(data) {
  alignment <- ifelse(
    test = purrr::map_lgl(
      data,
      # Regex for 0,000 or 0.0 or NA in all entries within a column
      \(x) all(grepl("^[0-9,]+$|[0-9,]+[,\\.][0-9,]+", x) | is.na(x))
    ),
    yes = "r",
    no = "l"
  )
  return(alignment)
}

determine_digits <- function(data) {
  purrr::map_int(data, determine_digits_x)
}
determine_digits_x <- function(x) {
  n_digits <- as.numeric(dplyr::case_when(
    # If it is not a number
    !is.numeric(x) ~ "0",
    # If it is a four digit integer, e.g., a year
    all(grepl("^[0-9]{4}$", x)) ~ "0",
    # If the value is zero
    all(x == 0) ~ "0",
    # All others but refine below
    TRUE ~ "2",
  ))

  # Refine the number of digits
  if (n_digits > 0) {
    while(
      any(grepl(
        pattern = "^0\\.0+$",
        format(x = round(x, n_digits), nsmall = n_digits, signif = FALSE)
      )) &&
      n_digits < 10
    ) {
      n_digits <- n_digits + 1
    }
  }

  return(n_digits)
}
