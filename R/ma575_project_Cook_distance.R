mTotal<-lm(motor.UPDRS~HNR+RPDE+DFA+PPE+logNHR+logJitter.pctg+logJitter.RAP+
logJitter.DDP+logJitter.PPQ5+logJitter.Abs+logShimmer+logShimmer.dB+
logShimmer.APQ3+logShimmer.APQ5+logShimmer.APQ11+logShimmer.DDA)

Yhat<-predict(mTotal)
Errori<-(motor.UPDRS-Yhat)^2
RSS<-sum(Errori)
sigmaHat<-RSS/12478

detach(work)
work_01<-subset(work,work$subject.!=1)

mTotal_01<-lm(motor.UPDRS~HNR+RPDE+DFA+PPE+logNHR+logJitter.pctg+logJitter.RAP+
logJitter.DDP+logJitter.PPQ5+logJitter.Abs+logShimmer+logShimmer.dB+
logShimmer.APQ3+logShimmer.APQ5+logShimmer.APQ11+logShimmer.DDA,
data=work_01)

Yhat_01<-predict(mTotal_01,newdata=work)

dcs_01<-(Yhat-Yhat_01)^2
D_01<-sum(dcs_01)/(sigmaHat*16)

work_02<-subset(work,work$subject.!=2)

mTotal_02<-lm(motor.UPDRS~HNR+RPDE+DFA+PPE+logNHR+logJitter.pctg+logJitter.RAP+
logJitter.DDP+logJitter.PPQ5+logJitter.Abs+logShimmer+logShimmer.dB+
logShimmer.APQ3+logShimmer.APQ5+logShimmer.APQ11+logShimmer.DDA,
data=work_02)

Yhat_02<-predict(mTotal_02,newdata=work)
dcs_02<-(Yhat-Yhat_02)^2
D_02<-sum(dcs_02)/(sigmaHat*16)


work_03<-subset(work,work$subject.!=3)
mTotal_03<-lm(motor.UPDRS~HNR+RPDE+DFA+PPE+logNHR+logJitter.pctg+logJitter.RAP+
logJitter.DDP+logJitter.PPQ5+logJitter.Abs+logShimmer+logShimmer.dB+
logShimmer.APQ3+logShimmer.APQ5+logShimmer.APQ11+logShimmer.DDA,
data=work_03)

Yhat_03<-predict(mTotal_03,newdata=work)
dcs_03<-(Yhat-Yhat_03)^2
D_03<-sum(dcs_03)/(sigmaHat*16)


work_04<-subset(work,work$subject.!=4)
mTotal_04<-lm(motor.UPDRS~HNR+RPDE+DFA+PPE+logNHR+logJitter.pctg+logJitter.RAP+
logJitter.DDP+logJitter.PPQ5+logJitter.Abs+logShimmer+logShimmer.dB+
logShimmer.APQ3+logShimmer.APQ5+logShimmer.APQ11+logShimmer.DDA,
data=work_04)

Yhat_04<-predict(mTotal_04,newdata=work)
dcs_04<-(Yhat-Yhat_04)^2
D_04<-sum(dcs_04)/(sigmaHat*16)

work_05<-subset(work,work$subject.!=5)

mTotal_05<-lm(motor.UPDRS~HNR+RPDE+DFA+PPE+logNHR+logJitter.pctg+logJitter.RAP+
logJitter.DDP+logJitter.PPQ5+logJitter.Abs+logShimmer+logShimmer.dB+
logShimmer.APQ3+logShimmer.APQ5+logShimmer.APQ11+logShimmer.DDA,
data=work_05)

Yhat_05<-predict(mTotal_05,newdata=work)

dcs_05<-(Yhat-Yhat_05)^2
D_05<-sum(dcs_05)/(sigmaHat*16)

work_06<-subset(work,work$subject.!=6)

mTotal_06<-lm(motor.UPDRS~HNR+RPDE+DFA+PPE+logNHR+logJitter.pctg+logJitter.RAP+
logJitter.DDP+logJitter.PPQ5+logJitter.Abs+logShimmer+logShimmer.dB+
logShimmer.APQ3+logShimmer.APQ5+logShimmer.APQ11+logShimmer.DDA,
data=work_06)

