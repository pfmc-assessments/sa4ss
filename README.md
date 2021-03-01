# sa4ss
> A library to easily generate a stock assessment document in pdf form that incorporates [Stock Synthesis](https://vlab.ncep.noaa.gov/web/stock-synthesis) output.

# Rationale
sa4ss was created to ease some of the tedious overhead put on analysts when creating stock assessment documents for the [Pacific Fisheries Management Council](www.pcouncil.org).
The package provides 
(1) a consistent structure,
(2) generic text that should be the same across all stocks, and
(3) increased speed compared to creating a word document from scratch.

# User community
The package is intended for use by analysts within the Northwest Fisheries Science Center.
Nevertheless, there will be issues and questions that pop up regarding how to use the package and needed features.
Please post any issues or questions that you have using the [issues](https://github.com/nwfsc-assess/sa4ss/issues) feature of github.
Tags are available to mark your post in the appropriate category and the package maintainers, as well as other users that follow this repository, will respond as soon as possible.
When creating an issue, please make sure that you have tried the [example](#example) below to make sure that the package works for you in general. If it doesn't work, then please try to reinstall the package before posting an issue. Code to reinstall is also available [below](#example).

# Example
Below is a minimal example to familiarize yourself with using sa4ss.
The result is a pdf in a folder called doc.
``` r
# If sa4ss is cloned, i.e., git clone https://github.com/nwfsc-assess/sa4ss.git
dirclone <- file.path("setfilepathhere")
if (file.exists(dirclone)) {
  devtools::build(dirclone)
  install.packages(dir(dirname(normalizePath(dirclone)),
    pattern = "sa4ss_[0-9\\.]+\\.tar\\.gz", full.name = TRUE), type = "source")
} else {
  remotes::install_github("nwfsc-assess/sa4ss")
}
if ("package:sa4ss" %in% search()) {
  pkgload::unload(package = "sa4ss")
}
library(sa4ss)
sa4ss::draft(authors = "Kelli F. Johnson", create_dir = TRUE)
setwd("doc")
bookdown::render_book("00a.Rmd", clean = FALSE, output_dir = getwd())
```
