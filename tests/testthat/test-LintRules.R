context("LintRules")

test_that("LintRules_ShouldPass_WhenRun", {
  # Arrange
  linterPath <- getwd()
  
  # Act / Assert
  lintr::expect_lint_free(path = linterPath, relative_path = FALSE)
})
