library(redditor)
library(biggr)

new_glue <- function(string) {
  glue(string, .open = "--", .close = "--")
}

VIRTUALENV_NAME <- 'redditor'
virtualenv_install(envname = VIRTUALENV_NAME, packages = 'praw')
install_python(method = 'virtualenv', envname = VIRTUALENV_NAME)

if (Sys.getenv('RETICULATE_PYTHON') != '') {
    system(
      new_glue('echo RETICULATE_PYTHON=${HOME}/.virtualenvs/--VIRTUALENV_NAME--/bin/python >> .Renviron')
    )
}