Yhat_06<-predict(mTotal_06,newdata=work)
dcs_06<-(Yhat-Yhat_06)^2
D_06<-sum(dcs_06)/(sigmaHat*16)


work_07<-subset(work,work$subject.!=7)
mTotal_07<-lm(motor.UPDRS~HNR+RPDE+DFA+PPE+logNHR+logJitter.pctg+logJitter.RAP+
logJitter.DDP+logJitter.PPQ5+logJitter.Abs+logShimmer+logShimmer.dB+
logShimmer.APQ3+logShimmer.APQ5+logShimmer.APQ11+logShimmer.DDA,
data=work_07)

Yhat_07<-predict(mTotal_07,newdata=work)
dcs_07<-(Yhat-Yhat_07)^2
D_07<-sum(dcs_07)/(sigmaHat*16)


work_08<-subset(work,work$subject.!=8)

mTotal_08<-lm(motor.UPDRS~HNR+RPDE+DFA+PPE+logNHR+logJitter.pctg+logJitter.RAP+
logJitter.DDP+logJitter.PPQ5+logJitter.Abs+logShimmer+logShimmer.dB+
logShimmer.APQ3+logShimmer.APQ5+logShimmer.APQ11+logShimmer.DDA,
data=work_08)

Yhat_08<-predict(mTotal_08,newdata=work)

dcs_08<-(Yhat-Yhat_08)^2
D_08<-sum(dcs_08)/(sigmaHat*16)


work_09<-subset(work,work$subject.!=9)
mTotal_09<-lm(motor.UPDRS~HNR+RPDE+DFA+PPE+logNHR+logJitter.pctg+logJitter.RAP+
logJitter.DDP+logJitter.PPQ5+logJitter.Abs+logShimmer+logShimmer.dB+
logShimmer.APQ3+logShimmer.APQ5+logShimmer.APQ11+logShimmer.DDA,
data=work_09)

Yhat_09<-predict(mTotal_09,newdata=work)
dcs_09<-(Yhat-Yhat_09)^2
D_09<-sum(dcs_09)/(sigmaHat*16)

work_10<-subset(work,work$subject.!=10)

mTotal_10<-lm(motor.UPDRS~HNR+RPDE+DFA+PPE+logNHR+logJitter.pctg+logJitter.RAP+
logJitter.DDP+logJitter.PPQ5+logJitter.Abs+logShimmer+logShimmer.dB+
logShimmer.APQ3+logShimmer.APQ5+logShimmer.APQ11+logShimmer.DDA,
data=work_10)

Yhat_10<-predict(mTotal_10,newdata=work)

dcs_10<-(Yhat-Yhat_10)^2
D_10<-sum(dcs_10)/(sigmaHat*16)


work_11<-subset(work,work$subject.!=11)

mTotal_11<-lm(motor.UPDRS~HNR+RPDE+DFA+PPE+logNHR+logJitter.pctg+logJitter.RAP+
logJitter.DDP+logJitter.PPQ5+logJitter.Abs+logShimmer+logShimmer.dB+
logShimmer.APQ3+logShimmer.APQ5+logShimmer.APQ11+logShimmer.DDA,
data=work_11)

Yhat_11<-predict(mTotal_11,newdata=work)

dcs_11<-(Yhat-Yhat_11)^2
D_11<-sum(dcs_11)/(sigmaHat*16)


work_12<-subset(work,work$subject.!=12)

mTotal_12<-lm(motor.UPDRS~HNR+RPDE+DFA+PPE+logNHR+logJitter.pctg+logJitter.RAP+
logJitter.DDP+logJitter.PPQ5+logJitter.Abs+logShimmer+logShimmer.dB+
logShimmer.APQ3+logShimmer.APQ5+logShimmer.APQ11+logShimmer.DDA,
data=work_12)

