rm(list = ls())
library(readxl)
library(sqldf)

stock = read.csv(file.choose())
names(stock)[1]=c("Period")
colnames(stock) = tolower(make.names(colnames(stock)))
attach(stock)
stock_Backup = stock

interest = read_excel(file.choose(), skip = 6)
names(interest)[1]=c("period")
names(interest)[2]=c("treasury")
colnames(interest) = tolower(make.names(colnames(interest)))
attach(interest)
interest_Backup = interest

dollar = read.csv(file.choose())
names(dollar)[1]=c("period")
names(dollar)[6]=c("price")
colnames(dollar) = tolower(make.names(colnames(dollar)))
attach(dollar)
dollar_Backup = dollar
dollar = dollar_Backup

stock$period <- as.Date( as.character(stock$period), "%Y-%m-%d")
interest$period <- as.Date( as.character(interest$period), "%Y-%m-%d")
dollar$period <- as.Date( as.character(dollar$period), "%Y-%m-%d")

good.rows <- ifelse(dollar$price=='null', FALSE, TRUE)
dollar<-dollar[good.rows,]
head(dollar$price)

mydf = data.frame(period = stock$period, price1 = stock$adj.close)
mydf <- sqldf("SELECT period, price1, price as price2 
              FROM mydf
              LEFT JOIN dollar USING(period)")
mydf <- sqldf("SELECT period, price1 as price, price2 as dollar, treasury  
              FROM mydf
              LEFT JOIN interest USING(period)")

mydf <- subset(mydf, !is.na(mydf$treasury))
mydf <- subset(mydf, !is.na(mydf$dollar))
mydf <- subset(mydf, !is.na(mydf$price))
mydf=mydf[rev(order(as.Date(mydf$period))),]
#mydf$period = c(1:2501)

mydf_backup = mydf
mydf = mydf_backup
#Now my data is clean. Lets work on it.
#create deltas for price, dollar, and treasury
for(i in 1:nrow(mydf)){
  for(j in 1:6){
    mydf[i,j+4] = mydf[i+j-1,2]
    #mydf[i,j+10] = mydf[i+j-1,3]
    #mydf[i,j+16] = mydf[i+j-1,4]
  }
}
for(i in 1:nrow(mydf)){
  for(j in 1:6){
    #mydf[i,j+4] = mydf[i+j-1,2]
    mydf[i,j+10] = mydf[i+j-1,3]
    #mydf[i,j+16] = mydf[i+j-1,4]
  }
}
for(i in 1:nrow(mydf)){
  for(j in 1:6){
    #mydf[i,j+4] = mydf[i+j-1,2]
    #mydf[i,j+10] = mydf[i+j-1,3]
    mydf[i,j+16] = mydf[i+j-1,4]
  }
}
mydf <- subset(mydf, !is.na(mydf$price))
mydf <- subset(mydf, !is.na(mydf$dollar))
mydf <- subset(mydf, !is.na(mydf$treasury))
mydf <- subset(mydf, !is.na(mydf$V5))
mydf <- subset(mydf, !is.na(mydf$V6))
mydf <- subset(mydf, !is.na(mydf$V7))
mydf <- subset(mydf, !is.na(mydf$V8))
mydf <- subset(mydf, !is.na(mydf$V9))
mydf <- subset(mydf, !is.na(mydf$V10))
mydf <- subset(mydf, !is.na(mydf$V11))
mydf <- subset(mydf, !is.na(mydf$V12))
mydf <- subset(mydf, !is.na(mydf$V13))
mydf <- subset(mydf, !is.na(mydf$V14))
mydf <- subset(mydf, !is.na(mydf$V15))
mydf <- subset(mydf, !is.na(mydf$V16))
mydf <- subset(mydf, !is.na(mydf$V17))
mydf <- subset(mydf, !is.na(mydf$V18))
mydf <- subset(mydf, !is.na(mydf$V19))
mydf <- subset(mydf, !is.na(mydf$V20))
mydf <- subset(mydf, !is.na(mydf$V21))
mydf <- subset(mydf, !is.na(mydf$V22))

my.stock = data.frame(matrix(, nrow=nrow(mydf),ncol = 0))
my.stock$period = mydf$period
my.stock$p1 = round(c((-diff(mydf$V5, lag = 1)),NA)/mydf$V6 * 100, 2)
my.stock$p2 = round(c((-diff(mydf$V6, lag = 1)),NA)/mydf$V7 * 100, 2)
my.stock$p3 = round(c((-diff(mydf$V7, lag = 1)),NA)/mydf$V8 * 100, 2)
my.stock$p4 = round(c((-diff(mydf$V8, lag = 1)),NA)/mydf$V9 * 100, 2)
my.stock$p5 = round(c((-diff(mydf$V9, lag = 1)),NA)/mydf$V10 * 100, 2)

my.stock$i1 = round(c((-diff(as.numeric(mydf$V11, lag = 1))),NA)/(as.numeric(mydf$V12)) * 100, 2)
my.stock$i2 = round(c((-diff(as.numeric(mydf$V12, lag = 1))),NA)/(as.numeric(mydf$V13)) * 100, 2)
my.stock$i3 = round(c((-diff(as.numeric(mydf$V13, lag = 1))),NA)/(as.numeric(mydf$V14)) * 100, 2)
my.stock$i4 = round(c((-diff(as.numeric(mydf$V14, lag = 1))),NA)/(as.numeric(mydf$V15)) * 100, 2)
my.stock$i5 = round(c((-diff(as.numeric(mydf$V15, lag = 1))),NA)/(as.numeric(mydf$V16)) * 100, 2)

my.stock$d1 = round(c((-diff(as.numeric(mydf$V17, lag = 1))),NA)/(as.numeric(mydf$V18)) * 100, 2)
my.stock$d2 = round(c((-diff(as.numeric(mydf$V18, lag = 1))),NA)/(as.numeric(mydf$V19)) * 100, 2)
my.stock$d3 = round(c((-diff(as.numeric(mydf$V19, lag = 1))),NA)/(as.numeric(mydf$V20)) * 100, 2)
my.stock$d4 = round(c((-diff(as.numeric(mydf$V20, lag = 1))),NA)/(as.numeric(mydf$V21)) * 100, 2)
my.stock$d5 = round(c((-diff(as.numeric(mydf$V21, lag = 1))),NA)/(as.numeric(mydf$V22)) * 100, 2)

round(cor(my.stock[,2:16], use = "complete.obs"), 2)

m1 = lm(my.stock$p1 ~ ., data = my.stock)
summary(m1)

m1 = lm(my.stock$p1 ~ p2 + i1 + d1, data = my.stock)
summary(m1)

my.train <- subset(my.stock, period < as.Date("2018-01-01") )
my.test <- subset(my.stock, period >= as.Date("2018-01-01") )

train.reg1 = lm(p1 ~ p2 + i1 + d1, data = my.train)
summary(train.reg1)
my.test$predict.p1 = predict(train.reg1, my.test)

for(i in 1:190){
  my.test[i, 18] = (my.test[i, 7] * stock[i,6] / 100) + stock[i,6]
  stock[i,8] = my.test[i, 18]
}
names(stock)[8]=c("predicted.adj.close")

#determine the accuracy of the model. 
#Here I am taking difference between true value & predicted value
far.off = data.frame()
for (i in 1:190){
  far.off [i,1] = abs(stock [i,6] - stock [i,8])
  
}
mean(far.off[,1])
