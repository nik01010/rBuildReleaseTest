# General -----------------------------------------------------------------
folderPath <- ".."
packageName <- "rBuildReleaseTest"
packagePath <- file.path(folderPath, packageName)
buildOutputPath <- "../Builds/rBuildReleaseTest"

# Create ------------------------------------------------------------------

# https://usethis.r-lib.org/
library(usethis)

create_package(packagePath)

proj_activate(packagePath)

use_mit_license("YOUR NAME HERE")

use_testthat()

use_package("lintr")
use_package("logging")
use_package("glue")
use_package("R6")
use_package("glue")
use_package("mongolite")
use_package("config")
# use_package("keyring")
use_package("dplyr")

# use_pipe(export = FALSE) # MANUAL IN R-PACKAGE FILE

# use_test("DivideTwoNumbersTests")

use_build_ignore(".lintr")
use_build_ignore("BuildHelpers")

use_news_md()

# SET UP VIGNETTES
# Requires Pandoc installation
# Requires rmarkdown package
usethis::use_vignette("rBuildReleaseTest-vignette")
# Will add VignetteBuilder: knitr at end of DESCRIPTION
# and update Depends section 

use_jenkins()

use_travis()

# devtools::use_build_ignore(c("release")) # TO IGNORE IN BUILD


# Build -------------------------------------------------------------------
library(devtools) # ALSO NEED RTools
# library(pkgbuild)
# library(roxygen2) # NOT NEEDED?

# Needs RTools
# devtools::find_rtools()
# Ensure to add RTools in PATH variable during install process
# Sys.getenv('PATH')

devtools::document()


# devtools::build_vignettes()

checkResult <- devtools::check(quiet = TRUE)
checkResult

# TODO: Create function for Build process ?
# TODO: Create log for build process ?
# TODO: Make check conditional ?
# TODO: Add conditional check here to stop if any errors
length(checkResult$errors)

testResult <- devtools::test() # Part of check above
# HOW TO CHECK RESULT
# str(testResult)
# testResult[[1]]$results[[1]]
### ???
# res <- testthat::test_package('RTest', reporter = c("check", "list"))
# ListReporter ???
~

# TODO: Investigate covr package !!!
# https://github.com/r-lib/covr
devtools::test_coverage()

# testthat::auto_test_package() !!!!! LIVE UNIT TESTING !!!


# devtools::build(
#   path = packagePath,
#   dest_path = buildOutputPath,
#   binary = TRUE
# )

# DO SOMETHING TO INCREMENT VERSION NUMBER !!!
devtools::build(
  pkg = packagePath,
  path = buildOutputPath,
  binary = TRUE
)

devtools::install()
