
# rBuildReleaseTest
Proof of Concept R Package to explore MongoDb, DevOps and best practice.

<!-- badges: start -->
[![Travis build status](https://travis-ci.org/nik01010/rBuildReleaseTest.svg?branch=develop)](https://travis-ci.org/nik01010/rBuildReleaseTest)
[![R build status](https://github.com/nik01010/rBuildReleaseTest/workflows/R-CMD-check/badge.svg)](https://github.com/nik01010/rBuildReleaseTest/actions)
[![Codecov test coverage](https://codecov.io/gh/nik01010/rBuildReleaseTest/branch/develop/graph/badge.svg)](https://codecov.io/gh/nik01010/rBuildReleaseTest?branch=develop)
[![stability-experimental](https://img.shields.io/badge/stability-experimental-orange.svg)](https://github.com/emersion/stability-badges#experimental)
<!-- badges: end -->

![Package structure](Helpers/Images/Package.png)

## Aims
This PoC package is used to explore:
- Creating a low-level Service layer of code for interacting with a MongoDb database.
- Encapsulating the Service queries in an R6 class.
- Using a database context class with support for basic dependency injection.
- Scripting unit tests for basic functions and integration-style unit tests for the Service database queries.
- Adding lint rules and integrating them within a test.
- Using environment variables for greater flexibility and securing connection strings.
- Creating a basic CI/CD pipeline to build and test the package, in TravisCI and Jenkins.
- Producing code coverage reports and linking them to a build.

## How to use
```R
# Install package
devtools::install_github(repo = "nik01010/rBuildReleaseTest", ref = "develop")

# Load package
library(rBuildReleaseTest)

# Set up logger
rBuildReleaseTest::InitialiseLogger()

# Get MongoDB connection string from environment variables
# See section in this ReadMe below for how to configure this
mongoConnectionString <- Sys.getenv("MONGO_CS_DEV")

# Initialise a new database context
companiesContext <- rBuildReleaseTest::ApplicationDbContext$new(
  connectionString = mongoConnectionString,
  database = "sample_training",
  collection = "companies"
)

# Initialise a new JSON schema validator for the companies collection
companiesSchemaValidator <- rBuildReleaseTest::CompaniesSchemaValidator()

# Initialise a new database query service
companiesService <- rBuildReleaseTest::CompaniesService$new(
  dbContext = companiesContext,
  schemaValidator = companiesSchemaValidator
)

# Example queries
count <- companiesService$getCompaniesCount()

allCompanies <- companiesService$getCompanies()

companyFacebook <- companiesService$getCompany(companyName = "Facebook")
companyNokia <- companiesService$getCompany(companyName = "Nokia")

companyNokiaId <- companiesService$getCompanyId(companyName = "Nokia")

numberOfCompaniesPerYear <- companiesService$getNumberOfCompaniesFoundedPerYear()

oldestCompanies <- companiesService$getOldestCompanies(limit = 25)

newCompany <- '{
  "name": "TestCompany1",
  "founded_year": 2019
}'
companiesService$createCompany(companyDetails = newCompany)

newCompanyEdited <- '{
  "name": "TestCompany1",
  "founded_year": 2020
}'
companiesService$editCompany(companyName = "TestCompany1", newCompanyDetails = newCompanyEdited)

companiesService$deleteCompany(companyName = "TestCompany1")

# Cleanup
rm(companiesContext)
rm(companiesService)

```

## Set up environment variables
This package depends on specific environment variables being present. Below are basic instructions for setting up the variables.
#### On local Windows machine:
- Ensure there is a .Renviron file in the User's Home directory (e.g. C:\Users\YourUsername\Documents).
- Add the below connection string variables in the .Renviron file. These will allow the package to connect to different MongoDb databases that have been configured, under different scenarios such as running production code or running tests. The Local and Unit Test connections are pointing to a localhost instance of MongoDb, which must already be installed on the machine running the code.
```R
MONGO_CS_LOCAL = "mongodb://127.0.0.1:27017/"
MONGO_CS_UNIT = "mongodb://127.0.0.1:27017/"
MONGO_CS_DEV = "mongodb+srv://YourMongoAtlasConnectionString"
```

#### On TravisCI:
- Go to the required repo's Settings page, and find the Environment Variables section.
- Add the below environment variable (encrypted if required), which will enable unit tests to be run against a dummy database as part of a build.

| Variable      | Value                      |
| ------------- |----------------------------|
| MONGO_CS_UNIT | mongodb://127.0.0.1:27017/ |

- The .travis.yml file in this repository enables the MongoDb service for each build, and will run on the standard localhost address used above.

#### On Jenkins:
- Go to the required Node's Configure settings page, and create the below environment variables. The R_LIBS variable is used by the R CMD CHECK process, although this may vary for users with different configurations or operating systems.

| Variable      | Value                      |
| ------------- |----------------------------|
| MONGO_CS_UNIT | mongodb://127.0.0.1:27017/ |
| R_LIBS        | C:/Users/YourUserName/Documents/R/win-library/YourRVersionNumber |
