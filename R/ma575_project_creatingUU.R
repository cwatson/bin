library(alr3)
OriginalData<-read.csv("../data/parkinsons_updrs.data", header=T)
WorkData01<-subset(OriginalData, OriginalData$subject.<31)
WorkData<-WorkData01[,c(1,2,3,4,5,6)]

UU01<- subset(WorkData,WorkData$subject.==1)
x<-min(UU01$test_time)
y<-max(UU01$test_time)
z<-median(UU01$test_time)
UU01a<-subset(UU01,UU01$test_time==x|UU01$test_time==y|UU01$test_time==z)
UU01a<-UU01a[1:3,c(1,2,3,4,5,6)]
UU01a$mean_total<-mean(UU01a$total_UPDRS)
UU01a$mean_motor<-mean(UU01a$motor_UPDRS)

UU02<- subset(WorkData,WorkData$subject.==2)
x<-min(UU02$test_time)
y<-max(UU02$test_time)
z<-median(UU02$test_time)
UU02a<-subset(UU02,UU02$test_time==x|UU02$test_time==y|(UU02$test_time>=z-1 &UU02$test_time<=z+4))
UU02a<-UU02a[1:3,c(1,2,3,4,5,6)]
UU02a$mean_total<-mean(UU02a$total_UPDRS)
UU02a$mean_motor<-mean(UU02a$motor_UPDRS)

UU03<- subset(WorkData,WorkData$subject.==3)
x<-min(UU03$test_time)
y<-max(UU03$test_time)
z<-median(UU03$test_time)
UU03a<-subset(UU03,UU03$test_time==x|UU03$test_time==y|(UU03$test_time<=z+3 & UU03$test_time>=z-4))
UU03a<-UU03a[1:3,c(1,2,3,4,5,6)]
UU03a$mean_total<-mean(UU03a$total_UPDRS)
UU03a$mean_motor<-mean(UU03a$motor_UPDRS)

UU04<- subset(WorkData,WorkData$subject.==4)
x<-min(UU04$test_time)
y<-max(UU04$test_time)
z<-median(UU04$test_time)
UU04a<-subset(UU04,UU04$test_time==x|UU04$test_time==y|UU04$test_time==z)
UU04a<-UU04a[1:3,c(1,2,3,4,5,6)]
UU04a$mean_total<-mean(UU04a$total_UPDRS)
UU04a$mean_motor<-mean(UU04a$motor_UPDRS)

UU05<- subset(WorkData,WorkData$subject.==5)
x<-min(UU05$test_time)
y<-max(UU05$test_time)
z<-median(UU05$test_time)
UU05a<-subset(UU05,UU05$test_time==x|UU05$test_time==y|(UU05$test_time<=z+3 & UU05$test_time>=z-4))
UU05a<-UU05a[1:3,c(1,2,3,4,5,6)]
UU05a$mean_total<-mean(UU05a$total_UPDRS)
UU05a$mean_motor<-mean(UU05a$motor_UPDRS)

UU06<- subset(WorkData,WorkData$subject.==6)
x<-min(UU06$test_time)
y<-max(UU06$test_time)
z<-median(UU06$test_time)
UU06a<-subset(UU06,UU06$test_time==x|UU06$test_time==y|(UU06$test_time<=z+3 & UU06$test_time>=z-4))
UU06a<-UU06a[1:3,c(1,2,3,4,5,6)]
UU06a$mean_total<-mean(UU06a$total_UPDRS)
UU06a$mean_motor<-mean(UU06a$motor_UPDRS)

UU07<- subset(WorkData,WorkData$subject.==7)
x<-min(UU07$test_time)
y<-max(UU07$test_time)
z<-median(UU07$test_time)
UU07a<-subset(UU07,UU07$test_time==x|UU07$test_time==y|UU07$test_time==z)
UU07a<-UU07a[1:3,c(1,2,3,4,5,6)]
UU07a$mean_total<-mean(UU07a$total_UPDRS)
UU07a$mean_motor<-mean(UU07a$motor_UPDRS)

UU08<- subset(WorkData,WorkData$subject.==8)
x<-min(UU08$test_time)
y<-max(UU08$test_time)
z<-median(UU08$test_time)
UU08a<-subset(UU08,UU08$test_time==x|UU08$test_time==y|(UU08$test_time<=z+3 & UU08$test_time>=z-4))
UU08a<-UU08a[1:3,c(1,2,3,4,5,6)]
UU08a$mean_total<-mean(UU08a$total_UPDRS)
UU08a$mean_motor<-mean(UU08a$motor_UPDRS)

