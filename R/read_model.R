#' Create an RData object specific for \pkg{sa4ss}
#'
#' Use [r4ss::SS_output()] to read model output from
#' Stock Synthesis and save the resulting object as `.RData`.
#'
#' @details
#' This RData object will have defined quantities such that
#' {sa4ss} functions can easily be used to write documentation.
#' Thus, saving users from having to perform multiple similar calculations.
#'
#' @template mod_loc
#' @param save_loc An optional argument passed to [es_table_tex()] pointing to
#'   the directory where you want `.tex` files to be saved to.
#'   For example, `file.path(getwd(), "doc")`. Use full paths.
#'   See [es_table_tex()] for details of the default behavior i.e., `NULL`,
#'   which leads to `file.path(mod_loc, table_folder)`.
#' @param plotfolder A file path relative to `mod_loc` where
#'   the figures will be saved. The argument is passed to `printfolder` in
#'   [r4ss::SS_plots()]. The default is `plots`.
#' @param add_prefix Optional input that should be continous text if used that  
#' allows users to append a specific identifier to the tex table labels and the
#' created tex files save the tex file. This option supports the ability to create
#' a joint executive summary for a stock with multiple sub-area models. Default NULL
#' @param add_text Optional input that should be text and can have spaces. Any input will
#' be incorporated into table captions created for the executive summary using r4ss:SSexecutivesummary
#' function. For example, add_text = "South of Point Conception" will be appended to all captions
#' to indicate the sub-area model. Default NULL.
#' @param printstats `r lifecycle::badge("deprecated")`
#'   `printstats = FALSE` is no longer supported;
#'   this function will always suppress printing output to the screen with
#'   `r4ss::SS_output(printstats = FALSE, verbose = FALSE)`.
#' @param fecund_mult A character string,
#'   providing the multiplier for fecundity in terms of eggs
#'   if fecundity is defined in terms of numbers within Stock Synthesis.
#'   The default is millions of eggs but billions or thousands could be used.
#'   If the fecundity units, i.e.,
#'   `r4ss::SS_output()$SpawnOutputUnits == "biomass"`,
#'   then `fecund_unit` will be changed to `fecund_unit = "mt".
#' @param create_plots A logical that leads to executing [r4ss::SS_plots()]
#'   and creating the suite of {r4ss} figures,
#'   where default is `TRUE`.
#' @param png `r lifecycle::badge("deprecated")`
#'   `png = FALSE` is no longer supported;
#'   this function will always print graphics to the disk if `create_plots = TRUE`,
#'   which is the default behavior of [r4ss::SS_plots()].
#' @param html `r lifecycle::badge("deprecated")`
#'   `html = TRUE` is no longer supported;
#'   this function will always stop [r4ss::SS_plots()] from running
#'   [r4ss::SS_html()].
#' @param datplot `r lifecycle::badge("deprecated")`
#'   `datplot = FALSE` is no longer supported; plots of the data are
#'   always created with `r4ss::SS_plots(datplot = TRUE)`.
#' @param fleetnames A vector of user-defined fleet names.
#' The default behavior of `NULL` leads to the use of
#'   `fleetnames = r4ss::SS_output$FleetNames`.
#' @param forecastplot `r lifecycle::badge("deprecated")`
#'   `forecastplot = FALSE` is no longer supported; plots of the data are
#'   always created with `r4ss::SS_plots(forecastplot = TRUE)`.
#'   This behavior helps ensure that users of Stock Synthesis are aware
#'   of the specifications that are present in the forecast file, i.e.,
#'   if you do not want to display forecasts then turn off forecasting in
#'   the `forecast.ss` file.
#' @param maxrows Number of rows for plots. Default set to 4.
#' @param maxcols Number of columns for plots. Default set to 4.
#' @param bub_scale Bubble scale size to use for plotting.
#'   Passed to the `bub.scale.dat = ` argument in [r4ss::SS_plots()].
#' @param create_tables `r lifecycle::badge("deprecated")`
#'   `create_tables` is no longer needed; the call to
#'   [r4ss::SSexecutivesummary()] is made if a character vector is
#'   passed to the `tables` argument, and thus, the old behavior of
#'   `create_tables = FALSE` can be recreated with `tables = NULL`.
#' @param ci_value A single numerical value specifying the desired
#'   confidence interval, where the default is to calculate the 95% interval.
#'   `ci_value` is passed to [r4ss::SSexecutivesummary()].
#' @param es_only TRUE/FALSE switch to produce only the executive summary tables
#' will be produced, default is FALSE which will return all executive summary
#' tables, historical catches, and numbers-at-ages
#' @param tables Which tables to produce (default is everything). Note: some
#' tables depend on calculations related to previous tables, so will fail
#' if requested on their own (e.g., Table 'f' can't be created
#' without also creating Table 'a')
#' @param divide_by_2 This will allow the user to calculate single sex values
#' based on the new sex specification (-1) in SS3 for single sex models. Default value is FALSE.
#' TRUE will divide by 2.
#' @param adopted_ofl Vector of adopted ofl values to be printed in the mangagement performance
#' table. This should be a vector of 10 values.
#' @param adopted_abc Vector of adopted abc values to be printed in the mangagement performance
#' table. This should be a vector of 10 values.
#' @param adopted_acl Vector of adopted acl values to be printed in the mangagement performance
#' table. This should be a vector of 10 values.
#' @param adopted_acl Vector of adopted acl values to be printed in the mangagement performance
#' table. This should be a vector of 10 values.
#' @param forecast_ofl Optional input vector for management adopted OFL values for table g. These values
#' will be overwrite the OFL values in the projection table, rather than the model estimated
#' OFL values. Example input: c(1500, 1300)
#' @param forecast_abc Optional input vector for management adopted ABC values for table g. These values
#' will be overwrite the ABC values in the projection table, rather than the model estimated
#' ABC values. Example input: c(1500, 1300)
#' @param ... Additional input arguments passed to \code{\link[r4ss]{SS_output}} for reading
#' output files from Stock Synthesis into a list.
#'
#' @examples
#' \dontrun{
#' simplemod_loc <- tail(dir(
#'   pattern = "simple",
#'   system.file("extdata", package = "r4ss"),
#'   full.names = TRUE
#' ), 1)
#' sa4ss::read_model(
#'   mod_loc = simplemod_loc,
#'   fecund_mult = "billion eggs"
#' )
#' }
#' @export
#' @author Chantel Wetzel
#'
read_model <- function(mod_loc,
                       save_loc = NULL,
                       plotfolder = "plots",
                       add_prefix = NULL,
                       add_text = NULL,
                       printstats = lifecycle::deprecated(),
                       fecund_mult = "millions of eggs",
                       create_plots = TRUE,
                       png = lifecycle::deprecated(),
                       html = lifecycle::deprecated(),
                       datplot = lifecycle::deprecated(),
                       fleetnames = NULL,
                       forecastplot = TRUE,
                       maxrows = 4,
                       maxcols = 4,
                       bub_scale = 6,
                       create_tables = lifecycle::deprecated(),
                       ci_value = 0.95,
                       es_only = FALSE,
                       tables = c("a", "b", "c", "d", "e", "f", "g", "h", "i", "catch", "timeseries", "numbers"),
                       divide_by_2 = FALSE,
                       adopted_ofl = NULL,
                       adopted_abc = NULL,
                       adopted_acl = NULL,
                       forecast_ofl = NULL,
                       forecast_abc = NULL,
                       ...) {
  if (lifecycle::is_present(printstats)) {
    lifecycle::deprecate_soft(
      when = "0.0.0.9015",
      what = "read_model(printstats)",
      details = paste(
        sep = "\n",
        "'r4ss::SS_output(printstats = FALSE, verbose = FALSE)'",
        "is forced internally in sa4ss::read_model()."
      )
    )
  }
  if (lifecycle::is_present(png)) {
    lifecycle::deprecate_soft(
      when = "0.0.0.9015",
      what = "read_model(png)",
      details = paste(
        sep = "\n",
        "'r4ss::SS_plots(png = TRUE)'",
        "is forced internally in sa4ss::read_model()."
      )
    )
  }
  if (lifecycle::is_present(html)) {
    lifecycle::deprecate_soft(
      when = "0.0.0.9015",
      what = "read_model(html)",
      details = paste(
        sep = "\n",
        "'r4ss::SS_plots(html = FALSE)'",
        "is forced internally in sa4ss::read_model()."
      )
    )
  }
  if (lifecycle::is_present(datplot)) {
    lifecycle::deprecate_soft(
      when = "0.0.0.9015",
      what = "read_model(datplot)",
      details = paste(
        sep = "\n",
        "'r4ss::SS_plots(datplot = TRUE)'",
        "is forced internally in sa4ss::read_model()."
      )
    )
  }
  if (lifecycle::is_present(create_tables)) {
    lifecycle::deprecate_soft(
      when = "0.0.0.9015",
      what = "read_model(create_tables)",
      details = paste(
        sep = "\n",
        "If `tables = NULL` then essentially `create_tables = FALSE`",
        "making `create_tables` unnecessary. Thus, the previous default",
        "behavior of `create_tables = TRUE` is still the default."
      )
    )
  }
  model <- r4ss::SS_output(
    dir = mod_loc,
    printstats = FALSE, verbose = FALSE
  )

  plot_dir <- file.path(mod_loc, plotfolder)
  table_dir <- file.path(mod_loc, "tables")

  # Determine the fecundity units
  fecund <- model$SpawnOutputUnits
  # Fecundity text depending on the input value above (can change this line if you like)
  if (fecund == "numbers") {
    fecund_unit <- fecund_mult
  } else {
    fecund_unit <- "mt"
  }

  # Define model years to be used dynamically in text
  startyr <- model$startyr
  endyr <- model$endyr
  last10 <- endyr - 8
  currentyr <- endyr + 1
  project_start <- min(model$timeseries$Yr[model$timeseries$Era == "FORE"])
  project_end <- max(model$timeseries$Yr[model$timeseries$Era == "FORE"])

  # Determine management targets
  fore <- r4ss::SS_readforecast(file = file.path(mod_loc, "forecast.ss"), verbose = FALSE)
  spr_target <- fore$SPRtarget
  bio_target <- fore$Btarget
  msst <- ifelse(bio_target == 0.40, 0.25, 0.125)

  # Determine the minimum summary age
  starter <- r4ss::SS_readstarter(file = file.path(mod_loc, "starter.ss"), verbose = FALSE)
  min_sum_age <- paste0(starter$min_age_summary_bio, "+")

  if (create_plots) {
    if (is.null(fleetnames)) {
      fleetnames <- model$FleetNames
    }
    r4ss::SS_plots(
      replist = model,
      html = FALSE,
      datplot = TRUE,
      fleetnames = fleetnames,
      forecastplot = forecastplot,
      maxrows = maxrows,
      maxcols = maxcols,
      maxrows2 = maxrows,
      maxcols2 = maxcols,
      printfolder = plotfolder,
      bub.scale.dat = bub_scale
    )
  }

  get_plotinfo(mod_loc = mod_loc, plot_folder = plotfolder)

  if (!is.null(tables)) {
    r4ss::SSexecutivesummary(
      replist = model,
      add_text = add_text,
      so_units = fecund_unit,
      ci_value = ci_value,
      es_only = es_only,
      tables = tables,
      fleetnames = fleetnames,
      divide_by_2 = divide_by_2,
      endyr = endyr,
      adopted_ofl = adopted_ofl,
      adopted_abc = adopted_abc,
      adopted_acl = adopted_acl,
      forecast_ofl = forecast_ofl,
      forecast_abc = forecast_abc,
      format = FALSE,
      verbose = FALSE
    )
  }

  dir.create(file.path(mod_loc, "tex_tables"), showWarnings = FALSE)
  dir.create(save_loc, showWarnings = FALSE)
  es_table_tex(dir = mod_loc, add_prefix = add_prefix, table_folder = "tables", save_loc = save_loc)

  save(mod_loc,
    plot_dir,
    table_dir,
    model,
    fecund_unit,
    startyr,
    endyr,
    last10,
    currentyr,
    project_start,
    project_end,
    spr_target,
    bio_target,
    msst,
    min_sum_age,
    file = file.path(getwd(), "00mod.Rdata")
  )

  return()
}
