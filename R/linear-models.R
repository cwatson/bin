# Import all of the control-TGA volumetric data for subcortical structures,
# and run the regression analyses one-by-one.
#
#_______________________________________________________________________________
# by Chris Watson, 2012-12-18
kNumControls <- 49
kNumTGA <- 92

all.subs <- read.csv('all-subs.csv', header=TRUE)
all.subs$group <- c(rep(0, kNumControls), rep(1, kNumTGA))

all.subs.lm <- lapply(all.subs[, 2:15], function(x)
  lm(x ~ group + Age + Gender + Scanner + IntraCranialVol, data=all.subs)
all.subs.cook <- lapply(all.subs.lm, cooks.distance)

for (i in 2:15) {
  png(file=paste("outlier-tests/", names(all.subs.lm)[i], ".png", sep=""),
    bg="white")
  plot(all.subs.cook[[i]], ylab=names(all.subs.cook)[i], xlab='Subject')
  dev.off()
}

# Do some cortical thickness stuff
all.lms <- function(thick.table) {
  models.list <- lapply(thick.table, function(x)
    lm(x ~ Group + Age + Sex + Scanner, data=thick.table))
  p <- lapply(models.list, function(x) summary(x)$coefficients[2, 4])
}
