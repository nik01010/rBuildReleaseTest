options(stringsAsFactors = FALSE)

context("ApplicationDbContext")

test_that("ApplicationDbContext_ShouldCreateConnection_WhenCalledWithValidSettings", {
  # Arrange
  testConnectionString <- Sys.getenv("MONGO_CS_UNIT")
  testDatabase <- "IntegrationTest"
  testCollection <- "Companies"
  expectedClassName <- "ApplicationDbContext"
  expectedType <- "environment"
  expectedDbConnectionClassName <- "mongo"
  
  # Act
  result <- rBuildReleaseTest::ApplicationDbContext$new(
    connectionString = testConnectionString,
    database = testDatabase,
    collection = testCollection,
    verbose = FALSE
  )
  
  # Assert
  expect_s3_class(result, expectedClassName)
  expect_type(result, expectedType)
  expect_s3_class(result$DbConnection, expectedDbConnectionClassName)
  expect_type(result$DbConnection, expectedType)
})

test_that("ApplicationDbContext_ShouldThrowError_IfCalledWithInvalidConnectionString", {
  # Arrange
  invalidConnectionString <- "http://incorrect.mongo.com/1234"
  testDatabase <- "IntegrationTest"
  testCollection <- "Companies"
  expectedErrorMessagePattern <- "Database connection failed with message*"
  
  # Act
  result <- expect_error(
    rBuildReleaseTest::ApplicationDbContext$new(
      connectionString = invalidConnectionString,
      database = testDatabase,
      collection = testCollection,
      verbose = FALSE
    )
  )

  # Assert
  expect_s3_class(result, "error")
  errorMessageIsCorrect <- grepl(pattern = expectedErrorMessagePattern, x = result$message)
  expect_true(errorMessageIsCorrect)
})
