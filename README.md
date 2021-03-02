# sa4ss
> A library to easily generate a stock assessment document in pdf form that incorporates [Stock Synthesis](https://vlab.ncep.noaa.gov/web/stock-synthesis) output.

# Rationale
sa4ss was created to ease some of the tedious overhead put on analysts when creating stock assessment documents for the [Pacific Fisheries Management Council](www.pcouncil.org).
The package provides 
(1) a consistent structure,
(2) generic text that should be the same across all stocks, and
(3) increased speed compared to creating a word document from scratch.

# User community
The package is intended for use by analysts within the Northwest and Southwest Fisheries Science Centers.
Regardless of your affiliation, please feel free to post any issues or questions that you have to the [issues page](https://github.com/nwfsc-assess/sa4ss/issues).
Tags are available to mark your issue with an appropriate category.
These categories are instrumental for providing guidance to the package maintainers regarding how to respond your issue and to other users that follow this repository where they facilitate searching within issues.
Before you create an issue, please try the [example](#example) below to determine if the package works for you in general. If it doesn't work, then please try to reinstall the package before posting an issue. Code to reinstall is also available [below](#example).

# Example
Below is a minimal example to familiarize yourself with using sa4ss, which depends on having [tinytex](https://yihui.org/tinytex/) installed.

## tinytex

### Install tinytex
Instructions follow for how to install tinytex if you do not already have it on your computer.
``` r
install.packages('tinytex')
tinytex::install_tinytex()
```

### Updating tinytex
If you already have tinytex, you can use `packageVersion("tinytex")` to determine which version you have and `packageDate("tinytex")` to determine when it was compiled.
Use your best judgement to determine if you should update it or not. I error on the side of updating too often.
``` r
tinytex::reinstall_tinytex()
```

## sa4ss

### Install sa4ss

#### Best option for installing
Prior to installing anything using `remotes` you should create a github personal access token, which will stop you from running into issues surrounding rate limits for github.
Please see navigate to the instructions for
[creating a personal access token](https://docs.github.com/en/github/authenticating-to-github/creating-a-personal-access-token)
if you have not already done so.
Also, before downloading and installing sa4ss you will want to make sure that you do not already have it in your workspace, do not worry though, the first line of code below does that for you.
``` r
tryCatch(
  expr = pkgload::unload("sa4ss"),
  error = function(x) "sa4ss was not loaded, you can install it now."
)
remotes::install_github("nwfsc-assess/sa4ss")
```

#### Clone
If sa4ss is cloned to your local machine, i.e., `git clone https://github.com/nwfsc-assess/sa4ss.git`,
then navigate to the cloned folder within R and run the following code.
Or, you can set `dirclone` to be something other than your working directory and the following will also work.
``` r
dirclone <- file.path(getwd())
tryCatch(
  expr = pkgload::unload("sa4ss"),
  error = function(x) "sa4ss was not loaded, you can install it now."
)
if (file.exists(dirclone)) {
  devtools::build(dirclone)
  filepkgbuild <- dir(
    path = dirname(normalizePath(dirclone)),
    pattern = "sa4ss_[0-9\\.]+\\.tar\\.gz",
    full.name = TRUE
  )
  install.packages(filepkgbuild, type = "source")
  unlink(filepkgbuild)
}
```

### Create a pdf
The resulting pdf (i.e., `_main.pdf`) will be located within the directory doc.
``` r
library(sa4ss)
sa4ss::draft(authors = "Kelli F. Johnson", create_dir = TRUE)
setwd("doc")
bookdown::render_book("00a.Rmd", clean = FALSE, output_dir = getwd())
```

Users can compare this user-generated pdf to the one generated automatically within the package when tests are run to ensure that the package is not broken.
To find the stored pdf,
first navigate to [github actions](https://github.com/nwfsc-assess/sa4ss/actions);
find the 'bookdown' workflow from the list on the left and select it;
find the most recent job that was run (i.e., top of the list) and click on the name, which will be the name of the most recent commit;
scroll to the bottom of the page under the Artifacts label, where you can download the zip file called `_main.pdf` that includes the md, tex, and pdf files.
