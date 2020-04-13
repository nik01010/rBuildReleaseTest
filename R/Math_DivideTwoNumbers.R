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
  logger::log_debug("Starting division process")
  if (!is.numeric(numerator) || !is.numeric(denominator))
  {
    logger::log_error("Input parameters are not numeric.")
    stop()
  }
  divisionResult <- numerator / denominator
  logger::log_info('The result is {divisionResult}')
  return(divisionResult)
}