UU09<- subset(WorkData,WorkData$subject.==9)
x<-min(UU09$test_time)
y<-max(UU09$test_time)
z<-median(UU09$test_time)
UU09a<-subset(UU09,UU09$test_time==x|UU09$test_time==y|UU09$test_time==z)
UU09a<-UU09a[1:3,c(1,2,3,4,5,6)]
UU09a$mean_total<-mean(UU09a$total_UPDRS)
UU09a$mean_motor<-mean(UU09a$motor_UPDRS)

UU010<- subset(WorkData,WorkData$subject.==10)
x<-min(UU010$test_time)
y<-max(UU010$test_time)
z<-median(UU010$test_time)
UU010a<-subset(UU010,UU010$test_time==x|UU010$test_time==y|UU010$test_time==z)
UU010a<-UU010a[1:3,c(1,2,3,4,5,6)]
UU010a$mean_total<-mean(UU010a$total_UPDRS)
UU010a$mean_motor<-mean(UU010a$motor_UPDRS)

UU011<- subset(WorkData,WorkData$subject.==11)
x<-min(UU011$test_time)
y<-max(UU011$test_time)
z<-median(UU011$test_time)
UU011a<-subset(UU011,UU011$test_time==x|UU011$test_time==y|(UU011$test_time<=z+3 & UU011$test_time>=z-4))
UU011a<-UU011a[1:3,c(1,2,3,4,5,6)]
UU011a$mean_total<-mean(UU011a$total_UPDRS)
UU011a$mean_motor<-mean(UU011a$motor_UPDRS)

UU012<- subset(WorkData,WorkData$subject.==12)
x<-min(UU012$test_time)
y<-max(UU012$test_time)
z<-median(UU012$test_time)
UU012a<-subset(UU012,UU012$test_time==x|UU012$test_time==y|UU012$test_time==z)
UU012a<-UU012a[1:3,c(1,2,3,4,5,6)]
UU012a$mean_total<-mean(UU012a$total_UPDRS)
UU012a$mean_motor<-mean(UU012a$motor_UPDRS)

UU013<- subset(WorkData,WorkData$subject.==13)
x<-min(UU013$test_time)
y<-max(UU013$test_time)
z<-median(UU013$test_time)
UU013a<-subset(UU013,UU013$test_time==x|UU013$test_time==y|UU013$test_time==z)
UU013a<-UU013a[1:3,c(1,2,3,4,5,6)]
UU013a$mean_total<-mean(UU013a$total_UPDRS)
UU013a$mean_motor<-mean(UU013a$motor_UPDRS)

UU014<- subset(WorkData,WorkData$subject.==14)
x<-min(UU014$test_time)
y<-max(UU014$test_time)
z<-median(UU014$test_time)
UU014a<-subset(UU014,UU014$test_time==x|UU014$test_time==y|(UU014$test_time<=z+3 & UU014$test_time>=z-4))
UU014a<-UU014a[1:3,c(1,2,3,4,5,6)]
UU014a$mean_total<-mean(UU014a$total_UPDRS)
UU014a$mean_motor<-mean(UU014a$motor_UPDRS)

UU015<- subset(WorkData,WorkData$subject.==15)
x<-min(UU015$test_time)
y<-max(UU015$test_time)
z<-median(UU015$test_time)
UU015a<-subset(UU015,UU015$test_time==x|UU015$test_time==y|UU015$test_time==z)
UU015a<-UU015a[1:3,c(1,2,3,4,5,6)]
UU015a$mean_total<-mean(UU015a$total_UPDRS)
UU015a$mean_motor<-mean(UU015a$motor_UPDRS)


UU016<- subset(WorkData,WorkData$subject.==16)
x<-min(UU016$test_time)
y<-max(UU016$test_time)
z<-median(UU016$test_time)
UU016a<-subset(UU016,UU016$test_time==x|UU016$test_time==y|(UU016$test_time<=z+3 & UU016$test_time>=z-4))
UU016a<-UU016a[1:3,c(1,2,3,4,5,6)]
UU016a$mean_total<-mean(UU016a$total_UPDRS)
UU016a$mean_motor<-mean(UU016a$motor_UPDRS)


