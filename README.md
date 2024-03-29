# sa4ss <a href='https://github.com/pfmc-assessments/sa4ss'><img src='man/figures/sa4ss.png' align="right" height="139" alt="sa4ss logo with braille 'accessible science for all'"/></a>

> Accessible science for all is the motto of sa4ss and underpins the code in
> this R library that can be used to summarize output from [Stock
> Synthesis][ss3] in .pdf form.

<!-- badges: start -->
[![R-CMD-check](https://github.com/pfmc-assessments/sa4ss/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/pfmc-assessments/sa4ss/actions/workflows/R-CMD-check.yaml)
[![codecov](https://codecov.io/gh/pfmc-assessments/sa4ss/branch/main/graph/badge.svg)](https://app.codecov.io/gh/pfmc-assessments/sa4ss)
<!-- badges: end -->

## Rationale

sa4ss was created to ease some of the tedious overhead that comes with producing
status updates of marine species for the [Pacific Fishery Management
Council](www.pcouncil.org). The package provides

1. a consistent structure to ease reviewer fatigue,
1. generic text for sections that are consistent across populations,
1. imbedded functionality that works towards creating a tagged pdf that is
   readable via a screen reader and fulfills [NOAA's guidance regarding 508 
   compliance](https://libguides.library.noaa.gov/Section508), and
1. an infrastructure to reduce the time  needed to create a document
   relative to creating it from scratch.

Back to [top](#sa4ss)

## User community

The package is intended for use by analysts within the Northwest and Southwest
Fisheries Science Centers but the developers are happy to entertain ideas
regarding future development scenarios that could facilitate adding additional
templates that would be useful to others.

Regardless of your affiliation, please feel free to post any issues regarding
the package to the [GitHub issues
page](https://github.com/pfmc-assessments/sa4ss/issues) and any questions
regarding how to use the package to the [GitHub discussion
board](https://github.com/pfmc-assessments/sa4ss/discussions). Tags are
available to mark your issue with an appropriate category. These categories are
instrumental in providing guidance to the package maintainers regarding how to
respond to your issue and to other users who follow this repository. Before you
create an issue, please
1. try the [example](#example) to determine if the package works for you in
   general;
1. if the [example](#example) doesn't work, then please try to reinstall the
package before posting an issue, see the [example](#example) for how to do this
without needing to restart your R session.

Back to [top](#sa4ss)

## Example

Below is a minimal example to familiarize yourself with using sa4ss. Before you
can build a document it is wise to work through the following steps:

1. tinytex
  * sa4ss will only work if you have lualatex installed on your computer.
    Thankfully, the R package tinytex contains this compiler. lualatex is not
    standard, typically R users use pdflatex though they do not know it
    :smile:. If you do not already have tinytex on your computer, run the
    following in an R session.
  * Software support is only provided for TeXLive, if you are using MikTex the
    package will not work. Thankfully {tinytex} is based on TeXLive.
  * `pak::pkg_install("rstudio/tinytex")`
  * `tinytex::install_tinytex(bundle = "TinyTeX-2")`
  * If you experience issues with the previous code it is more than likely due
    to firewall or other security settings. These settings can prevent R from
    downloading the [zipped distribution][tinytex_zip] from the [tinytex
    website][tinytex]. I tried downloading the [exe file][tinytex_zip] myself
    and found that an anti-virus application was stopping my computer from
    accessing the file. Automated prompts helped me change the settings on my
    computer that allow [tinytex][tinytex] access to the website. After
    making the necessary changes to my settings and restarting R, I was able
    to use the code above to install the tinytex software.
  * If you already have tinytex, you can use `packageVersion("tinytex")` to
    determine which version you have and `packageDate("tinytex")` to determine when
    it was compiled. Use your best judgment to determine if you should update it or
    not. I err on the side of updating too often.
  * `tinytex::reinstall_tinytex(bundle = "TinyTeX-2")`
  * Personally, I like to have the full distribution of TeXLive on my machine
    rather than the version distributed by tinytex when using the default call
    to `bundle` of `"TinyTeX-1"` because then I know that I have all the
    packages that I need. This is especially true for compiling documents that
    are accessible to those with disabilities as the LaTeX 3 kernel is changing
    daily. `"TinyTeX-2"` will install all packages much like the
    full distribution of TeXLive.
2. Pandoc
  * If you do not already have Pandoc on your computer, then you will need to
    install it using the following directions:
    * via R terminal or Rstudio:
      * `rmarkdown::pandoc_available()`;
      * if the result is `TRUE`, you deserve a :trophy:; move on to the section on
        rtools;
      * if the result is `FALSE`, try adding Pandoc to your path.
      `rmarkdown::pandoc_exec()` will show the path that needs to be added if
      Pandoc is installed. You can 'edit environment variables for your account'
      without needing IT.
    * if the previous step is not successful, then you will need to install
      [Pandoc](https://pandoc.org/installing.html).
    * restart R so new path variables are found!
    * rinse and repeat until successful.
3. rtools
  * If you are using Windows, please make sure that you have rtools installed
    on your machine prior to using sa4ss. I do **NOT** recommend rtools40,
    which was previous to rtools42. You should be using at least R 4.2, which
    requires rtools42.
  * Many think that rtools is just for building packages but it provides a lot of
    functionality with respect to compiling anything such as TMB. You can check if
    you have it already with `pkgbuild::rtools_path(); Sys.getenv("RTOOLS42_HOME")`
  * [Instructions for downloading
    rtools](https://cran.r-project.org/bin/windows/Rtools/) will help you
    download it but ensuring that your path is modified properly will be up to
    you. Please make sure that at least the folder within rtools42 named
    `*\rtools42\x86_64-w64-mingw32.static.posix\bin` is added to your path.
4. sa4ss package
  * Install sa4ss
    * :stop_sign:, do you have a GitHub personal access token (PAT)? GitHub PATs will stop
      you from running into issues surrounding rate limits for GitHub. If you do not
      have a PAT, please navigate to the instructions for [creating a personal
      access token](
      https://docs.github.com/en/github/authenticating-to-github/creating-a-personal-access-token).
      Also, before downloading and installing sa4ss, ensure that you do not already
      have it in your workspace. The first line of code below does that for you.
      Also, I like using {pak}, which will eventually replace {remotes}.
    * `tryCatch(expr = pkgload::unload("sa4ss"), error = function(x) "")`
    * `pak::pkg_install("pfmc-assessments/sa4ss")`
5. Create a pdf
  * As a first test, you will want to run `sa4ss::session_test()` to ensure
    that sa4ss works on your machine.
  * Next, you can try building your own pdf. The following code will set up your
    machine with default files. You only have to run `draft()` once, but the call
    to `bookdown` will be your go-to function for compiling the document after you
    update any of the files.
    The resulting pdf (i.e., `_main.pdf`) will be located within the directory doc
    because I have set `create_dir` to be `TRUE`. If you set it to be `FALSE` then
    it will save the files to your current working directory.
  * See the GitHub action results from the ['bookdown'
      workflow](https://github.com/pfmc-assessments/sa4ss/actions/workflows/bookdown.yaml)
      for example pdf;
    * find the most recent job that was run (i.e., top of the list) and click
      on the name, which will be the name of the most recent commit;
    * scroll to the bottom of the page under the Artifacts label, where you can
      download the zip file called `_main.pdf` that includes the md, tex, and
      pdf files.

``` r
library(sa4ss)
sa4ss::draft(authors = "Kelli F. Johnson", create_dir = TRUE)
setwd("doc")
bookdown::render_book("00a.Rmd", clean = FALSE, output_dir = getwd())
setwd("..")
```

Back to [top](#sa4ss)

## Tips

* [CTAN glossaries package](#ctan-glossaries-package)
* [Adding a figure to your title page](#adding-a-figure-to-your-title-page)

### CTAN glossaries package

The [glossaries package][glossaries] on [CTAN][ctan] can help organize
acronyms. It works by using a [master list of acronyms supplied in sa4ss](
https://github.com/pfmc-assessments/sa4ss/blob/master/inst/rmarkdown/templates/sa/skeleton/sa4ss_glossaries.tex)
and `\gls{}`, which will be the main function that you use in your text.
Glossaries will determine if the term should be abbreviated or if the long form
should be used, where it automatically will use the long form if it is the
first instance. This functionality is helpful when you have code split amongst
multiple files, you expect text to be moved around in the future, you want to
standardize the way things are written, your document has multiple authors.

For more information please see page 16 of the [glossaries for beginners
guide](
https://ctan.math.illinois.edu/macros/latex/contrib/glossaries/glossariesbegin.pdf)
where each function for generating text is explained. In short,

  * `gls{<label>}`: displays the long form in its first use and short form thereafter;
  * `glspl{<label>}`: displays the plural version;
  * `Gls{<label>}`: displays an uppercase version for the beginning of a sentence;
  * `Glspl{<label>}`: displays the plural form of the uppercase version;
  * `glsentryshort{<label>}`: displays the short version and can be used in a header; and
  * `glsentrylong{<label>}`: displays the long version and can be used in a header.

Back to [top](#sa4ss)

### Adding a figure to your title page

You can add a figure to your title page by including `figure_title.png` in the
directory that stores all of your .Rmd files, which are typically called
`doc(s)`. This figure will be centered, placed below your title, and will be
four inches wide. For those who do not want a figure on your title page, just
do nothing. The use of an if statement only includes the figure if it is
present and a default figure is not included in the package. Thanks to
[stack exchange](
https://tex.stackexchange.com/questions/95400/how-to-check-image-exists-or-not)
for providing the code for the if statement.

Back to [top](#sa4ss)

## Code of Conduct

This project adheres to the [National Marine Fisheries Service fish tools code
of
conduct](https://github.com/nmfs-fish-tools/Resources/blob/main/CODE_OF_CONDUCT.md).
By contributing to this project, you agree to abide by its terms.

## Disclaimer

This repository is a scientific product and is not official communication of
the National Oceanic and Atmospheric Administration, or the United States
Department of Commerce. All NOAA GitHub project code is provided on an ‘as is’
basis and the user assumes responsibility for its use. Any claims against the
Department of Commerce or Department of Commerce bureaus stemming from the use
of this GitHub project will be governed by all applicable Federal laws. Any
reference to specific commercial products, processes, or services by service
mark, trademark, manufacturer, or otherwise, does not constitute or imply their
endorsement, recommendation, or favoring by the Department of Commerce. The
Department of Commerce seal and logo, or the seal and logo of a DOC bureau,
shall not be used in any manner to imply endorsement of any commercial product
or activity by DOC or the United States Government.

[ctan]: <https://ctan.org/> "The Comprehensive TEX Archive Network"
[glossaries]: <https://ctan.org/pkg/glossaries?lang=en> "Glossaries package on CTAN"
[ss3]: <https://github.com/nmfs-stock-synthesis/stock-synthesis> "Stock Synthesis code base"
[tinytex]: <https://yihui.org/tinytex> "tinytex website"
[tinytex_zip]: <https://yihui.org/tinytex/TinyTeX-2.exe> "Download tinytex zip file"

Back to [top](#sa4ss)

<img src="https://raw.githubusercontent.com/nmfs-general-modeling-tools/nmfspalette/main/man/figures/noaa-fisheries-rgb-2line-horizontal-small.png" height="75" alt="NOAA Fisheries">

[U.S. Department of Commerce](https://www.commerce.gov/) | [National Oceanographic and Atmospheric Administration](https://www.noaa.gov) | [NOAA Fisheries](https://www.fisheries.noaa.gov/)