Yhat_12<-predict(mTotal_12,newdata=work)
dcs_12<-(Yhat-Yhat_12)^2
D_12<-sum(dcs_12)/(sigmaHat*16)


work_13<-subset(work,work$subject.!=3)
mTotal_13<-lm(motor.UPDRS~HNR+RPDE+DFA+PPE+logNHR+logJitter.pctg+logJitter.RAP+
logJitter.DDP+logJitter.PPQ5+logJitter.Abs+logShimmer+logShimmer.dB+
logShimmer.APQ3+logShimmer.APQ5+logShimmer.APQ11+logShimmer.DDA,
data=work_13)

Yhat_13<-predict(mTotal_13,newdata=work)
dcs_13<-(Yhat-Yhat_13)^2
D_13<-sum(dcs_13)/(sigmaHat*16)


work_14<-subset(work,work$subject.!=14)
mTotal_14<-lm(motor.UPDRS~HNR+RPDE+DFA+PPE+logNHR+logJitter.pctg+logJitter.RAP+
logJitter.DDP+logJitter.PPQ5+logJitter.Abs+logShimmer+logShimmer.dB+
logShimmer.APQ3+logShimmer.APQ5+logShimmer.APQ11+logShimmer.DDA,
data=work_14)

Yhat_14<-predict(mTotal_14,newdata=work)
dcs_14<-(Yhat-Yhat_14)^2
D_14<-sum(dcs_14)/(sigmaHat*16)

work_15<-subset(work,work$subject.!=15)
mTotal_15<-lm(motor.UPDRS~HNR+RPDE+DFA+PPE+logNHR+logJitter.pctg+logJitter.RAP+
logJitter.DDP+logJitter.PPQ5+logJitter.Abs+logShimmer+logShimmer.dB+
logShimmer.APQ3+logShimmer.APQ5+logShimmer.APQ11+logShimmer.DDA,
data=work_15)

Yhat_15<-predict(mTotal_15,newdata=work)
dcs_15<-(Yhat-Yhat_15)^2
D_15<-sum(dcs_15)/(sigmaHat*16)

work_16<-subset(work,work$subject.!=16)

mTotal_16<-lm(motor.UPDRS~HNR+RPDE+DFA+PPE+logNHR+logJitter.pctg+logJitter.RAP+
logJitter.DDP+logJitter.PPQ5+logJitter.Abs+logShimmer+logShimmer.dB+
logShimmer.APQ3+logShimmer.APQ5+logShimmer.APQ11+logShimmer.DDA,
data=work_16)

Yhat_16<-predict(mTotal_16,newdata=work)
dcs_16<-(Yhat-Yhat_16)^2
D_16<-sum(dcs_16)/(sigmaHat*16)


work_17<-subset(work,work$subject.!=17)
mTotal_17<-lm(motor.UPDRS~HNR+RPDE+DFA+PPE+logNHR+logJitter.pctg+logJitter.RAP+
logJitter.DDP+logJitter.PPQ5+logJitter.Abs+logShimmer+logShimmer.dB+
logShimmer.APQ3+logShimmer.APQ5+logShimmer.APQ11+logShimmer.DDA,
data=work_17)

Yhat_17<-predict(mTotal_17,newdata=work)
dcs_17<-(Yhat-Yhat_17)^2
D_17<-sum(dcs_17)/(sigmaHat*16)


work_18<-subset(work,work$subject.!=18)
mTotal_18<-lm(motor.UPDRS~HNR+RPDE+DFA+PPE+logNHR+logJitter.pctg+logJitter.RAP+
logJitter.DDP+logJitter.PPQ5+logJitter.Abs+logShimmer+logShimmer.dB+
logShimmer.APQ3+logShimmer.APQ5+logShimmer.APQ11+logShimmer.DDA,
data=work_18)

Yhat_18<-predict(mTotal_18,newdata=work)

dcs_18<-(Yhat-Yhat_18)^2
D_18<-sum(dcs_18)/(sigmaHat*16)


