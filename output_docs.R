require(rmarkdown)
require(dplyr)
require(ggplot2)
require(knitr)

# Define a function to enumerate exercises
exercise_number <- 0
exercise <- function (txt) {
  exercise_number <<- exercise_number + 1
  cat(paste0("\n**Exercise ", exercise_number, ":** "), paste0("*", txt, "*\n"))
}

opts_chunk$set(results="markup")
maxprint <- getOption("max.print")
options(max.print = 50L)

# clean old files
clean_files <- list.files(c(".", "./pdf"), pattern = ".\\.html|.\\.pdf", 
                          full.names = TRUE)
dirs <- list.dirs(recursive = FALSE)
clean_dirs <- dirs[grep("_files|^\\./data$", dirs)]
unlink(c(clean_files, clean_dirs), recursive = TRUE)

# Create data sets
set.seed(42)
dat <- iris
dat$Sepal.Width[sample(nrow(dat), 5)] <- NA
setosa <- dat[dat$Species == "setosa",]
versicolor <- dat[dat$Species == "versicolor",]
virginica <- dat[dat$Species == "virginica",]
dir.create("data", showWarnings = FALSE)
write.csv(dat, "data/iris.csv", row.names=FALSE)
write.csv(setosa, "data/iris_setosa.csv", row.names=FALSE)
write.csv(versicolor, "data/iris_versicolor.csv", row.names=FALSE)
write.csv(virginica, "data/iris_virginica.csv", row.names=FALSE)
setwd("data")
zip("iris.zip", c("iris_setosa.csv", "iris_versicolor.csv", "iris_virginica.csv"))
setwd("..")

# Knit Rmd files to html
RmdDocs <- list.files(".", pattern="*\\.Rmd", full.names = TRUE)
files <- RmdDocs
files <- normalizePath(RmdDocs, winslash="/")
for (fname in files) {
  render(basename(fname))
}

# knit pdf
exercise_number <- 0
setwd("pdf")
render("Intro_R_ATeucher.Rmd")
setwd("..")

# Reset options and get rid of stuff
options(max.print = maxprint)
rm(list = ls())
