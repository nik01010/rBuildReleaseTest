# InitialiseLogger --------------------------------------------------------------------------------------
#' Initialises a new logger
#' 
#' @param logLevel The required log level threshold to capture in the logger. 
#' Defaults to logger::DEBUG.
#' @param logAppender The required log appender to use in the logger. 
#' Defaults to logger::appender_stdout.
#' @param logMessageFormat The required log message format.
#' Defaults to '[{level}] [{time}] [{namespace}] [{fn}]: {msg}'. 
#' See logger::layout_glue_generator for options.
#' @return NULL
#' @examples
#' \dontrun{
#' # Using  default settings:
#' InitialiseLogger()
#' 
#' # Using another log message format:
#' InitialiseLogger(logLevel = logger::DEBUG, logMessageFormat = '{level}---{time}--- msg')
#' }
#' 
#' @export
InitialiseLogger <- function(
  logLevel = logger::DEBUG, 
  logAppender = logger::appender_stdout,
  logMessageFormat = '[{level}] [{time}] [{namespace}] [{fn}]: {msg}'
) {
  .setLoggerThreshold(logLevel = logLevel)
  .setLoggerAppender(logAppender = logAppender)
  .setLogMessageFormat(format = logMessageFormat)
  logger::log_info("Logger Initialised.")
}

#' @keywords internal
.setLoggerThreshold <- function(logLevel) {
  logger::log_threshold(level = logLevel)
}

#' @keywords internal
.setLoggerAppender <- function(logAppender) {
  logger::log_appender(appender = logAppender)
}

#' @keywords internal
.setLogMessageFormat <- function(format) {
  logFormatGenerator <- logger::layout_glue_generator(format = format)
  logger::log_layout(layout = logFormatGenerator)
}
