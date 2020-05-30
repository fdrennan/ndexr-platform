library(redditor)
library(biggr)

new_glue <- function(string) {
  glue(string, .open = "--", .close = "--")
}
VIRTUALENV_NAME <- "redditor"
virtualenv_install(envname = VIRTUALENV_NAME, packages = "praw")
virtualenv_install(envname = VIRTUALENV_NAME, packages = "spacy")
install_python(method = "virtualenv", envname = VIRTUALENV_NAME)
if (Sys.getenv("RETICULATE_PYTHON") != "") {
  system(
    new_glue("echo RETICULATE_PYTHON=${HOME}/.virtualenvs/--VIRTUALENV_NAME--/bin/python >> .Renviron")
  )
}
command_to_install_spacy <- new_glue("${HOME}/.virtualenvs/--VIRTUALENV_NAME--/bin/python -m spacy download en_core_web_sm")
print(command_to_install_spacy)
system(command_to_install_spacy)
