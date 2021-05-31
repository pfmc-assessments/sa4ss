# Create the logo for the sa4ss package using hexSticker and nmfspalette
# modelled after the nmfspalette hexsticker
# https://github.com/nmfs-general-modeling-tools/nmfspalette/blob/main/R/make_hex.R

sa4sssticker <- hexSticker::sticker(
  package = "sa4ss",
  filename = file.path(
    system.file("inst", "logo",  package = "sa4ss"),
    "sa4ss.png"
  ),
  p_size = 18,
  p_y = 1.65,
  p_color = nmfspalette::nmfs_cols("darkblue"),
  subplot = system.file("inst", "logo", "braille_accessible.png", package = "sa4ss"),
  s_x = 1, s_y = 0.99, s_width = 0.95, s_height = 0.95,
  h_fill = "grey12", h_size = 1.2,
  h_color = nmfspalette::nmfs_cols("darkblue"),
  spotlight = FALSE,
  l_y = 1.65, l_width = 1.4, l_alpha = 0.2,
  url = "https://github.com/nwfsc-assess/sa4ss/",
  u_size = 4,
  u_color = nmfspalette::nmfs_cols("darkblue")
)
