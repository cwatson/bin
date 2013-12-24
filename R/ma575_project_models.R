# Uses the Parkinson's Telemonitoring Data Set (from the UCI Machine Learning
# Repository) to predict clinical scores from biometric voice data.
#
#_______________________________________________________________________________
# by Chris Watson, 2012-11-28

#library('rms')   # for cross-validation
#library('boot')  # for bootstrapping

source('ma575_project_select_Variables.R')

# FUNCTION
#===============================================================================
#BootFun <- function(formula, data, indices) {
#  d <- data[indices, ]
#  fit <- lm(formula, data=d)
#  return(coef(fit))
#}

# Bootstrap
#total.forward.boot <- boot(data=original.data, statistic=BootFun, R=999,
#  formula=total.forward$call$formula)

# Take parameter estimates & apply to testing data. Compare to real UPDRS scores
#-------------------------------------------------------------------------------
betas.total <- total.forward$coefficients
betas.total.outliers <- total.forward.outliers$coefficients
betas.total.outliers.18 <- total.forward.outliers.18$coefficients

X <- list()
for (i in 1:length(betas.total)) {
  X <- cbind(X, eval(parse(text=paste("testing.data$",
    names(total.forward$coefficients[i]), sep=""))))
}
X.mat <- matrix(unlist(X), ncol=dim(X)[2], byrow=FALSE)

# Model with outlier removed
testing.data.sub <- testing.data#[testing.data$subject.num!=36, ]
X.outliers <- list()
for (i in 1:length(betas.total.outliers)) {
  X.outliers <- cbind(X.outliers, eval(parse(text=paste("testing.data.sub$",
    names(total.forward.outliers$coefficients[i]), sep=""))))
}
X.outliers.mat <- matrix(unlist(X.outliers), ncol=dim(X.outliers)[2],
  byrow=FALSE)

X.outliers.18 <- list()
for (i in 1:length(betas.total.outliers.18)) {
  X.outliers.18 <- cbind(X.outliers.18, eval(parse(text=paste("testing.data.sub$",
    names(total.forward.outliers.18$coefficients[i]), sep=""))))
}
X.outliers.mat.18 <- matrix(unlist(X.outliers.18), ncol=dim(X.outliers.18)[2],
  byrow=FALSE)

# Get predicted values for total.UPDRS based on model coefficients
y.predicted <- X.mat %*% betas.total
y.predicted.outliers <- X.outliers.mat %*% betas.total.outliers
y.predicted.outliers.18 <- X.outliers.mat.18 %*% betas.total.outliers.18


pairs(y.predicted ~ testing.data$total.UPDRS)
pairs(y.predicted.outliers ~ testing.data.sub$total.UPDRS)
pairs(y.predicted.outliers.18 ~ testing.data.sub$total.UPDRS)

MAE.total <- 1/length(y.predicted)*sum(abs(testing.data$total.UPDRS -
  y.predicted))
MAE.total.outliers <- 1/length(y.predicted.outliers) *
  sum(abs(testing.data$total.UPDRS - y.predicted.outliers))
MAE.total.outliers.18 <- 1/length(y.predicted.outliers.18) *
  sum(abs(testing.data$total.UPDRS - y.predicted.outliers.18))

#===============================================================================
# Code for motor.UPDRS
#===============================================================================
betas.motor <- motor.forward$coefficients
betas.motor.outliers <- motor.forward.outliers$coefficients
betas.motor.outliers.18 <- motor.forward.outliers.18$coefficients

X <- list()
for (i in 1:length(betas.motor)) {
  X <- cbind(X, eval(parse(text=paste("testing.data$",
    names(motor.forward$coefficients[i]), sep=""))))
}
X.mat <- matrix(unlist(X), ncol=dim(X)[2], byrow=FALSE)

# Model with outlier removed
testing.data.sub <- testing.data#[testing.data$subject.num!=36, ]
X.outliers <- list()
for (i in 1:length(betas.motor.outliers)) {
  X.outliers <- cbind(X.outliers, eval(parse(text=paste("testing.data.sub$",
    names(motor.forward.outliers$coefficients[i]), sep=""))))
}
X.outliers.mat <- matrix(unlist(X.outliers), ncol=dim(X.outliers)[2],
  byrow=FALSE)

X.outliers.18 <- list()
for (i in 1:length(betas.motor.outliers.18)) {
  X.outliers.18 <- cbind(X.outliers.18, eval(parse(text=paste("testing.data.sub$",
    names(motor.forward.outliers.18$coefficients[i]), sep=""))))
}
X.outliers.mat.18 <- matrix(unlist(X.outliers.18), ncol=dim(X.outliers.18)[2],
  byrow=FALSE)

# Get predicted values for motor.UPDRS based on model coefficients
y.predicted.motor <- X.mat %*% betas.motor
y.predicted.motor.outliers <- X.outliers.mat %*% betas.motor.outliers
y.predicted.motor.outliers.18 <- X.outliers.mat.18 %*% betas.motor.outliers.18


pairs(y.predicted.motor ~ testing.data$motor.UPDRS)
pairs(y.predicted.motor.outliers ~ testing.data.sub$motor.UPDRS)
pairs(y.predicted.motor.outliers.18 ~ testing.data.sub$motor.UPDRS)

MAE.motor <- 1/length(y.predicted.motor)*sum(abs(testing.data$motor.UPDRS -
  y.predicted.motor))
MAE.motor.outliers <- 1/length(y.predicted.motor.outliers) *
  sum(abs(testing.data$motor.UPDRS - y.predicted.motor.outliers))
MAE.motor.outliers.18 <- 1/length(y.predicted.motor.outliers.18) *
  sum(abs(testing.data$motor.UPDRS - y.predicted.motor.outliers.18))
