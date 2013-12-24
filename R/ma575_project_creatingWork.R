work<-merge(WorkData01[,c(1,2,3,4,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22)],
+ UU[,c(1,7,8)],by="subject.")
attach(work)
work$Sx<-sex+1
detach(work)
attach(work)
work$motor_UPDRS<-mean_total*.7017251+mean_total*test_time*.0004968
detach(work)
plot(work$test_time,work$motor_UPDRS)

cor(work[,c(5,6,7,8,9,16,20,10,11,12,13,14,15,17,18,19,24)])

#library(alr3)
#mNHR01<-lm(work$motor_UPDRS~work$NHR)
#boxcox(mNHR01,xlab=expression(labda[y]))

 work$logNHR<-logb(work$NHR,2)
 attach(work)
 plot(logNHR,motor_UPDRS)
 loessNHR<-loess(motor_UPDRS~logNHR,span=0.75)
 xl<-seq(-12,1,length=200)
 lines(xl,predict(loessNHR,newdata=data.frame(logNHR=xl)),lty=3,col=2)
 mNHR01<-lm(motor_UPDRS~logNHR)
 abline(mNHR01)
 mNHR02<-lm(motor_UPDRS~logNHR+I(logNHR^2))
 lines(xl,predict(mNHR02,newdata=data.frame(logNHR=xl)),lty=3,col=3)
 summary(mNHR01)

par(mfrow=c(2,2))
plot(predict(mNHR01),residuals(mNHR01))
plot(NHR,residuals(mNHR01))
plot(predict(mNHR02),residuals(mNHR02))
plot(NHR,residuals(mNHR02))


par(mfrow=c(1,1))
 plot(DFA,motor_UPDRS)
 xl<-seq(0,1,length=200)	
 mDFA01<-lm(motor_UPDRS~DFA)
 mDFA02<-lm(motor_UPDRS~DFA+I(DFA^2))
 mDFA03<-lm(motor_UPDRS~DFA+I(DFA^2)+I(DFA^3))
 mDFA05<-lm(motor_UPDRS~DFA+I(DFA^2)+I(DFA^3)+I(DFA^4)+I(DFA^5))
 loessDFA<-loess(motor_UPDRS~DFA,span=0.75)
 abline(mDFA01)
 lines(xl,predict(mDFA02,newdata=data.frame(DFA=xl)),lty=3,col=5)
 lines(xl,predict(mDFA03,newdata=data.frame(DFA=xl)),lty=3,col=4)
 lines(xl,predict(mDFA05,newdata=data.frame(DFA=xl)),lty=3,col=3)
 lines(xl,predict(loessDFA,newdata=data.frame(DFA=xl)),lty=3,col=2)

par(mfrow=c(2,2))
plot(predict(mDFA01),residuals(mDFA01))
plot(predict(mDFA02),residuals(mDFA02))
plot(predict(mDFA03),residuals(mDFA03))
plot(predict(mDFA05),residuals(mDFA05))

par(mfrow=c(1,1))
 plot(RPDE,motor_UPDRS)
 mRPDE01<-lm(motor_UPDRS~RPDE)
 abline(mRPDE01,col=2)
 loessRPDE<-loess(motor_UPDRS~RPDE,span=0.75)
 lines(xl,predict(loessRPDE,newdata=data.frame(RPDE=xl)),lty=2,col=3)
 plot(predict(mRPDE01),residuals(mRPDE01))

plot(HNR,motor_UPDRS)# consider to drop it out

plot(PPE,motor_UPDRS)
mPPE01<-lm(motor_UPDRS~PPE)
loessPPE<-loess(motor_UPDRS~PPE,span=0.75)
abline(mPPE01,col=2)
lines(xl,predict(loessPPE,newdata=data.frame(PPE=xl)),lty=2,col=3)
plot(predict(mPPE01),residuals(mPPE01))

pairs(work[,c(5,6,7,8,9)])

work$logJitter...<-logb(work$Jitter...,2)
work$logJitter.RAP<-logb(work$Jitter.RAP,2)
work$logJitter.DDP<-logb(work$Jitter.DDP,2)
work$logJitter.PPQ5<-logb(work$Jitter.PPQ5,2)
work$logJitter.Abs<-logb(work$Jitter.Abs,2)
attach(work)
mJitter01<-lm(motor_UPDRS~logJitter.RAP)
plot(logJitter.RAP,motor_UPDRS)
abline(mJitter01,col=2)
loessJitter<-loess(motor_UPDRS~logJitter.RAP,span=0.75)
 xl<-seq(-12,-4,length=200)
 lines(xl,predict(loessJitter,newdata=data.frame(logJitter.RAP=xl)),lty=2,col=3)

pairs(work[,c(10,11,12,13,14,15,24)])

detach(work)
work$logShimmer<-logb(work$Shimmer,2)
work$logShimmer.dB<-logb(work$Shimmer.dB,2)
work$logShimmer.APQ3<-logb(work$Shimmer.APQ3,2)
work$logShimmer.APQ5<-logb(work$Shimmer.APQ5,2)
work$logShimmer.APQ11<-logb(work$Shimmer.APQ11,2)
work$logShimmer.DDA<-logb(work$Shimmer.DDA,2)
attach(work)

plot(logShimmer,motor_UPDRS)
mShimmer01<-lm(motor_UPDRS~logShimmer)
summary(mShimmer01)
abline(mShimmer01,col=2)
loessShimmer<-loess(motor_UPDRS~logShimmer,span=0.75)
xl<-seq(-10,-2,length=200)
 lines(xl,predict(loessShimmer,newdata=data.frame(logShimmer=xl)),lty=2,col=3)



index=sample.int(7000,size=7000,replace=FALSE,prob=NULL)
train01<-work[index,]
test01<-work[-index,]

mTotal<-lm(motor_UPDRS~logNHR*HNR*RPDE*DFA*logJitter...*logJitter.RAP*
logJitter.DDP*logJitter.PPQ5*logJitter.Abs*logShimmer*logShimmer.dB*
logShimmer.APQ3*logShimmer.APQ5*logShimmer.APQ11*logShimmer.DDA)