UU017<- subset(WorkData,WorkData$subject.==17)
x<-min(UU017$test_time)
y<-max(UU017$test_time)
z<-median(UU017$test_time)
UU017a<-subset(UU017,UU017$test_time==x|UU017$test_time==y|(UU017$test_time<=z+17 & UU017$test_time>=z-7))
UU017a<-UU017a[1:3,c(1,2,3,4,5,6)]
UU017a$mean_total<-mean(UU017a$total_UPDRS)
UU017a$mean_motor<-mean(UU017a$motor_UPDRS)


UU018<- subset(WorkData,WorkData$subject.==18)
x<-min(UU018$test_time)
y<-max(UU018$test_time)
z<-median(UU018$test_time)
UU018a<-subset(UU018,UU018$test_time==x|UU018$test_time==y|(UU018$test_time<=z+3 & UU018$test_time>=z-4))
UU018a<-UU018a[1:3,c(1,2,3,4,5,6)]
UU018a$mean_total<-mean(UU018a$total_UPDRS)
UU018a$mean_motor<-mean(UU018a$motor_UPDRS)

UU019<- subset(WorkData,WorkData$subject.==19)
x<-min(UU019$test_time)
y<-max(UU019$test_time)
z<-median(UU019$test_time)
UU019a<-subset(UU019,UU019$test_time==x|UU019$test_time==y|UU019$test_time==z)
UU019a<-UU019a[1:3,c(1,2,3,4,5,6)]
UU019a$mean_total<-mean(UU019a$total_UPDRS)
UU019a$mean_motor<-mean(UU019a$motor_UPDRS)


UU020<- subset(WorkData,WorkData$subject.==20)
x<-min(UU020$test_time)
y<-max(UU020$test_time)
z<-median(UU020$test_time)
UU020a<-subset(UU020,UU020$test_time==x|UU020$test_time==y|UU020$test_time==z)
UU020a<-UU020a[1:3,c(1,2,3,4,5,6)]
UU020a$mean_total<-mean(UU020a$total_UPDRS)
UU020a$mean_motor<-mean(UU020a$motor_UPDRS)

UU021<- subset(WorkData,WorkData$subject.==21)
x<-min(UU021$test_time)
y<-max(UU021$test_time)
z<-median(UU021$test_time)
UU021a<-subset(UU021,UU021$test_time==x|UU021$test_time==y|UU021$test_time==z)
UU021a<-UU021a[1:3,c(1,2,3,4,5,6)]
UU021a$mean_total<-mean(UU021a$total_UPDRS)
UU021a$mean_motor<-mean(UU021a$motor_UPDRS)

UU022<- subset(WorkData,WorkData$subject.==22)
x<-min(UU022$test_time)
y<-max(UU022$test_time)
z<-median(UU022$test_time)
UU022a<-subset(UU022,UU022$test_time==x|UU022$test_time==y|(UU022$test_time<=z+3 & UU022$test_time>=z-4))
UU022a<-UU022a[1:3,c(1,2,3,4,5,6)]
UU022a$mean_total<-mean(UU022a$total_UPDRS)
UU022a$mean_motor<-mean(UU022a$motor_UPDRS)


UU023<- subset(WorkData,WorkData$subject.==23)
x<-min(UU023$test_time)
y<-max(UU023$test_time)
z<-median(UU023$test_time)
UU023a<-subset(UU023,UU023$test_time==x|UU023$test_time==y|(UU023$test_time<=z+3 & UU023$test_time>=z-3))
UU023a<-UU023a[1:3,c(1,2,3,4,5,6)]
UU023a$mean_total<-mean(UU023a$total_UPDRS)
UU023a$mean_motor<-mean(UU023a$motor_UPDRS)


UU024<- subset(WorkData,WorkData$subject.==24)
x<-min(UU024$test_time)
y<-max(UU024$test_time)
z<-median(UU024$test_time)
UU024a<-subset(UU024,UU024$test_time==x|UU024$test_time==y|(UU024$test_time<=z+1 & UU024$test_time>=z-3))
UU024a<-UU024a[1:3,c(1,2,3,4,5,6)]
UU024a$mean_total<-mean(UU024a$total_UPDRS)
UU024a$mean_motor<-mean(UU024a$motor_UPDRS)


