library("derfinder")
library("derfinderData")
library("GenomicRanges")
library("knitr")


dyn.load(paste("RPluMA", .Platform$dynlib.ext, sep=""))
source("RPluMA.R")

input <- function(inputfile) {
  parameters <<- read.table(inputfile, as.is=T);
  rownames(parameters) <<- parameters[,1];
    pfix = prefix()
  if (length(pfix) != 0) {
     pfix <<- paste(pfix, "/", sep="")
  }
}

run <- function() {}

output <- function(outputfile) {
	filteredCov <- readRDS(paste(pfix, parameters["filteredCov", 2], sep="/"))
	models <- readRDS(paste(pfix, parameters["models", 2], sep="/")) 

pheno <- subset(brainspanPheno, structure_acronym == "AMY")
####################################################################################
# ANALYZE RESULTS
dir.create("analysisResults")
originalWd <- getwd()
setwd(file.path(originalWd, "analysisResults"))
results <- analyzeChr(
    chr = "chr21", filteredCov$chr21, models,
    groupInfo = pheno$group, writeOutput = TRUE, cutoffFstat = 5e-02,
    nPermute = 20, seeds = 20140923 + seq_len(20), returnOutput = TRUE
)
setwd(originalWd)
#identical(length(results$fstats), sum(results$coveragePrep$position))
#sig <- as.logical(results$regions$regions$significant)
saveRDS(results, outputfile)#head(results$annotation)
####################################################################################
}
