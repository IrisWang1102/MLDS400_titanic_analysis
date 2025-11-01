# install_packages.R
options(repos = c(CRAN = "https://cloud.r-project.org"))

packages <- c(
  "tidyverse",
  "caret",
  "readr"
)

install_if_missing <- function(pkg) {
  if (!require(pkg, character.only = TRUE)) {
    install.packages(pkg, dependencies = TRUE)
  }
}

invisible(lapply(packages, install_if_missing))

cat("All required R packages installed successfully\n")
