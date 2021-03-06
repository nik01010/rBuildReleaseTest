#' Test R Build and Release
#'
#' rBuildReleaseTest: provides a test case for automated CI/CD pipelines in R
#'
#' This package several main features:
#' \itemize{
#'   \item Creating a connection to a MongoDb database using a reference type R6 class.
#'   \item Querying a MongoDb database through a Service, with an injected context.
#'   \item Using best practice such as unit and integration-style tests, logging, linting, etc.
#'   \item Others... [TBC]
#' }
#'
#' @section Available functionality:
#' The available objects in this package are:
#' \itemize{
#'   \item \code{\link{ApplicationDbContext}}: Base class for creating an injectable MongoDb database context.
#'   \item \code{\link{CompaniesService}}: Service for querying Companies data in a MongoDb database.
#' }
#'
#' @name rBuildRelease
#' @docType package
NULL

## usethis namespace: start
#' @importFrom magrittr %>%
## usethis namespace: end
NULL
