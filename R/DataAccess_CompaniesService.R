# CompaniesService --------------------------------------------------------
#' Service for interacting with Companies data.
#'
#' @return Object of type R6Class with methods for communication with Companies data.
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
#' testCompaniesService <- CompaniesService$new(dbContext = MongoDbContext)
#' }
#'
#' @export
CompaniesService <- R6::R6Class(
  classname = "CompaniesService",
  
  private = list(
    .context = NULL,
    .schemaValidator = NULL
  ),
  
  public = list(
    #' @description Initialize a new CompaniesService object.
    #' @param dbContext ApplicationDbContext object.
    #' @param schemaValidator SchemaValidator object.
    #' @return A new CompaniesService object.
    initialize = function(dbContext, schemaValidator)
    {
      # TODO: add validation to check context is of type ApplicationDbContext
      # TODO: add validation to check DbConnection object exist in context
      # TODO: add validation to check companies database and sample_training collection exist
      private$.context <- dbContext$DbConnection

      # TODO: check validator is the right type
      private$.schemaValidator <- schemaValidator
      
      logger::log_info("Initialised Companies Service.")
    },

    #' @description Gets the number of Companies.
    #' @return Integer.
    GetCompaniesCount = function()
    {
      count <- private$.context$count()
      return(count)
    },

    #' @description Returns a data frame of all Companies.
    #' @return Dataframe.
    GetCompanies = function()
    {
      companies <- private$.context$find(query = '{}')
      return(companies)
    },

    #' @description Returns a data frame for the required Company name.
    #' @param companyName Company name string.
    #' @return Dataframe.
    GetCompany = function(companyName)
    {
      query <- glue::glue('{{"name": "{companyName}"}}')
      company <- private$.context$find(query = query)
      return(company)
    },
    
    #' @description Returns the Id of the required Company name.
    #' @param companyName Company name string.
    #' @return Integer.
    GetCompanyId = function(companyName)
    {
      query <- glue::glue('{{"name": "{companyName}"}}')
      company <- private$.context$find(query = query, fields = '{"_id": 1}')
      if (nrow(company) == 0) {
        return(NULL)
      }
      
      companyId <- company$`_id`
      return(companyId)
    },

    #' @description Returns a data frame of the oldest Companies, for the required limit.
    #' @param limit Number of Companies to limit the results to.
    #' @return Dataframe.
    GetOldestCompanies = function(limit = 10)
    {
      companies <- private$.context$find(
        query = '{"founded_year": {"$ne": null}}',
        sort = '{"founded_year": 1}',
        limit = limit
      )
      return(companies)
    },
    
    #' @description Returns the number of Companies founded per year.
    #' @return Dataframe.
    GetNumberOfCompaniesFoundedPerYear = function()
    {
      query <- '[
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
      ]'
      companies <- private$.context$aggregate(pipeline = query)
      companies <- companies %>%
        dplyr::rename('founded_year' = '_id')
      
      return(companies)
    },
    
    #' @description Creates a new Company record.
    #' @param companyDetails JSON string with new Company details.
    CreateCompany = function(companyDetails)
    {
      # TODO: check if companyDetails is a json object
      # TODO: check there is only one company included
      companyIsValid <- private$.schemaValidator(json = companyDetails, verbose = TRUE)
      if (!companyIsValid)
      {
        errorMessage <- "New company is not valid."
        logger::log_debug(companyIsValid)
        logger::log_error(errorMessage)
        stop(errorMessage)
      }
      
      newCompanyDetails <- jsonlite::fromJSON(txt = companyDetails)
      newCompanyName <- newCompanyDetails$name
      companyAlreadyExists <- self$GetCompanyId(companyName = newCompanyName)
      if (!is.null(companyAlreadyExists)) {
        errorMessage <- glue::glue("Company {newCompanyName} already exists.")
        logger::log_error(errorMessage)
        stop(errorMessage)
      }
      
      tryCatch({
        private$.context$insert(data = companyDetails, stop_on_error = TRUE)
      },
      error = function(errorMessage) {
        logger::log_error(errorMessage)
        stop(errorMessage)
      })
    },
    
    #' @description Edits an existing Company record.
    #' @param companyName Company name string.
    #' @param newCompanyDetails JSON string with new Company details.
    EditCompany = function(companyName, newCompanyDetails)
    {
      # TODO: check if companyDetails is a json object
      # TODO: check there is only one company included
      
      oldCompanyId <- self$GetCompanyId(companyName = companyName)
      
      if (is.null(oldCompanyId) || length(oldCompanyId) == 0)
      {
        errorMessage <- glue::glue('Company with name {companyName} does not exist.')
        logger::log_error(errorMessage)
        stop(errorMessage)
      }
      
      if (length(oldCompanyId) > 1)
      {
        errorMessage <- glue::glue('Multiple companies exist with the name {companyName}.')
        logger::log_error(errorMessage)
        stop(errorMessage)
      }
      
      logger::log_debug('Old company Id is: {oldCompanyId}')
      
      findOldCompanyQuery <- glue::glue('
        {{
          "_id": {{
            "$oid": "{oldCompanyId}"
          }} 
        }}
      ')

      tryCatch({
        private$.context$replace(query = findOldCompanyQuery, update = newCompanyDetails)
      },
      error = function(errorMessage) {
        logger::log_error(errorMessage)
        stop(errorMessage)
      })
    },
    
    #' @description Deletes an existing Company record.
    #' @param companyName Company name string.
    DeleteCompany = function(companyName) 
    {
      query <- glue::glue('{{"name": "{companyName}"}}')
      tryCatch({
        private$.context$remove(query = query)
      },
      error = function(errorMessage) {
        logger::log_error(errorMessage)
        stop(errorMessage)
      })
    }
  )
)
