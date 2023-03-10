#' Table of parameters
#'
#' @param output A list from [r4ss::SS_output].
#' @param caption A character string for the caption.
#' @param label A character string with the label for the table.
#' No underscores allowed.
#'
table_pars <- function(output,
                       caption = "Parameter estimates, estimation phase, parameter bounds, estimation status, estimated standard deviation (SD), prior information [distribution(mean, SD)] used in the base model.",
                       label = "table-pars-base"
                     ) {
  # Find sigma R
  sigmar <- output[["parameters"]] %>%
    dplyr::filter(grepl("sigma", ignore.case = TRUE, Label)) %>%
    dplyr::pull(Value) %>%
    sprintf("%2.2f", .)
  # to do - Could format the names
  output[["parameters"]] %>%
    dplyr::select(Label, Value, Phase, Min, Max, Pr_type, Prior, Parm_StDev, Pr_SD, Status) %>%
    dplyr::mutate(
      Value = sprintf("%8.3f", Value),
      Bounds = sprintf("(%8.3f, %8.3f)", Min, Max),
      Status = dplyr::case_when(
        is.na(Status) ~ "-",
        Status == "act" ~ "-",
        TRUE ~ Status
      ),
      SD = ifelse(is.na(Parm_StDev), " - ", sprintf("%2.2f", Parm_StDev)),
      pv = sprintf("%2.3f", Prior),
      psd = sprintf("%2.3f", Pr_SD),
      Prior = dplyr::case_when(
        Pr_type == "Log_Norm" ~ paste0("lognormal(", sprintf("%2.3f", exp(Prior)), ", ", psd, ")"),
        Pr_type == "No_prior" ~ "-",
        Pr_type == "Full_Beta" ~ paste0("beta(", pv, ", ", psd, ")"),
        Pr_type == "dev" ~ paste0("normal(0.00, ", sigmar, ")"),
        TRUE ~ Pr_type
      )
    ) %>%
    dplyr::select(Label, Value, Phase, Bounds, Status, SD, Prior) %>%
    kableExtra::kbl(
      align = "lrrrrrr",
      row.names = FALSE,
      longtable = TRUE, booktabs = TRUE,
      format = "latex",
      caption = caption,
      label = label
    ) %>%
    kable_styling_sa4ss(kable_captioncontinue(caption))
}