work_19<-subset(work,work$subject.!=19)
mTotal_19<-lm(motor.UPDRS~HNR+RPDE+DFA+PPE+logNHR+logJitter.pctg+logJitter.RAP+
logJitter.DDP+logJitter.PPQ5+logJitter.Abs+logShimmer+logShimmer.dB+
logShimmer.APQ3+logShimmer.APQ5+logShimmer.APQ11+logShimmer.DDA,
data=work_19)

Yhat_19<-predict(mTotal_19,newdata=work)
dcs_19<-(Yhat-Yhat_19)^2
D_19<-sum(dcs_19)/(sigmaHat*16)

work_20<-subset(work,work$subject.!=20)

mTotal_20<-lm(motor.UPDRS~HNR+RPDE+DFA+PPE+logNHR+logJitter.pctg+logJitter.RAP+
logJitter.DDP+logJitter.PPQ5+logJitter.Abs+logShimmer+logShimmer.dB+
logShimmer.APQ3+logShimmer.APQ5+logShimmer.APQ11+logShimmer.DDA,
data=work_20)

Yhat_20<-predict(mTotal_20,newdata=work)

dcs_20<-(Yhat-Yhat_20)^2
D_20<-sum(dcs_20)/(sigmaHat*16)


work_21<-subset(work,work$subject.!=21)

mTotal_21<-lm(motor.UPDRS~HNR+RPDE+DFA+PPE+logNHR+logJitter.pctg+logJitter.RAP+
logJitter.DDP+logJitter.PPQ5+logJitter.Abs+logShimmer+logShimmer.dB+
logShimmer.APQ3+logShimmer.APQ5+logShimmer.APQ11+logShimmer.DDA,
data=work_21)

Yhat_21<-predict(mTotal_21,newdata=work)

dcs_21<-(Yhat-Yhat_21)^2
D_21<-sum(dcs_21)/(sigmaHat*16)

work_22<-subset(work,work$subject.!=2)

mTotal_22<-lm(motor.UPDRS~HNR+RPDE+DFA+PPE+logNHR+logJitter.pctg+logJitter.RAP+
logJitter.DDP+logJitter.PPQ5+logJitter.Abs+logShimmer+logShimmer.dB+
logShimmer.APQ3+logShimmer.APQ5+logShimmer.APQ11+logShimmer.DDA,
data=work_22)

Yhat_22<-predict(mTotal_22,newdata=work)
dcs_22<-(Yhat-Yhat_22)^2
D_22<-sum(dcs_22)/(sigmaHat*16)


work_23<-subset(work,work$subject.!=23)
mTotal_23<-lm(motor.UPDRS~HNR+RPDE+DFA+PPE+logNHR+logJitter.pctg+logJitter.RAP+
logJitter.DDP+logJitter.PPQ5+logJitter.Abs+logShimmer+logShimmer.dB+
logShimmer.APQ3+logShimmer.APQ5+logShimmer.APQ11+logShimmer.DDA,
data=work_23)

Yhat_23<-predict(mTotal_23,newdata=work)
dcs_23<-(Yhat-Yhat_23)^2
D_23<-sum(dcs_23)/(sigmaHat*16)


work_24<-subset(work,work$subject.!=24)
mTotal_24<-lm(motor.UPDRS~HNR+RPDE+DFA+PPE+logNHR+logJitter.pctg+logJitter.RAP+
logJitter.DDP+logJitter.PPQ5+logJitter.Abs+logShimmer+logShimmer.dB+
logShimmer.APQ3+logShimmer.APQ5+logShimmer.APQ11+logShimmer.DDA,
data=work_24)

Yhat_24<-predict(mTotal_24,newdata=work)
dcs_24<-(Yhat-Yhat_24)^2
D_24<-sum(dcs_24)/(sigmaHat*16)

work_25<-subset(work,work$subject.!=25)

mTotal_25<-lm(motor.UPDRS~HNR+RPDE+DFA+PPE+logNHR+logJitter.pctg+logJitter.RAP+
logJitter.DDP+logJitter.PPQ5+logJitter.Abs+logShimmer+logShimmer.dB+
logShimmer.APQ3+logShimmer.APQ5+logShimmer.APQ11+logShimmer.DDA,
data=work_25)

