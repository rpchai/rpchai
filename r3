data()
head(mtcars)


row <- nrow(mtcars)
col <- ncol(mtcars)
print("no of row")
print(row)
print("no of col")
print(col)

d<- data.frame(mtcars)
print(d)
automatic <-0
manual <-0
x<-nrow(mtcars)
for (i in 1:x)
  ifelse( d[i,9] == 1, automatic <- automatic + 1, manual <- manual +1)
ifelse (automatic > manual,
        print("There are more automatic transmission type"),
        print("There are more manual transmission type") )


hp <- d[,4]
wt <- d[,6]
scatter.smooth(hp,wt)


am<- as.integer(d$am)
cyl<- as.integer(d$cyl)
vs<- as.integer(d$vs)
newmtc<-data.frame(am, cyl, vs)
print(newmtc)
subset(d, cyl<5)
