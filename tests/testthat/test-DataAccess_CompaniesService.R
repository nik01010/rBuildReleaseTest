options(stringsAsFactors = FALSE)

context("CompaniesService")

mongoConnectionString <- Sys.getenv("MONGO_CS_UNIT")
testContext <- rBuildReleaseTest::ApplicationDbContext$new(
  connectionString = mongoConnectionString,
  database = "IntegrationTest",
  collection = "Companies",
  verbose = FALSE
)

testCompaniesService <- rBuildReleaseTest::CompaniesService$new(dbContext = testContext)

test_that("GetCompaniesCount_ShouldReturnCorrectCount_WhenCalled", {
  # Arrange
  testContext$DbConnection$drop()
  companies <- data.frame(
    name = c(letters[1:10]),
    value = c(1:10)
  )
  testContext$DbConnection$insert(companies)
  expectedCount <- nrow(companies)

  # Act
  result <- testCompaniesService$getCompaniesCount()

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
  testContext$DbConnection$insert(companies)

  # Act
  result <- testCompaniesService$getCompanies()

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
  testContext$DbConnection$insert(companies)
  companyName <- "Company2"
  expectedCompany <- companies %>%
    dplyr::filter(name == companyName)

  # Act
  result <- testCompaniesService$getCompany(companyName = companyName)

  # Assert
  expect_equal(expectedCompany, result)
})

test_that("GetOldestCompanies_ShouldReturnCorrectList_IfCalledWithValidLimit", {
  # Arrange
  testContext$DbConnection$drop()
  companies <- data.frame(
    name = c("Company1", "Company2", "Company3", "Company4"),
    address = c("Address1", "Address2", "Address3", "Address4"),
    founded_year = c(2005, 2004, 1999, 2019)
  )
  testContext$DbConnection$insert(companies)
  limit <- 2
  expectedCompanies <- companies %>%
    dplyr::arrange(founded_year) %>%
    dplyr::slice(1:limit)

  # Act
  result <- testCompaniesService$getOldestCompanies(limit = limit)

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
  testContext$DbConnection$insert(companies)
  expectedCompanies <- data.frame()

  # Act
  result <- testCompaniesService$getOldestCompanies(limit = limit)

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
  testContext$DbConnection$insert(companies)
  expectedCounts <- companies %>%
    dplyr::group_by(founded_year) %>%
    dplyr::count(name = "count")
  
  # Act
  result <- testCompaniesService$getNumberOfCompaniesFoundedPerYear()
  
  # Assert
  expect_equal(expectedCounts, result)
})

# Teardown
rm(testContext)
rm(testCompaniesService)
