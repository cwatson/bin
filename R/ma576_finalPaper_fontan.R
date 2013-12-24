# Read in all data from a csv file and do some volumetric analyses and plots.
#_______________________________________________________________________________
# by Chris Watson, 2013-02-22

library(Hmisc)
library(ppcor)
all.data <- read.csv('../data/fontan_med-history.csv', header=T)

ctrls <- seq(1, 48)
#pts <- seq(49, 177)
pts <- c(seq(49, 87), seq(89, 177)) # exclude subj. 88 for too many caths

#===============================================================================
# Perform Wilcoxon rank sum tests for some demographic var's
#===============================================================================
p.birthweight <- wilcox.test(all.data[ctrls, ]$birthwt, 
  all.data[pts, ]$birthwt)$p.value
p.gestage <- wilcox.test(all.data[ctrls, ]$gestage, 
  all.data[pts, ]$gestage)$p.value
p.age.mri <- wilcox.test(all.data[ctrls, ]$Age, 
  all.data[pts, ]$Age)$p.value
p.famclass16 <- wilcox.test(all.data[ctrls, ]$famclass16, 
  all.data[pts, ]$famclass16)$p.value

#===============================================================================
# Perform Fisher exact tests
#===============================================================================
# Test for diff's in Sex
control.male <- sum(all.data[ctrls, ]$Sex)
fontan.male <- sum(all.data[pts, ]$Sex)
sex <- data.frame(control=c(control.male, 48-control.male),
  fontan=c(fontan.male, 129-fontan.male))
row.names(sex) <- c("male", "female")
p.male <- fisher.test(sex)$p.value

# Test for diff's in ethnicity (white vs. non-white)
control.white <- sum(all.data[ctrls, ]$white)
fontan.white <- sum(all.data[pts, ]$white)
ethn <- data.frame(control=c(control.white, 48-control.white),
  fontan=c(fontan.white, 129-fontan.white))
row.names(ethn) <- c("white", "non-white")
p.white <- fisher.test(ethn)$p.value

# Test for diff's by scanner
control.3T <- sum(ifelse(all.data[ctrls, ]$Scanner==3.0, 1, 0))
fontan.3T <- sum(ifelse(all.data[pts, ]$Scanner==3.0, 1, 0))
scanner <- data.frame(control=c(control.3T, 48-control.3T), fontan=c(fontan.3T,
  129-fontan.3T))
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
# Separate the variables we are most interested in
# This corresponds to "seizure", "learndis", "opstotal", "cathstotal", "nyha",
# "famclass16"
#===============================================================================
vars <- c(10, 11, 12, 15, 16, 17)
all.vars <- cbind(all.data[vars])
kNumVars <- length(vars)

# Create data frame of just the SCGM structures
all.structs <- cbind(all.data[seq(18, 31)])
kNumStructs <- length(all.structs)

# Correlate all volumes with all 6 med. variables
#-------------------------------------------------
R <- rcorr(as.matrix(cbind(all.structs[pts, ], all.vars[pts, ])),
  type="spearman")
R.p <- rcorr(as.matrix(cbind(all.structs[pts, ], all.vars[pts, ])),
  type="pearson")
R.all <- R$r[1:14, 15:20]
P.all <- R$P[1:14, 15:20]
R.all.p <- R.p$r[1:14, 15:20]
P.all.p <- R.p$P[1:14, 15:20]

#ifelse(abs(R.all) > 0.3, 1, 0)
#ifelse(abs(P.all) < 0.001, 1, 0)

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
dev.new()
med.means <- by(all.structs[pts, struct.ind], all.data[pts, med.var], mean)
plot(med.means, type="o", axes=F, ann=F)
axis(1, at=sort(unique(all.data[med.var])[, 1]))
axis(2, las=1, at=round(med.means))
box()
title(xlab=med.var)
title(ylab="Volume (mm^3)")
title(main=names(all.structs[struct.ind]), col.main="blue", font.main=2)

#===============================================================================
# Draw a boxplot with volume on the y-axis and med var on the x-axis
#===============================================================================
dev.new()
par(mfrow=c(3, 3))
for (i in 1:7) {
boxplot(all.data[pts, i+17] ~ all.data[pts, med.var], xlab=med.var,
  ylab=names(all.structs)[i])
}
dev.new()
par(mfrow=c(3, 3))
for (i in 8:14) {
boxplot(all.data[pts, i+17] ~ all.data[pts, med.var], xlab=med.var,
  ylab=names(all.structs)[i])
}


