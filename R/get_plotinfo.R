#' The following script will look for the CSV file plotInfoTable created by r4ss
#' in order to automate some of the plots.  The plotInfoTable file is added to the 
#' folder each time SS_plots is run (including when you update any of the plots)
#' The most recent version of plotInfoTable with the complete list of plots will 
#' be used.  
#' 
#' @param mod_loc directory of the model
#' @param plot_folder folder name of the r4ss plots
#'
#' @author Melissa Monk & Chantel Wetzel
#'
get_plotinfo <- function(mod_loc, plot_folder = plotfolder){

  plotdir <- file.path(mod_loc, plot_folder)

  all_files <- list.files(plotdir)
  # look for all files beginning with the name 'plotInfoTable'
  filenames <- all_files[grep("plotInfoTable", all_files)]
  filenames <- filenames[grep(".csv",filenames)]
  if(length(filenames)==0) stop("No CSV files with name 'plotInfoTable...'")
    
  plotInfoTable <- NULL
  # loop over matching CSV files and combine them
  for(ifile in 1:length(filenames)){
    csv <- file.path(plotdir, filenames[ifile])
    temp <- read.csv(csv, colClasses = "character")
    plotInfoTable <- rbind(plotInfoTable, temp)
  }

  plotInfoTable$png_time <- as.POSIXlt(plotInfoTable$png_time)
  
  # look for duplicate file names
  filetable  <- table(plotInfoTable$file)
  duplicates <- names(filetable[filetable>1])
  
  # loop over duplicates and remove rows for older instance
  if(length(duplicates)>0){
  
    #  if(verbose) cat("Removing duplicate rows in combined plotInfoTable based on mutliple CSV files\n")
    for(idup in 1:length(duplicates)){
      duprows <- grep(duplicates[idup], plotInfoTable$file, fixed = TRUE)
      duptimes <- plotInfoTable$png_time[duprows]
      # keep duplicates with the most recent time
      dupbad <- duprows[duptimes != max(duptimes)]
      goodrows <- setdiff(1:nrow(plotInfoTable), dupbad)
      plotInfoTable <- plotInfoTable[goodrows, ]
    }
  }

  plotInfoTable$label = sub(pattern = ".png", '', plotInfoTable$file)
  plotInfoTable$altcaption = NA
  plotInfoTable$loc = plotdir

  write.csv(plotInfoTable, file = file.path(mod_loc, plotfolder, "plotInfoTable_for_doc.csv"),
            row.names = FALSE)
}