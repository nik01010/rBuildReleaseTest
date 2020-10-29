# ApplicationDbContext ----------------------------------------------------
#' Base class for the application database context
#'
#' @return Object of type R6Class with methods for communication with the database.
#'
#' @examples
#' \dontrun{
#' mongoConnectionString = "mongodb+srv://admin:example"
#'
#' MongoDbContext <- ApplicationDbContext$new(
#'   connectionString = mongoConnectionString,
#'   database = "ExampleDatabase",
#'   collection = "ExampleCollection"
#' )
#' }
#'
#' @export
ApplicationDbContext <- R6::R6Class(
  classname = "ApplicationDbContext",
  public = list(
    #' @field DbConnection Database Connection.
    DbConnection = NA,
    
    #' @description Initialize a new ApplicationDbContext object.
    #' @param connectionString Connection string.
    #' @param database Database name.
    #' @param collection Collection name.
    #' @param verbose Verbose setting. Defaults to TRUE.
    #' @return A new ApplicationDbContext object.
    initialize = function(connectionString, database, collection, verbose = TRUE)
    {
      logger::log_info('Connecting to Database "{database}" in Collection "{collection}".')
      # TODO: Add validations to check Database and Collection are not empty 
      # and check they exist on the MongoDb server

      tryCatch(
        {
          self$DbConnection <- mongolite::mongo(
            collection = collection,
            db = database,
            url = connectionString,
            verbose = verbose
          )

          logger::log_info("Connection initialised successfully.")
        },
        error = function(errorMessage)
        {
          message <- glue::glue('Database connection failed with message: {errorMessage}')
          logger::log_error(message)
          stop(message)
        }
      )
    }
  )
)
