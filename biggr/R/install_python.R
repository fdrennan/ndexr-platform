#' install_python: sets up python environment for awsR
#' @param method  method argument for py_install
#' @param conda  conda argument for py_install
#' @param envname  a conda or python virtual environment name
#' @export install_python
install_python <- function (method = "auto", conda = "auto", envname = 'r_reticulate')  {
  reticulate::py_install("scipy", method = method, conda = conda, envname = envname)
  reticulate::py_install("awscli", method = method, conda = conda, envname = envname)
  reticulate::py_install("boto3", method = method, conda = conda, envname = envname)
}

