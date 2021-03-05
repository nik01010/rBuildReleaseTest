options(stringsAsFactors = FALSE)

context("CompaniesService")

mongoConnectionString <- Sys.getenv("MONGO_CS_UNIT")
testContext <- rBuildReleaseTest::ApplicationDbContext$new(
  connectionString = mongoConnectionString,
  database = "IntegrationTest",
  collection = "Companies",
  verbose = FALSE
)

companiesSchemaValidator <- rBuildReleaseTest::CompaniesSchemaValidator()

testCompaniesService <- rBuildReleaseTest::CompaniesService$new(
  dbContext = testContext,
  schemaValidator = companiesSchemaValidator
)

test_that("GetCompaniesCount_ShouldReturnCorrectCount_WhenCalled", {
  # Arrange
  testContext$DbConnection$drop()
  companies <- data.frame(
    name = c(letters[1:10]),
    value = c(1:10)
  )
  testContext$DbConnection$insert(data = companies)
  expectedCount <- nrow(companies)

  # Act
  result <- testCompaniesService$GetCompaniesCount()

  # Assert
  expect_equal(expectedCount, result)
})

test_that("GetCompanies_ShouldReturnCorrectListOfCompanies_WhenCalled", {
  # Arrange
  testContext$DbConnection$drop()
  companies <- data.frame(
    name = c(letters[1:10]),
    value = c(1:10)
  )
  testContext$DbConnection$insert(data = companies)

  # Act
  result <- testCompaniesService$GetCompanies()

  # Assert
  expect_equal(companies, result)
})

test_that("GetCompany_ShouldReturnCorrectCompany_IfCalledWithValidName", {
  # Arrange
  testContext$DbConnection$drop()
  companies <- data.frame(
    name = c("Company1", "Company2", "Company3"),
    address = c("Address1", "Address2", "Address3"),
    value = c(1, 2, 3)
  )
  testContext$DbConnection$insert(data = companies)
  companyName <- "Company2"
  expectedCompany <- companies %>%
    dplyr::filter(name == companyName)

  # Act
  result <- testCompaniesService$GetCompany(companyName = companyName)

  # Assert
  expect_equal(expectedCompany, result)
})

test_that("GetCompanyId_ShouldReturnId_IfCalledWithValidName", {
  # Arrange
  testContext$DbConnection$drop()
  companyToFind <- "Company2"
  companies <- data.frame(
    name = c("Company1", companyToFind, "Company3"),
    address = c("Address1", "Address2", "Address3"),
    value = c(1, 2, 3)
  )
  testContext$DbConnection$insert(data = companies)
  
  # Act
  result <- testCompaniesService$GetCompanyId(companyName = companyToFind)
  
  # Assert
  expect_true(!is.null(result))
})

test_that("GetOldestCompanies_ShouldReturnCorrectList_IfCalledWithValidLimit", {
  # Arrange
  testContext$DbConnection$drop()
  companies <- data.frame(
    name = c("Company1", "Company2", "Company3", "Company4"),
    address = c("Address1", "Address2", "Address3", "Address4"),
    founded_year = c(2005, 2004, 1999, 2019)
  )
  testContext$DbConnection$insert(data = companies)
  limit <- 2
  expectedCompanies <- companies %>%
    dplyr::arrange(founded_year) %>%
    dplyr::slice(1:limit)

  # Act
  result <- testCompaniesService$GetOldestCompanies(limit = limit)

  # Assert
  expect_equal(expectedCompanies, result)
})

test_that("GetOldestCompanies_ShouldFilterOutNulls_WhenCalled", {
  # Arrange
  testContext$DbConnection$drop()
  companies <- data.frame(
    name = c("Company1", "Company2", "Company3", "Company4"),
    address = c("Address1", "Address2", "Address3", "Address4"),
    founded_year = c(NA, NA, NA, NA)
  )
  limit <- nrow(companies)
  testContext$DbConnection$insert(data = companies)
  expectedCompanies <- data.frame()

  # Act
  result <- testCompaniesService$GetOldestCompanies(limit = limit)

  # Assert
  expect_equal(expectedCompanies, result)
})

test_that("GetNumberOfCompaniesFoundedPerYear_ShouldReturnCorrectCounts_WhenCalled", {
  # Arrange
  testContext$DbConnection$drop()
  companies <- data.frame(
    name = c("Company2007A", "Company2007B", "Company2009A", "Company2009B", "Company2009C"),
    founded_year = c(2007, 2007, 2009, 2009, 2009),
    another_value = c(1, 2, 3, 4, 5)
  )
  testContext$DbConnection$insert(data = companies)
  expectedCounts <- companies %>%
    dplyr::group_by(founded_year) %>%
    dplyr::count(name = "count") %>%
    dplyr::ungroup() %>%
    as.data.frame()
  
  # Act
  result <- testCompaniesService$GetNumberOfCompaniesFoundedPerYear()
  
  # Assert
  expect_equal(expectedCounts, result)
})

