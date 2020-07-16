# sa4ss
> A library to easily generate a stock assessment pdf from [Stock Synthesis](https://vlab.ncep.noaa.gov/web/stock-synthesis) output.

# Example
Below is a minimal example for you to familiarize yourself with generating a stock assessment document using sa4ss.
The result is a pdf in a folder called doc.
``` r
# Do not try to load the package using devtools::load_all()
# because it will not allow for the correct specification of file paths
remotes::install_github("nwfsc-assess/sa4ss")
library(sa4ss)
rmarkdown::draft("doc.Rmd", template = "sa", package = "sa4ss")
rmarkdown::render(file.path("doc", "doc.Rmd"))
```
