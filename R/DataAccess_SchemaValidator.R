# Companies Schema Validator ----------------------------------------------
#' Creates a JSON schema validator for Companies data
#'
#' @return jsonvalidator object
#' @examples
#' CompaniesSchemaValidator()
#' @export
CompaniesSchemaValidator <- function()
{
  companiesSchema <- '{
    "$schema": "http://json-schema.org/draft-04/schema#",
    "title": "Company",
    "description": "Company record",
    "type": "object",
    "properties": {
        "name": {
            "description": "Company name",
            "type": "string"
        },
        "founded_year": {
            "type": "number",
            "minimum": 0,
            "exclusiveMinimum": true
        }
    },
    "required": [
        "name", 
        "founded_year"
    ]
  }'
  companiesSchemaValidator <- jsonvalidate::json_validator(schema = companiesSchema)
  
  return(companiesSchemaValidator)
}
