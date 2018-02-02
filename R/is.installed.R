#' Is a package installed
#' 
#' \code{is.installed} returns a Boolean describing if a package is installed.
#' 
#' @param mypkg Character vector. Package to be checked.
#' @return Boolean. Is TRUE if the package is installed and available.
#' @keywords internal

is.installed <- function(mypkg) is.element(mypkg, installed.packages()[,1]) 