library(testthat)
library(rBuildReleaseTest)

# Resolves environment issues when running devtools::check()
Sys.setenv(R_TESTS = "")

testthat::test_check("rBuildReleaseTest")
