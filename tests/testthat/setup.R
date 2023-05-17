# Setup for the unit tests

# Check for lualatex
if (!requireNamespace("tinytex", quietly = TRUE)) {
  install.packages("tinytex")
}
if (any(tinytex:::which_bin(c("tlmgr", "pdftex", "xetex", "luatex")) == "")) {
  tinytex::install_tinytex(bundle = "TinyTex")
}
if (!tinytex::check_installed("glossaries")) {
  tinytex::tlmgr_install("glossaries")
}
