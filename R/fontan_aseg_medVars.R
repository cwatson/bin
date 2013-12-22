# Read in all data from a csv file and do some volumetric analyses and plots
# for the Fontan study.
#
#_______________________________________________________________________________
# by Chris Watson, 2013-02-22

library(Hmisc)
all.data <- read.csv('/home/cwatson/Dropbox/fontan_med-history.csv', header=T)
control.df <- subset(all.data, GROUP=='CONTROL')
fontan.df <- subset(all.data, GROUP=='FONTAN')

kNumControls <- dim(control.df)[1]
kNumFontans <- dim(fontan.df)[1]
#pts <- seq(49,177)

#===============================================================================
# Perform Wilcoxon rank sum tests for some demographic var's
#===============================================================================
p.birthweight <- wilcox.test(control.df$birthwt, fontan.df$birthwt)$p.value
p.gestage <- wilcox.test(control.df$gestage, fontan.df$gestage)$p.value
p.age.mri <- wilcox.test(control.df$Age, fontan.df$Age)$p.value
p.famclass16 <- wilcox.test(control.df$famclass16, fontan.df$famclass16)$p.value

#===============================================================================
# Perform Fisher exact tests for % Male and % White, and % on the 3T
#===============================================================================
control.male <- sum(control.df$Sex)
fontan.male <- sum(fontan.df$Sex)
sex <- data.frame(control=c(control.male, kNumControls-control.male),
  fontan=c(fontan.male, kNumFontans-fontan.male))
row.names(sex) <- c("male", "female")
p.male <- fisher.test(sex)$p.value

# Test for diff's in ethnicity (white vs. non-white)
control.white <- sum(control.df$white)
fontan.white <- sum(fontan.df$white)
ethn <- data.frame(control=c(control.white, kNumControls-control.white),
  fontan=c(fontan.white, kNumFontans-fontan.white))
row.names(ethn) <- c("white", "non-white")
p.white <- fisher.test(ethn)$p.value

# Test for diff's by scanner
control.3T <- sum(ifelse(control.df$Scanner==3.0, 1, 0))
fontan.3T <- sum(ifelse(fontan.df$Scanner==3.0, 1, 0))
scanner <- data.frame(control=c(control.3T, kNumControls-control.3T),
  fontan=c(fontan.3T, kNumFontans-fontan.3T))
row.names(scanner) <- c("3T", "1.5T")
p.3T <- fisher.test(scanner)$p.value

#===============================================================================
# Get median & IQR for some var's, and percent for others
#===============================================================================
median.birthweight <- by(all.data$birthwt, all.data$GROUP, median, na.rm=T)
IQR.birthweight <- by(all.data$birthwt, all.data$GROUP, IQR, na.rm=T)

median.gestage <- by(all.data$gestage, all.data$GROUP, median, na.rm=T)
IQR.gestage <- by(all.data$gestage, all.data$GROUP, IQR, na.rm=T)

median.age.mri <- by(all.data$Age, all.data$GROUP, median, na.rm=T)
IQR.age.mri <- by(all.data$Age, all.data$GROUP, IQR, na.rm=T)

median.famclass16 <- by(all.data$famclass16, all.data$GROUP, median, na.rm=T)
IQR.famclass16 <- by(all.data$famclass16, all.data$GROUP, IQR, na.rm=T)


#===============================================================================
# This corresponds to "seizure", "learndis", "opstotal", "cathstotal", "nyha",
# "famclass16"
vars <- c(10, 11, 12, 15, 16, 17)
all.vars <- cbind(fontan.df[vars])
kNumVars <- length(vars)

# Create data frame of just the SCGM structures
all.structs <- cbind(all.data[seq.int(18, 31)])
fontan.structs <- cbind(fontan.df[seq.int(18, 31)])
kNumStructs <- length(fontan.structs)

# Correlate all volumes with all 6 med. variables
R <- rcorr(as.matrix(cbind(fontan.structs, all.vars)), type="spearman")
R.p <- rcorr(as.matrix(cbind(fontan.structs, all.vars)), type="pearson")
R.all <- R$r[1:14, 15:20]
P.all <- R$P[1:14, 15:20]
R.all.p <- R.p$r[1:14, 15:20]
P.all.p <- R.p$P[1:14, 15:20]


# Adjust p-values using the Benjamini-Hochberg method
P.all.adjusted <- matrix(p.adjust(P.all, method="fdr"), nrow=kNumStructs,
  ncol=kNumVars)
P.all.adjusted.p <- matrix(p.adjust(P.all.p, method="fdr"), nrow=kNumStructs,
  ncol=kNumVars)

P.all.adjusted <- data.frame(P.all.adjusted)
names(P.all.adjusted) <- names(all.vars)
row.names(P.all.adjusted) <- row.names(P.all)
P.all.adjusted.p <- data.frame(P.all.adjusted.p)
names(P.all.adjusted.p) <- names(all.vars)
row.names(P.all.adjusted.p) <- row.names(P.all)


#===============================================================================
# Now get the means for each level of the med var, and plot
#===============================================================================
#med.var <- "nyha"
#struct.ind <- 1    # Change this for diff. structures
#q <- by(fontan.structs[struct.ind], fontan.df[med.var], colMeans)
dev.new()
q <- by(fontan.structs[, struct.ind], fontan.df[, med.var], mean)
plot(q, type="o", axes=F, ann=F)
axis(1, at=sort(unique(fontan.df[med.var])[, 1]))
axis(2, las=1, at=round(q))
box()
title(xlab=med.var)
title(ylab="Volume (mm^3)")
title(main=names(fontan.structs[struct.ind]), col.main="blue", font.main=2)

# Draw a boxplot with volume on the y-axis and med var on the x-axis
#-------------------------------------------------------------------------------
dev.new()
par(mfrow=c(3,3))
for (i in 1:7) {
boxplot(fontan.df[, i+17] ~ fontan.df[, med.var], xlab=med.var,
  ylab=names(fontan.structs)[i])
}
dev.new()
par(mfrow=c(3,3))
for (i in 8:14) {
boxplot(fontan.df[, i+17] ~ fontan.df[, med.var], xlab=med.var,
  ylab=names(fontan.structs)[i])
}

# Do a simple linear model with struct.ind against GROUP
all.structs.lm <- lapply(all.structs, function(x)
  lm(x ~ Age + Sex + IntraCranialVol + as.factor(Scanner) + GROUP,
  data=all.data))
p.lm <- lapply(all.structs.lm, function(x) summary(x)$coefficients[6, 4])
p.lm.adjusted <- data.frame(p.vals=p.adjust(p.lm, method="fdr"))
