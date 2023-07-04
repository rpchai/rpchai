n <- as.integer(readline(prompt = "Enter no of Employee"))
EmpId <- vector(mode="character", length= n)
EmpName <- vector(mode="character", length= n)
DOJ <- vector(mode="character", length= n)
EmpCode <- vector(mode="numeric",length = n)
Desig <- vector(mode="character",length = n)
Dept <- vector(mode="character",length = n)


print("Enter EmpId")
for (i in 1:n)
  EmpId[i] <- as.character(readline())
print("Enter EmployeeName")
for (i in 1:n)
  EmpName [i] <- readline()
print("Enter DOJ" )
for (i in 1:n)
  DOJ[i] <- (readline())
print("Enter EmployeeCode" )
for (i in 1:n)
  EmpCode[i] <- as.integer(readline())
print("Enter Designation" )


for (i in 1:n)
  Desig[i] <- (readline())
print("Enter Dept" )
for (i in 1:n)
  Dept[i] <- (readline())

Emp <- data.frame(EmpId,EmpName,EmpCode,Desig,Dept,DOJ)
print("The Employee detials are as follows")
print(Emp)



write.csv(Emp,"p22.csv")

readStudent=read.csv("p22.csv")
readStudent

print("Enter a new row")
x<- data.frame(4,"d",44,"xx","r","04-04-2022")



write.table(x,"p22.csv",col.names = FALSE, append = T,row.names= T, quote= FALSE, sep = ",")
readStudent=read.csv("p22.csv")
readStudent

