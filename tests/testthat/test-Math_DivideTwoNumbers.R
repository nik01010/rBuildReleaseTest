testthat::context("divideTwoNumbers")

test_that("divideTwoNumers_ShouldReturnCorrectResult_IfCalledWithValidParameters", {
  # Arrange
  num <- 4
  den <- 2
  expectedResult <- num / den

  # Act
  result <- rBuildReleaseTest::divideTwoNumbers(numerator = num, denominator = den)

  # Assert
  expect_equal(expectedResult, result)
})
