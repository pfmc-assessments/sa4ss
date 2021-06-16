#' Create a \pkg{sa4ss} an RData object
#'
#' Read an SS model output using \pkg{r4ss} to create a RData object with defined quantities
#' to be used when creating an assessment document using sa4ss
#' document written with \pkg{sa4ss}.
#'
#' @details
#' Read an SS model output using \pkg{r4ss} to create a RData object with defined quantities
#' to be used when creating an assessment document using sa4ss
#' document written with \pkg{sa4ss}.
#'
#' @template mod_loc
#' @param save_loc optional input that requires a full path which will 
#' allow users to save the tex file created from csv files to a specific location (e.g. inside doc folder)
#' other than the \code{file.path(mod_loc, table_folder)}. Default NULL
#' @param plotfolder location of the r4ss figure directory
#' @param printstats Input to \code{\link[r4ss]{SS_output}} to prevent output to the screen
#' @param fecund_mult User input to define the multiplier for fecundity in terms of eggs if
#' fecundity is defined in terms of numbers within SS.  The default is millions of eggs but
#' there may be instances where the multiplier may be lower or higher, billions or thousands,
#' which can be revised by the user. If the fecundity units in SS are set as biomass then the
#' fecundity units (fecund_unit) will be set as metric tons.
#' @param create_plots TRUE//FALSE to specify whether to create model plots using r4ss
#' @param png TRUE create png plot files
#' @param html create html files
#' @param datplot create the data plots using \code{\link[r4ss]{SS_plots}}
#' @param fleetnames A vector of user-defined fleet names.
#' If input left as the default value of \code{NULL}, then the model-object fleet
#' names will be used.
#' @param forecastplot Add forecast years to figure plost
#' @param maxrows Number of rows for plots. Default set to 4.
#' @param maxcols Number of columns for plots. Default set to 4.
#' @param bub_scale Bubble scale size to use for plotting.
#' @param create_tables TRUE/FALSE to run \code{\link[r4ss]{SSexecutivesummary}} tables
#' @param ci_value To calculate confidence intervals, default is set at 0.95
#' @param es_only TRUE/FALSE switch to produce only the executive summary tables
#' will be produced, default is FALSE which will return all executive summary
#' tables, historical catches, and numbers-at-ages
#' @param tables Which tables to produce (default is everything). Note: some
#' tables depend on calculations related to previous tables, so will fail
#' if requested on their own (e.g., Table 'f' can't be created
#' without also creating Table 'a')
#' @param divide_by_2 This will allow the user to calculate single sex values
#' based on the new sex specification (-1) in SS for single sex models. Default value is FALSE.
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
#' simplemod_loc <- tail(dir(pattern = "simple",
#'   system.file("extdata", package = "r4ss"),
#'   full.names = TRUE), 1)
#' sa4ss::read_model(mod_loc = simplemod_loc,
#'   fecund_mult = "billion eggs")
#' }
#' @export
#' @author Chantel Wetzel
#'
read_model <- function(
  mod_loc,
  save_loc = NULL,
  plotfolder = 'plots',
  printstats = FALSE,
  fecund_mult = 'million eggs',
  create_plots = TRUE,
  png = TRUE,
  html = FALSE,
  datplot = TRUE,
  fleetnames = NULL,
  forecastplot = TRUE,
  maxrows = 4,
  maxcols = 4,
  bub_scale = 6,
  create_tables = TRUE, 
  ci_value = 0.95,
  es_only = FALSE,
  tables = c('a','b','c','d','e','f','g','h','i','catch', 'timeseries', 'numbers'),
  divide_by_2 = FALSE,
  adopted_ofl = NULL,
  adopted_abc = NULL,
  adopted_acl = NULL,
  forecast_ofl = NULL,
  forecast_abc = NULL,
  ...)
{

  model = r4ss::SS_output(dir = mod_loc,
                          printstats = printstats,
                          ...)

  plot_dir = file.path(mod_loc, plotfolder)
  table_dir = file.path(mod_loc, 'tables')

  # Determine the fecundity units
  fecund = model$SpawnOutputUnits 
  # Fecundity text depending on the input value above (can change this line if you like)
  if(fecund == 'numbers'){fecund_unit = fecund_mult} else {fecund_unit = 'mt'} 

  # Define model years to be used dynamically in text
  startyr = model$startyr
  endyr = model$endyr
  last10 = endyr - 8
  currentyr = endyr + 1
  project_start = min(model$timeseries$Yr[model$timeseries$Era == 'FORE'])
  project_end = max(model$timeseries$Yr[model$timeseries$Era == 'FORE'])

  # Determine management targets
  fore = r4ss::SS_readforecast(file = file.path(mod_loc, "forecast.ss"), verbose = FALSE)
  spr_target  = fore$SPRtarget
  bio_target  = fore$Btarget
  msst = ifelse(bio_target == 0.40, 0.25, 0.125)

  # Determine the minumum summary age
  starter = r4ss::SS_readstarter(file = file.path(mod_loc, "starter.ss"), verbose = FALSE)
  min_sum_age = paste0(starter$min_age_summary_bio, "+")

  if (create_plots){
    if(is.null(fleetnames)){
        fleetnames = model$FleetNames
    }
    r4ss::SS_plots(replist = model,
                   png = png,
                   html = html,
                   datplot = datplot,
                   fleetnames = fleetnames,
                   forecastplot = forecastplot,
                   maxrows = maxrows,
                   maxcols = maxcols,
                   maxrows2 = maxrows,
                   maxcols2 = maxcols,
                   printfolder = plotfolder,
                   bub.scale.dat = bub_scale)
  }

  get_plotinfo(mod_loc = mod_loc, plot_folder = plotfolder)

  if (create_tables){
    r4ss::SSexecutivesummary(replist = model,
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
                            verbose = FALSE)
  }

  dir.create(file.path(mod_loc, "tex_tables"), showWarnings = FALSE)
  dir.create(save_loc, showWarnings = FALSE)
  es_table_tex(dir = mod_loc, table_folder = 'tables', save_loc = save_loc)

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
       file = file.path(getwd(), "00mod.Rdata"))

  return()
}
