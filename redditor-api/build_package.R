library(styler)

base_dir <- "/Users/fdrennan/redditor/redditor-api"

style_dir(base_dir)
style_dir(file.path(base_dir, "R"))

devtools::install(base_dir)
