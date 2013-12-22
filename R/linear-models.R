# Import all of the control-TGA volumetric data for subcortical structures,
# and run the regression analyses one-by-one.
#
#_______________________________________________________________________________
# by Chris Watson, 2012-12-18
num.controls <- 49
num.tga <- 92

all.subs <- read.csv('all-subs.csv', header=TRUE)
all.subs$group <- c(vector(mode="numeric", length=num.controls),
  vector(mode="numeric", length=num.tga) + 1)

for (i in 2:15) {
  current.vol <- colnames(all.subs)[i]
  assign(paste("model.", current.vol, sep=""), lm(eval(parse(text=current.vol)) ~
    group + Age + Gender + Scanner + IntraCranialVol, data=all.subs))

  assign(paste("cook.", current.vol, sep=""), cooks.distance(eval(parse(text=paste("model.",
    current.vol, sep="")))))

  png(file=paste("outlier-tests/", current.vol, ".png", sep=""), bg="white")
  plot(eval(parse(text=paste("cook.", current.vol, sep=""))))
  dev.off()
}

# Do some cortical thickness stuff

all.lms <- function(thick.table) {
  models.list <- list()
  for (i in 6:39) {
    current.vol <- colnames(thick.table)[i]
    models.list[[i-5]] <- list()
    models.list[[i-5]] <- lm(eval(parse(text=current.vol))
      ~ Group + Age + Sex + Scanner, data=thick.table)
  }

  for (i in 1:34) {
    p <- summary(models.list[[i]])$coefficients[2, 4]
    if (p < 0.05) {
      cat(colnames(thick.table)[i+5], '\t')
      cat(p, '\n')
    }
  }
}
