library(alr3)
library(locfit)

# Problem 10.2
#---------------------------------------
mod.forward <- lm(Y ~ 1, data=mantel)
mod.backward <- lm(Y ~ X1 + X2 + X3, data=mantel)

step.forward <- step(mod.forward, scope=~X1 + X2 + X3, direction="forward")
step.backward <- step(mod.backward, scope=~1, direction="backward")

# Problem 10.3
#---------------------------------------
highway$logRate <- log(highway$Rate)
highway$logLen <- log(highway$Len)
highway$logADT <- log(highway$ADT)
highway$logTrks <- log(highway$Trks)
highway$logSigsI <- log2(highway$Sigs+1)/(highway$Len)

highway$Hwy1 <- 0 # or <- vector()
highway$Hwy2 <- 0
highway$Hwy3 <- 0

highway$Hwy1[highway$Hwy==1] <- 1
highway$Hwy2[highway$Hwy==2] <- 1
highway$Hwy3[highway$Hwy==3] <- 1

mod.backward.highway <- lm(logRate ~ logLen + logADT + logTrks + Slim + Lwid +
  Shld + Itg + logSigsI + Acpt + Hwy, data=highway)

step.backward.highway <- step(mod.backward.highway, scope=list(lower=~logLen,
  upper=~logLen+logADT+logTrks+Slim+Lwid+Shld+Itg+logSigsI+Acpt+Hwy),
  direction="backward")