Yhat_25<-predict(mTotal_25,newdata=work)

dcs_25<-(Yhat-Yhat_25)^2
D_25<-sum(dcs_25)/(sigmaHat*16)


work_26<-subset(work,work$subject.!=26)
mTotal_26<-lm(motor.UPDRS~HNR+RPDE+DFA+PPE+logNHR+logJitter.pctg+logJitter.RAP+
logJitter.DDP+logJitter.PPQ5+logJitter.Abs+logShimmer+logShimmer.dB+
logShimmer.APQ3+logShimmer.APQ5+logShimmer.APQ11+logShimmer.DDA,
data=work_26)

Yhat_26<-predict(mTotal_26,newdata=work)
dcs_26<-(Yhat-Yhat_26)^2
D_26<-sum(dcs_06)/(sigmaHat*16)


work_27<-subset(work,work$subject.!=27)
mTotal_27<-lm(motor.UPDRS~HNR+RPDE+DFA+PPE+logNHR+logJitter.pctg+logJitter.RAP+
logJitter.DDP+logJitter.PPQ5+logJitter.Abs+logShimmer+logShimmer.dB+
logShimmer.APQ3+logShimmer.APQ5+logShimmer.APQ11+logShimmer.DDA,
data=work_27)

Yhat_27<-predict(mTotal_27,newdata=work)
dcs_27<-(Yhat-Yhat_07)^2
D_27<-sum(dcs_27)/(sigmaHat*16)


work_28<-subset(work,work$subject.!=28)

mTotal_28<-lm(motor.UPDRS~HNR+RPDE+DFA+PPE+logNHR+logJitter.pctg+logJitter.RAP+
logJitter.DDP+logJitter.PPQ5+logJitter.Abs+logShimmer+logShimmer.dB+
logShimmer.APQ3+logShimmer.APQ5+logShimmer.APQ11+logShimmer.DDA,
data=work_28)

Yhat_28<-predict(mTotal_28,newdata=work)

dcs_28<-(Yhat-Yhat_28)^2
D_28<-sum(dcs_28)/(sigmaHat*16)


work_29<-subset(work,work$subject.!=29)
mTotal_29<-lm(motor.UPDRS~HNR+RPDE+DFA+PPE+logNHR+logJitter.pctg+logJitter.RAP+
logJitter.DDP+logJitter.PPQ5+logJitter.Abs+logShimmer+logShimmer.dB+
logShimmer.APQ3+logShimmer.APQ5+logShimmer.APQ11+logShimmer.DDA,
data=work_29)

Yhat_29<-predict(mTotal_29,newdata=work)
dcs_29<-(Yhat-Yhat_29)^2
D_29<-sum(dcs_29)/(sigmaHat*16)

work_30<-subset(work,work$subject.!=30)

mTotal_30<-lm(motor.UPDRS~HNR+RPDE+DFA+PPE+logNHR+logJitter.pctg+logJitter.RAP+
logJitter.DDP+logJitter.PPQ5+logJitter.Abs+logShimmer+logShimmer.dB+
logShimmer.APQ3+logShimmer.APQ5+logShimmer.APQ11+logShimmer.DDA,
data=work_30)

Yhat_30<-predict(mTotal_30,newdata=work)

dcs_30<-(Yhat-Yhat_30)^2
D_30<-sum(dcs_30)/(sigmaHat*16)

D<-c(D_01,D_02,D_03,D_04,D_05,D_06,D_07,D_08,D_09,D_10,
D_11,D_12,D_13,D_14,D_15,D_16,D_17,D_18,D_19,D_20,
D_21,D_22,D_23,D_24,D_25,D_26,D_27,D_28,D_29,D_30)

P<-seq(1,30,length=30)
CD_S<-data.frame(subject.=P,D=D)
attach(CD_S)
plot(subject.,D)
detach(CD_S)

work_30_28<-subset(work_30,work$subject.!=28)
