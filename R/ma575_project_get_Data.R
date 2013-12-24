# Separates the Parkinson's Telemonitoring Data Set (from the UCI Machine
# Learning Repository) by subject, and gets only the baseline, 3-month, and
# 6-month measurements.
#
#_______________________________________________________________________________
# by Chris Watson,  2012-11-28

original.data <- read.csv("../../data/parkinsons_updrs.data", header=T)

# Variable transformations
#---------------------------------------
original.data$logNHR <- logb(original.data$NHR, 2)
original.data$logJitter.pctg <- logb(original.data$Jitter.pctg, 2)
original.data$logJitter.Abs <- logb(original.data$Jitter.Abs, 2)
original.data$logJitter.RAP <- logb(original.data$Jitter.RAP, 2)
original.data$logJitter.PPQ5 <- logb(original.data$Jitter.PPQ5, 2)
original.data$logJitter.DDP <- logb(original.data$Jitter.DDP, 2)

original.data$logShimmer <- logb(original.data$Shimmer, 2)
original.data$logShimmer.dB <- logb(original.data$Shimmer.dB, 2)
original.data$logShimmer.APQ3 <- logb(original.data$Shimmer.APQ3, 2)
original.data$logShimmer.APQ5 <- logb(original.data$Shimmer.APQ5, 2)
original.data$logShimmer.APQ11 <- logb(original.data$Shimmer.APQ11, 2)
original.data$logShimmer.DDA <- logb(original.data$Shimmer.DDA, 2)

#original.data$boxCox.total.UPDRS <- original.data$total.UPDRS^(2/3)

training.data <- subset(original.data, original.data$subject.num < 31)
testing.data <- subset(original.data, original.data$subject.num >= 31)

#===============================================================================
# FUNCTIONS
#===============================================================================

# Get individual subjects
SplitSubjs <- function(i) {
  subset(training.data, training.data$subject.num==i)
}

# Get min, max, median times
SplitTimes <- function(var.name, col, x, y, z) {
  subset(var.name, abs(var.name[, col] - x) <= 1 |
         abs(var.name[, col] - y) <= 1 |
         (var.name[, col] - signif(z,2) >= -3.5 & var.name[, col] -
         signif(z,2) <= 3.5))
}

#===============================================================================
# Loop through first 30 subjects
#===============================================================================
#all.subjects <- data.frame()
#for (i in 1:max(training.data$subject.num)) {
#  curr.var.name <- paste("subj", i, sep="")  # Create a varname for the subj
#  assign(curr.var.name, SplitSubjs(i))
#
#  # Get baseline, 3 month, & 6 month test times
#  #-------------------------------------
#  subj.test.time <- paste(curr.var.name, "$test.time", sep="")
#
#  baseline <- eval(parse(text=paste("min(", subj.test.time, ")", sep="")))
#  three.months <- eval(parse(text=paste("unique(", subj.test.time, 
#    "[", "which(abs(", subj.test.time, "- 90) == min(abs(", subj.test.time, 
#    "- 90)))])", sep="")))
#  six.months <- eval(parse(text=paste("max(", subj.test.time, ")", sep="")))
#
#  assign(paste(curr.var.name, "a", sep = ""),
#    SplitTimes(eval(parse(text=curr.var.name)), "test.time", baseline,
#    six.months, three.months))
#
#  # Mean of the UPDRS scores
#  #-------------------------------------
#  assign(paste(curr.var.name, "a.mean.total", sep=""),
#    eval(parse(text=paste("mean(", curr.var.name, "a$total.UPDRS", ")",
#      sep=""))))
#  assign(paste(curr.var.name, "a.mean.motor", sep=""),
#    eval(parse(text=paste("mean(", curr.var.name, "a$motor.UPDRS", ")",
#      sep=""))))
#
#  # Append data to the array for all subjects
#  #-------------------------------------
#  all.subjects <- rbind(all.subjects, eval(parse(text=paste(curr.var.name, 
#    "a", sep=""))))
#}

# Number of rows for each subject; check how many measurements
#a <- c()
#for (i in 1:max(training.data$subject.num)) {
#  a[[i]] <- eval(parse(text=paste("dim(subj", i, "a)[1]", sep="")))
#}

#rm(i, baseline, six.months, three.months, subj.test.time)
