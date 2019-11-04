# CompaniesService --------------------------------------------------------
#' Service for interacting with Companies data.
#'
#' @return Object of type R6Class with methods for communication with Companies data.
#'
#' @section Methods:
#' new() Initialize a new Company Service instance.
#'
#' getCompaniesCount() Returns the number of Companies.
#'
#' getCompanies() Returns a data frame of all Companies.
#'
#' getCompany(companyName) Returns a data frame for the required Company name.
#'
#' getOldestCompanies(limit) Returns a data frame of the oldest companies, for the required limit.
#' 
#' getNumberOfCompaniesFoundedPerYear() Returns the number of companies founded per year.
#'
#' @examples
#' \dontrun{
#' mongoConnectionString <- "mongodb+srv://admin:example"
#'
#' MongoDbContext <- ApplicationDbContext$new(
#'   connectionString = mongoConnectionString,
#'   database = "ExampleDatabase",
#'   collection = "ExampleCollection"
#' )
#'
#' testCompaniesService <- CompaniesService$new(DbContext = MongoDbContext)
#' }
#'
#' @export
CompaniesService <- R6::R6Class(
  classname = "CompaniesService",
  private = list(
    context = NULL
  ),
  public = list(
    initialize = function(DbContext)
    {
      # TODO: add validation to check context is of type ApplicationDbContext
      # TODO: add validation to check DbConnection object exist in context
      # TODO: add validation to check companies database and sample_training collection exist
      private$context <- DbContext$DbConnection
    },

    getCompaniesCount = function()
    {
      count <- private$context$count()
      return(count)
    },

    getCompanies = function()
    {
      companies <- private$context$find('{}')
      return(companies)
    },

    getCompany = function(companyName)
    {
      query <- glue::glue('{{"name": "{companyName}"}}')
      company <- private$context$find(query)
      return(company)
    },

    getOldestCompanies = function(limit = 10)
    {
      companies <- private$context$find(
        query = '{"founded_year": {"$ne": null}}',
        sort = '{"founded_year": 1}',
        limit = limit
      )
      return(companies)
    },
    
    getNumberOfCompaniesFoundedPerYear = function()
    {
      query <- '
        [
          {
            "$match": {
              "founded_year": {
                "$exists": true,
                "$ne": null
              }
            }
          },
          {
            "$group": {
              "_id": "$founded_year",
              "count": {
                "$sum": 1
              }
            }
          },
          {
            "$sort": {
              "_id": 1
            }
          }
        ]
      '
      companies <- private$context$aggregate(pipeline = query)
      companies <- companies %>%
        dplyr::rename('founded_year' = '_id')
      
      return(companies)
    }
  )
)