UU025<- subset(WorkData,WorkData$subject.==25)
x<-min(UU025$test_time)
y<-max(UU025$test_time)
z<-median(UU025$test_time)
UU025a<-subset(UU025,UU025$test_time==x|UU025$test_time==y|(UU025$test_time<=z+5 & UU025$test_time>=z-1))
UU025a<-UU03a[1:3,c(1,2,3,4,5,6)]
UU025a$mean_total<-mean(UU025a$total_UPDRS)
UU025a$mean_motor<-mean(UU025a$motor_UPDRS)


UU026<- subset(WorkData,WorkData$subject.==26)
x<-min(UU026$test_time)
y<-max(UU026$test_time)
z<-median(UU026$test_time)
UU026a<-subset(UU026,UU026$test_time==x|UU026$test_time==y|(UU026$test_time<=z+3 & UU026$test_time>=z-3))
UU026a<-UU026a[1:3,c(1,2,3,4,5,6)]
UU026a$mean_total<-mean(UU026a$total_UPDRS)
UU026a$mean_motor<-mean(UU026a$motor_UPDRS)


UU027<- subset(WorkData,WorkData$subject.==27)
x<-min(UU027$test_time)
y<-max(UU027$test_time)
z<-median(UU027$test_time)
UU027a<-subset(UU027,UU027$test_time==x|UU027$test_time==y|UU027$test_time==z)
UU027a<-UU027a[1:3,c(1,2,3,4,5,6)]
UU027a$mean_total<-mean(UU027a$total_UPDRS)
UU027a$mean_motor<-mean(UU027a$motor_UPDRS)


UU028<- subset(WorkData,WorkData$subject.==28)
x<-min(UU028$test_time)
y<-max(UU028$test_time)
z<-median(UU028$test_time)
UU028a<-subset(UU028,UU028$test_time==x|UU028$test_time==y|UU028$test_time==z)
UU028a<-UU028a[1:3,c(1,2,3,4,5,6)]
UU028a$mean_total<-mean(UU028a$total_UPDRS)
UU028a$mean_motor<-mean(UU028a$motor_UPDRS)

UU029<- subset(WorkData,WorkData$subject.==29)
x<-min(UU029$test_time)
y<-max(UU029$test_time)
z<-median(UU029$test_time)
UU029a<-subset(UU029,UU029$test_time==x|UU029$test_time==y|(UU029$test_time<=z+1 & UU029$test_time>=z-17))
UU029a<-UU029a[1:3,c(1,2,3,4,5,6)]
UU029a$mean_total<-mean(UU029a$total_UPDRS)
UU029a$mean_motor<-mean(UU029a$motor_UPDRS)

UU030<- subset(WorkData,WorkData$subject.==30)
x<-min(UU030$test_time)
y<-max(UU030$test_time)
z<-median(UU030$test_time)
UU030a<-subset(UU030,UU030$test_time==x|UU030$test_time==y|(UU030$test_time<=z+1 & UU030$test_time>=z-10))
UU030a<-UU030a[1:3,c(1,2,3,4,5,6)]
UU030a$mean_total<-mean(UU030a$total_UPDRS)
UU030a$mean_motor<-mean(UU030a$motor_UPDRS)

UU<-rbind(UU01a,UU02a,UU03a,UU04a,UU05a,UU06a,UU07a,UU08a,UU09a,UU010a,
+UU011a,UU012a,UU013a,UU014a,UU015a,UU016a,UU017a,UU018a,UU019a,UU020a,
+UU021a,UU022a,UU023a,UU024a,UU025a,UU026a,UU027a,UU028a,UU029a,UU030a)

UU$Sx<-sex+1
attach(UU)
pairs(motor_UPDRS~total_UPDRS+test_time)



m0<-lm(motor_UPDRS~-1+total_UPDRS)
summary(m0)

m1<-lm(mean_motor~-1+mean_total)
summary(m1)

m2<-lm(motor_UPDRS~-1+total_UPDRS+total_UPDRS:Sx+total_UPDRS:age+total_UPDRS:test_time)
summary(m2)

m3<-lm(motor_UPDRS~-1+mean_total+mean_total:Sx+total_UPDRS:test_time+mean_total:age)
summary(m3)

m4<-lm(motor_UPDRS~-1+mean_total+mean_total:test_time)
summary(m4)

plot(predict(m4),residuals(m4))


 mb01<-bootCase(m4,B=999)
 summary(mb01)

detach(UU)
