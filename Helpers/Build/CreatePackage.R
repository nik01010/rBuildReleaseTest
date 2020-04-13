# General -----------------------------------------------------------------
folderPath <- ".."
packageName <- "rBuildReleaseTest"
packagePath <- file.path(folderPath, packageName)
buildOutputPath <- "../Builds/rBuildReleaseTest"

# Create ------------------------------------------------------------------


# External Software Requirements:
# - Rtools
# - MikTex
# - Pandoc?

# https://usethis.r-lib.org/
library(usethis)

create_package(packagePath)

proj_activate(packagePath)

use_mit_license("YOUR NAME HERE")

use_testthat()


use_coverage()
# Creates codecov.yml file - need to manually change threshold
# Adds badge to ReadMe - need to manually change branch if needed
# Need to manually add below lines to .travis.yml file:
# after_success:
#   - Rscript -e 'covr::codecov()'

use_package("lintr")
use_package("logger")
use_package("glue")
use_package("R6")
use_package("glue")
use_package("mongolite")
use_package("jsonvalidate")
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
# SET UP PDFs
# Requires MikTex installation

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

# TODO: Create function for Build process ?
# TODO: Create log for build process ?
checkResult <- devtools::check(quiet = TRUE)
checkResult

testResult <- devtools::test() # Part of check above

# https://github.com/r-lib/covr
devtools::test_coverage()

# testthat::auto_test_package()

# devtools::build(
#   path = packagePath,
#   dest_path = buildOutputPath,
#   binary = TRUE
# )

# NEED TO INCREMENT VERSION NUMBER
devtools::build(
  pkg = packagePath,
  path = buildOutputPath,
  binary = TRUE
)

devtools::install()
