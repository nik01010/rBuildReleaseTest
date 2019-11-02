# divideTwoNumbers --------------------------------------------------------
#' Divides two numbers
#'
#' @param numerator Numeric. Numerator to use in division.
#' @param denominator Numeric. Denominator to use in division.
#'
#' @return Division result. Numeric.
#' @examples
#' divideTwoNumbers(numerator = 4, denominator = 2)
#' @export
divideTwoNumbers <- function(numerator, denominator)
{
  logging::logdebug("Starting division process")
  if (!is.numeric(numerator) || !is.numeric(denominator))
  {
    errorMessage <- "Input parameters are not numeric."
    logging::logerror(errorMessage)
    stop(errorMessage)
  }
  divisionResult <- numerator / denominator
  logging::loginfo(glue::glue('The result is {divisionResult}'))
  return(divisionResult)
}
