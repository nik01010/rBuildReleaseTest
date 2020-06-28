context("Logger")

test_that("InitialiseLogger_ShouldSetupLogger_WhenCalled", {
  # Arrange
  testMessage <- "Logger Initialised."
  testLevel <- "INFO"
  testDate <- Sys.Date()
  testTime <- "[0-9]{2}\\:[0-9]{2}\\:[0-9]{2}"
  testNs <- "rBuildReleaseTest"
  testFunct <- "rBuildReleaseTest::InitialiseLogger"
  expectedLogPattern <- glue::glue(
    '^\\[{testLevel}\\] \\[{testDate} {testTime}\\] \\[{testNs}\\] \\[{testFunct}\\]\\: {testMessage}$'
  )
  
  consoleOutputConnection <- textConnection(object = "consoleOutput", open = "w", local = TRUE)
  sink(file = consoleOutputConnection, type = "output")
  
  # Act
  rBuildReleaseTest::InitialiseLogger()
  sink(file = NULL, type = "output")
  close(con = consoleOutputConnection)
  
  # Assert
  expect_equal(1, length(consoleOutput))
  logEntryIsCorrect <- grepl(pattern = expectedLogPattern, x = consoleOutput)
  expect_true(logEntryIsCorrect)
})