test_that("CreateCompany_ShouldCreateNewCompany_WhenCalledWithValidJson", {
  # Arrange
  testContext$DbConnection$drop()
  companyName <- "TestCompany"
  companyFoundedYear <- 2000
  newCompany <- glue::glue('{{
    "name": "{companyName}",
    "founded_year": {companyFoundedYear}
  }}')
  expectedCompanies <- data.frame(
    name = companyName,
    founded_year = companyFoundedYear
  )
  
  # Act
  result <- testCompaniesService$CreateCompany(companyDetails = newCompany)
  
  # Assert
  expect_equal(nrow(expectedCompanies), result$nInserted)
  expect_equal(list(), result$writeErrors)
  actualCompanies <- testCompaniesService$GetCompanies()
  expect_equal(expectedCompanies, actualCompanies)
})

test_that("CreateCompany_ShouldThrowError_IfCalledWithInvalidJsonKeys", {
  # Arrange
  testContext$DbConnection$drop()
  companyName <- "TestCompany"
  companyFoundedYear <- 2000
  invalidCompany <- glue::glue('{{
    "Name": "{companyName}",
    "FoundedYear": {companyFoundedYear}
  }}')
  
  # Act
  result <- expect_error(testCompaniesService$CreateCompany(companyDetails = invalidCompany))

  # Assert
  expect_s3_class(result, "error")
  expect_equal("New company is not valid.", result$message)
  actualCompanies <- testCompaniesService$GetCompanies()
  expect_equal(0, nrow(actualCompanies))
})

test_that("CreateCompany_ShouldThrowError_IfCompanyAlreadyExists", {
  # Arrange
  testContext$DbConnection$drop()
  companyName <- "TestCompany"
  companyFoundedYear <- 2000
  company <- glue::glue('{{
    "name": "{companyName}",
    "founded_year": {companyFoundedYear}
  }}')
  testCompaniesService$CreateCompany(companyDetails = company)
  duplicateCompany <- company
  expectedErrorMessage <- glue::glue("Company {companyName} already exists.")
  
  # Act
  result <- expect_error(testCompaniesService$CreateCompany(companyDetails = duplicateCompany))
  
  # Assert
  expect_s3_class(result, "error")
  expect_equal(expectedErrorMessage, result$message)
  actualCompanies <- testCompaniesService$GetCompanies()
  expect_equal(1, nrow(actualCompanies))
})

test_that("EditCompany_ShouldUpdateCompanyDetails_IfCalledWithCorrectDetails", {
  # Arrange
  testContext$DbConnection$drop()
  companyName <- "CompanyToEdit"
  oldCompanyFoundedYear <- 2019
  oldCompanyDetails <- glue::glue('{{
    "name": "{companyName}",
    "founded_year": {oldCompanyFoundedYear}
  }}')
  testCompaniesService$CreateCompany(companyDetails = oldCompanyDetails)
  
  newCompanyFoundedYear <- 2020
  newCompanyDetails <- glue::glue('{{
    "name": "{companyName}",
    "founded_year": {newCompanyFoundedYear}
  }}')
  
  expectedCompany <- data.frame(
    name = companyName,
    founded_year = newCompanyFoundedYear
  )
  
  # Act
  result <- testCompaniesService$EditCompany(companyName = companyName, newCompanyDetails = newCompanyDetails)
  
  # Assert
  expect_equal(nrow(expectedCompany), result$modifiedCount)
  expect_equal(nrow(expectedCompany), result$matchedCount)
  expect_equal(0, result$upsertedCount)
  actualCompany <- testCompaniesService$GetCompany(companyName = companyName)
  expect_equal(expectedCompany, actualCompany)
})

test_that("EditCompany_ShouldThrowError_IfCalledForInvalidCompany", {
  # Arrange
  testContext$DbConnection$drop()
  invalidCompany <- "TestCompany"
  expectedError <- glue::glue('Company with name {invalidCompany} does not exist.')
  
  # Act
  result <- expect_error(
    testCompaniesService$EditCompany(
      companyName = invalidCompany, 
      newCompanyDetails = "{}"
    )
  )
  
  # Assert
  expect_s3_class(result, "error")
  expect_equal(expectedError, result$message)
})

test_that("EditCompany_ShouldThrowError_IfMultipleCompaniesExistWithSameName", {
  # Arrange
  testContext$DbConnection$drop()
  duplicateCompanyName <- "Company1"
  companies <- data.frame(
    name = c(duplicateCompanyName, duplicateCompanyName),
    founded_year = c(2018, 2019)
  )
  testContext$DbConnection$insert(data = companies)
  expectedError <- glue::glue('Multiple companies exist with the name {duplicateCompanyName}.')
  
  # Act
  result <- expect_error(
    testCompaniesService$EditCompany(
      companyName = duplicateCompanyName, 
      newCompanyDetails = "{}"
    )
  )
  
  # Assert
  expect_s3_class(result, "error")
  expect_equal(expectedError, result$message)
})

test_that("DeleteCompany_ShouldRemoveRecord_IfCalledForExistingCompany", {
  # Arrange
  testContext$DbConnection$drop()
  companies <- data.frame(
    name = c("Company1", "Company2", "Company3"),
    founded_year = c(2017, 2018, 2019)
  )
  testContext$DbConnection$insert(data = companies)
  companyToDelete <- "Company2"
  expectedCompanies <- companies %>%
    dplyr::filter(name != companyToDelete)

  # Act
  result <- testCompaniesService$DeleteCompany(companyName = companyToDelete)

  # Assert
  actualCompanies <- testCompaniesService$GetCompanies()
  expect_equal(expectedCompanies, actualCompanies)
})

# Teardown
rm(testContext)
rm(testCompaniesService)