#===============================================================================
# Do a simple linear model with struct.ind against GROUP, learndis, or nyha
#===============================================================================
p.lm <- vector()
p.lm.learndis <- vector()
p.lm.nyha <- vector()
p.lm.cathstotal <- vector()
p.lm.opstotal <- vector()
for (i in 1:kNumStructs) {
  current.vol <- colnames(all.structs)[i]
  assign(paste("lm.", current.vol, sep=""), lm(eval(parse(text=current.vol)) ~
    Age + Sex + IntraCranialVol + as.factor(Scanner) + GROUP, data=all.data))
  p.lm[i] <- eval(parse(text=paste("summary(lm.", current.vol,
    ")$coefficients[6,4]", sep="")))

  assign(paste("lm.", current.vol, ".learndis", sep=""),
    lm(eval(parse(text=current.vol)) ~ Age + Sex + IntraCranialVol +
    as.factor(Scanner) + learndis, data=all.data[pts, ]))
  p.lm.learndis[i] <- eval(parse(text=paste("summary(lm.", current.vol,
    ".learndis)$coefficients[6,4]", sep="")))

  assign(paste("lm.", current.vol, ".nyha", sep=""),
    lm(eval(parse(text=current.vol)) ~ Age + Sex + IntraCranialVol +
    as.factor(Scanner) + nyha, data=all.data[pts, ]))
  p.lm.nyha[i] <- eval(parse(text=paste("summary(lm.", current.vol,
    ".nyha)$coefficients[6,4]", sep="")))

  assign(paste("lm.", current.vol, ".cathstotal", sep=""),
    lm(eval(parse(text=current.vol)) ~ Age + Sex + IntraCranialVol +
    as.factor(Scanner) + cathstotal, data=all.data[pts, ]))
  p.lm.cathstotal[i] <- eval(parse(text=paste("summary(lm.", current.vol,
    ".cathstotal)$coefficients[6,4]", sep="")))

  assign(paste("lm.", current.vol, ".opstotal", sep=""),
    lm(eval(parse(text=current.vol)) ~ Age + Sex + IntraCranialVol +
    as.factor(Scanner) + opstotal, data=all.data[pts, ]))
  p.lm.opstotal[i] <- eval(parse(text=paste("summary(lm.", current.vol,
    ".opstotal)$coefficients[6,4]", sep="")))
}

lm.L.Hippocampus.seizure <- lm(L.Hippocampus ~ Age + Sex + IntraCranialVol +
  Scanner + seizure, data=all.data[pts, ])
lm.R.Hippocampus.seizure <- lm(R.Hippocampus ~ Age + Sex + IntraCranialVol +
  Scanner + seizure, data=all.data[pts, ])

p.lm.adjusted <- data.frame(p.vals=p.adjust(p.lm, method="fdr"))
row.names(p.lm.adjusted) <- names(all.structs)
p.lm.learndis.adjusted <- data.frame(p.vals=p.adjust(p.lm.learndis, method="fdr"))
row.names(p.lm.learndis.adjusted) <- names(all.structs)
p.lm.nyha.adjusted <- data.frame(p.vals=p.adjust(p.lm.nyha, method="fdr"))
row.names(p.lm.nyha.adjusted) <- names(all.structs)
p.lm.cathstotal.adjusted <- data.frame(p.vals=p.adjust(p.lm.cathstotal, 
  method="fdr"))
row.names(p.lm.cathstotal.adjusted) <- names(all.structs)
p.lm.opstotal.adjusted <- data.frame(p.vals=p.adjust(p.lm.opstotal, 
  method="fdr"))
row.names(p.lm.opstotal.adjusted) <- names(all.structs)

#===============================================================================
# Draw a scatterplot with a LOESS smoothed line for "cathstotal" and "opstotal"
#===============================================================================
dev.new()
scatter.smooth(all.data[pts, ]$R.Caudate ~ all.data[pts, ]$cathstotal,
  xlab="Total # of caths", ylab="R Caudate volume (mm^3)")

dev.new()
scatter.smooth(all.data[pts, ]$L.Caudate ~ all.data[pts, ]$cathstotal,
  xlab="Total # of caths", ylab="L Caudate volume (mm^3)")

dev.new()
scatter.smooth(all.data[-57, ]$R.Pallidum ~ all.data[-57, ]$opstotal, 
  xlab="Total # of operations", ylab="R Pallidum volume (mm^3)")

#===============================================================================
# Linear model with structure volume as response variable, and Age, Sex,
# Scanner, and ICV as predictors; additionally include cathstotal
# Exclude subject 88 as an outlier
#===============================================================================
mod.R.caudate.caths <- lm(R.Caudate ~ Age + Sex + Scanner + IntraCranialVol +
  cathstotal, data=all.data[-88, ])
mod.L.caudate.caths <- lm(L.Caudate ~ Age + Sex + Scanner + IntraCranialVol +
  cathstotal, data=all.data[-88, ])
mod.L.pallidum.caths <- lm(L.Pallidum ~ Age + Sex + Scanner + IntraCranialVol +
  cathstotal, data=all.data[-88, ])

# Linear model w/ opstotal as a predictor; exclude subj. 57
mod.R.pallidum.ops <- lm(R.Pallidum ~ Age + Sex + Scanner + IntraCranialVol +
  opstotal, data=all.data[-57, ])

# Linear model w/ seizure as a predictor; exclude subj. 153 and 157
mod.R.hipp.seizures <- lm(R.Hippocampus ~ Age + Sex + Scanner + IntraCranialVol
  + seizure, data=all.data[c(-153, -157), ])

#===============================================================================
# Partial correlations of volumes, controlling for Age, Sex, Scanner, ICV
#===============================================================================
pcor.r.caudate.caths <- pcor.test(all.data$R.Caudate[c(seq(49, 87), 
  seq(89, 177))], all.data$cathstotal[c(seq(49, 87), seq(89, 177))], 
  all.data[c(3, 4, 5, 40)][c(seq(49, 87), seq(89, 177)), ])
pcor.all <- pcor(as.matrix(cbind(all.structs[pts, ], all.vars[pts, ])), 
  method="spearman")

# Remove NA values
no.na <- all.vars
no.na[is.na(no.na)] <- 0

pcor.no.na <- pcor(as.matrix(cbind(all.structs[pts, ], no.na[pts, ])), 
  method="spearman")
pcor.no.na.all <- pcor.no.na$estimate[1:14, 15:20]
