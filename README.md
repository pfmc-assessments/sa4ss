# sa4ss <a href='https://github.com/nwfsc-assess/sa4ss'><img src='inst/logo/sa4ss.png' align="right" height="139" alt="sa4ss logo with braille 'accessible science for all'"/></a>

> A library to generate a stock assessment document in pdf form that incorporates [Stock Synthesis][ss] output.

* [Rationale](#rationale)
* [User community](#user-community)
* [Example](#example)
* [Tips](#tips)
* [Disclaimer](#disclaimer)

# Rationale

sa4ss was created to ease some of the tedious overhead put on analysts when creating stock assessment documents for the [Pacific Fishery Management Council](www.pcouncil.org).
The package provides 
(1) a consistent structure,
(2) generic text that should be the same across all stocks,
(3) imbeded functionality to create an accessible pdf that satisfies [NOAA's guidance for 508 compliance](https://libguides.library.noaa.gov/Section508), and
(4) increased speed compared to creating a word document from scratch.

Back to [table of contents](#sa4ss)

# User community

The package is intended for use by analysts within the Northwest and Southwest Fisheries Science Centers.
Regardless of your affiliation, please feel free to post any issues or questions that you have to the [issues page](https://github.com/nwfsc-assess/sa4ss/issues).
Tags are available to mark your issue with an appropriate category.
These categories are instrumental for providing guidance to the package maintainers regarding how to respond your issue and to other users that follow this repository where they facilitate searching within issues.
Before you create an issue, please try the [example](#example) below to determine if the package works for you in general. If it doesn't work, then please try to reinstall the package before posting an issue. Code to reinstall is also available [below](#example).

Back to [table of contents](#sa4ss)

# Example

Below is a minimal example to familiarize yourself with using sa4ss.
Before you can build a document it is wise to work through the following steps:
* [tinytex](#tinytex)
* [pandoc](#pandoc)
* [rtools40](#rtools40) for windows users
* [sa4ss](#sa4ss-package)
* [create a pdf](#create-a-pdf)

Back to [table of contents](#sa4ss)

## tinytex

If you do not already have tinytex on your computer, run the following in an R session:
``` r
install.packages('tinytex')
tinytex::install_tinytex()
```
If you experience issues with the previous code
it is more than likely due to firewall or other security settings.
These settings can prevent R from downloading of the [zipped distribution][tinytex_zip]
from the [tinytex website][tinytex].
To combat this, I tried to download the [zip file][tinytex_zip] myself and
found that an anti-virus application was stopping my personal computer from
accessing the zip file.
I then used the prompts to proceed to the website and
checked the box to always allow access to [tinytex][tinytex].
The previous code then worked after restarting R.

If you already have tinytex, you can use `packageVersion("tinytex")` to determine which version you have and `packageDate("tinytex")` to determine when it was compiled.
Use your best judgment to determine if you should update it or not. I error on the side of updating too often.
``` r
tinytex::reinstall_tinytex()
```

Back to [table of contents](#sa4ss)

## Pandoc

If you do not already have Pandoc on your computer, then you will need to install it
using the following directions:

(1) via Rstudio:
  * open Rstudio and run `rmarkdown::pandoc_available()`;
  * if the result is `TRUE`, then hug someone and move on to the next topic;
  * if the result if `FALSE`, then you likely need to add Pandoc to your path.
  Running `rmarkdown::pandoc_exec()` will show the path that needs to be added,
  which can be done via 'edit environment variables for your account'
  without needing IT.
  * See below if no path to pandoc is available.

(2) via R terminal:
  * if the previous are successful in that they provide a path variable,
  then give someone a hug;
  * if the previous are not successful, then you will need to install
  [Pandoc](https://pandoc.org/installing.html).

(3) Restart R so new path variables are found!

Back to [table of contents](#sa4ss)

## rtools40

If you are using Windows,
please make sure that you have rtools40 installed on your machine prior to using
`sa4ss`. Many think that rtools40 is just for building packages, but really it
provides a lot of functionality with respect to compiling anything such as TMB.
You can check if you have it already with the following code:
``` r
pkgbuild::rtools_path()
Sys.getenv("RTOOLS40_HOME")
```
[Instructions for downloading rtools40](https://cran.r-project.org/bin/windows/Rtools/)
will help you download it, but ensuring that your path is modified properly will
be up to you. Please make sure that at least the folder within rtools40
named `usr\bin` is added to your path. This folder contains an executable named `sed`
that is integral to proving accessible documents right now. I hope to eventually
remove the dependence, but no such luck at the moment.
Remember to always restart R after performing such an integral install.

Back to [table of contents](#sa4ss)

## sa4ss package

### Install sa4ss

#### Best option for installing
Prior to installing anything using `remotes` you should create a github personal access token, which will stop you from running into issues surrounding rate limits for github.
Please see navigate to the instructions for
[creating a personal access token](https://docs.github.com/en/github/authenticating-to-github/creating-a-personal-access-token)
if you have not already done so.
Also, before downloading and installing sa4ss you will want to make sure that you do not already have it in your workspace, do not worry though, the first line of code below does that for you.
``` r
tryCatch(expr = pkgload::unload("sa4ss"), error = function(x) "")
remotes::install_github("nwfsc-assess/sa4ss")
```

#### Clone
If sa4ss is cloned to your local machine, i.e., `git clone https://github.com/nwfsc-assess/sa4ss.git`,
then navigate to the cloned folder within R and run the following code.
Or, you can set `dirclone` to be something other than your working directory and the following will also work.
``` r
dirclone <- file.path(getwd())
tryCatch(expr = pkgload::unload("sa4ss"), error = function(x) "")
if (file.exists(dirclone)) {
  unlink(dir("..", pattern = "sa4ss_.+\\.tar.gz"))
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

Back to [table of contents](#sa4ss)

### Create a pdf
As a first test, you will want to run `sa4ss::session_test` to ensure that sa4ss works on your machine.
``` r
sa4ss::session_test()
```

Next, you can try building your own pdf.
The following code will set up your machine to start your own stock assessment document from which you can build upon.
You only have to run `draft` once, but the call to `bookdown` will be your go-to function to compile the document after you update any of the files.
The resulting pdf (i.e., `_main.pdf`) will be located within the directory doc because I have set `create_dir` to be `TRUE`. If you set it to be `FALSE` then it will save the files to your current working directory.
``` r
library(sa4ss)
sa4ss::draft(authors = "Kelli F. Johnson", create_dir = TRUE)
setwd("doc")
bookdown::render_book("00a.Rmd", clean = FALSE, output_dir = getwd())
setwd("..")
```

Users can compare this user-generated pdf to the one generated automatically within the package when tests are run to ensure that the package is not broken.
To find the stored pdf,
* first navigate to [github actions](https://github.com/nwfsc-assess/sa4ss/actions);
* find the 'bookdown' workflow from the list on the left and select it;
* find the most recent job that was run (i.e., top of the list) and click on the name, which will be the name of the most recent commit;
* scroll to the bottom of the page under the Artifacts label, where you can download the zip file called `_main.pdf` that includes the md, tex, and pdf files.

Back to [table of contents](#sa4ss)

# Tips

* [CTAN glossaries package](#glossaries)

## CTAN glossaries package

The [glossaries package][glossaries] on [CTAN][ctan] can help organize acronyms.
It works by using a
[master list of acronyms supplied in sa4ss](https://github.com/nwfsc-assess/sa4ss/blob/master/inst/rmarkdown/templates/sa/skeleton/sa4ss_glossaries.tex)
and `\gls{}`, which will be the main function that you use in your text.
Glossaries will determine if the term should be
abbreviated or if the long form should be used, where it
automatically will use the long form if it is the first instance.
This functionality is helpful when you have code split amongst multiple files,
you expect text to be moved around in the future,
you want to standardize the way things are written,
your document has multiple authors.

For more information please see page 16 of the
[glossaries for beginners guide](https://ctan.math.illinois.edu/macros/latex/contrib/glossaries/glossariesbegin.pdf)
where each function for generating text is explained. In short,

  * `gls{<label>}`: displays the long form in its first use and short form thereafter;
  * `glspl{<label>}`: displays the plural version;
  * `Gls{<label>}`: displays an uppercase version for the beginning of a sentence;
  * `Glspl{<label>}`: displays the plural form of the uppercase version;
  * `glsentryshort{<label>}`: displays the short version and can be used in a header; and
  * `glsentrylong{<label>}`: displays the long version and can be used in a header.

Back to [table of contents](#sa4ss)

# Disclaimer

This repository is a scientific product and is not official communication of the National Oceanic and Atmospheric Administration, or the United States Department of Commerce.
All NOAA GitHub project code is provided on an ‘as is’ basis and the user assumes responsibility for its use.
Any claims against the Department of Commerce or Department of Commerce bureaus stemming from the use of this GitHub project will be governed by all applicable Federal law.
Any reference to specific commercial products, processes, or services by service mark, trademark, manufacturer, or otherwise, does not constitute or imply their endorsement, recommendation or favoring by the Department of Commerce.
The Department of Commerce seal and logo, or the seal and logo of a DOC bureau, shall not be used in any manner to imply endorsement of any commercial product or activity by DOC or the United States Government.

[ctan]: <https://ctan.org/> "The Comprehensive TEX Archive Network"
[glossaries]: <https://ctan.org/pkg/glossaries?lang=en> "Glossaries package on CTAN"
[ss]: <https://github.com/nmfs-stock-synthesis/stock-synthesis> "Stock Synthesis code base"
[tinytex]: <https://yihui.org/tinytex> "tinytex website"
[tinytex_zip]: <https://yihui.org/tinytex/TinyTeX-1.zip> "Download tinytex zip file"

Back to [table of contents](#sa4ss)
