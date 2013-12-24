source('ma575_project_get_Data.R')
attach(training.data)
#attach(original.data)

#===============================================================================
# Code for estimating total.UPDRS
#===============================================================================
mod0.total <- lm(total.UPDRS ~ subject.num + age + sex + test.time - 1)

# Variable selection
#---------------------------------------
total.forward <- step(mod0.total, scope=~NHR + HNR + RPDE + DFA + PPE +
  logJitter.pctg + logJitter.Abs + logJitter.RAP + logJitter.PPQ5 +
  logJitter.DDP + logShimmer + logShimmer.dB + logShimmer.APQ3 +
  logShimmer.APQ5 + logShimmer.APQ11 + logShimmer.DDA + subject.num + age + sex +
  test.time - 1, direction="forward")
 
# Subjects 28 and 30 are outliers
original.data.28.30 <- subset(original.data, original.data$subject.num != 28 &
  original.data$subject.num != 30)
mod0.total.outliers <- lm(total.UPDRS ~ subject.num + age + sex + test.time -
  1, data=original.data.28.30)
total.forward.outliers <- step(mod0.total.outliers, scope=~NHR + HNR + RPDE +
  DFA + PPE + logJitter.pctg + logJitter.Abs + logJitter.RAP + logJitter.PPQ5 +
  logJitter.DDP + logShimmer + logShimmer.dB + logShimmer.APQ3 +
  logShimmer.APQ5 + logShimmer.APQ11 + logShimmer.DDA + subject.num + age + sex +
  test.time + - 1, direction="forward")

# Subjects 18 is an outlier (from cooks.distance(total.forward))
original.data.18.30 <- subset(original.data, original.data$subject.num != 18 &
  original.data$subject.num != 30)
mod0.total.outliers.18 <- lm(total.UPDRS ~ subject.num + age + sex + test.time -
  1, data=original.data.18.30)
total.forward.outliers.18 <- step(mod0.total.outliers.18, scope=~NHR + HNR + RPDE +
  DFA + PPE + logJitter.pctg + logJitter.Abs + logJitter.RAP + logJitter.PPQ5 +
  logJitter.DDP + logShimmer + logShimmer.dB + logShimmer.APQ3 +
  logShimmer.APQ5 + logShimmer.APQ11 + logShimmer.DDA + subject.num + age + sex +
  test.time + - 1, direction="forward")

#===============================================================================
# Code for estimating motor.UPDRS
#===============================================================================
mod0.motor <- lm(motor.UPDRS ~ subject.num + age + sex + test.time - 1)

# Variable selection
#---------------------------------------
motor.forward <- step(mod0.motor, scope=~NHR + HNR + RPDE + DFA + PPE +
  logJitter.pctg + logJitter.Abs + logJitter.RAP + logJitter.PPQ5 +
  logJitter.DDP + logShimmer + logShimmer.dB + logShimmer.APQ3 +
  logShimmer.APQ5 + logShimmer.APQ11 + logShimmer.DDA + subject.num + age + sex +
  test.time - 1, direction="forward")

# Remove outliers (subjects 28 & 30)
mod0.motor.outliers <- lm(motor.UPDRS ~ subject.num + age + sex + test.time -
  1, data=original.data.28.30)
motor.forward.outliers <- step(mod0.motor.outliers, scope=~NHR + HNR + RPDE +
  DFA + PPE + logJitter.pctg + logJitter.Abs + logJitter.RAP + logJitter.PPQ5 +
  logJitter.DDP + logShimmer + logShimmer.dB + logShimmer.APQ3 +
  logShimmer.APQ5 + logShimmer.APQ11 + logShimmer.DDA + subject.num + age + sex +
  test.time + - 1, direction="forward")

# Remove outliers (subjects 18 & 30)
mod0.motor.outliers.18 <- lm(motor.UPDRS ~ subject.num + age + sex + test.time -
  1, data=original.data.18.30)
motor.forward.outliers.18 <- step(mod0.motor.outliers.18, scope=~NHR + HNR + RPDE +
  DFA + PPE + logJitter.pctg + logJitter.Abs + logJitter.RAP + logJitter.PPQ5 +
  logJitter.DDP + logShimmer + logShimmer.dB + logShimmer.APQ3 +
  logShimmer.APQ5 + logShimmer.APQ11 + logShimmer.DDA + subject.num + age + sex +
  test.time + - 1, direction="forward")
