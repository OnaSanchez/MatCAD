u0 <- function(x) {pmax(-(x-0.2)*(x-0.8),0)}
cf <- function(x) {2 + cos(x * 2 * pi)} 
M <- 500
dx <- 1/M
mu <- 1/2 #1/4
s <- 1
dt <- mu * dx ^ s
tfinal <- 1

U = c()
Unou = c()
for (m in 1:M) {
  U = c(U, u0(m*dx))
  Unou <- append(Unou, 0)
}

t = 0
res = c()
tim = c()
while (t <= tfinal) {
  for (m in 1:M) {
    if (cf(m) > 0) {
      if (m > 1) {
        Unou[m]=(1-dt/dx*(2*cf(m)-cf(m-1)))*U[m]+dt/dx*cf(m)*U[m-1]
      }
      else{
        Unou[m]=(1-dt/dx*(2*cf(m)-cf(M-1)))*U[m]+dt/dx*cf(m)*U[M-1]
      }
    }
    else{
      if (m < M) {
        Unou[m]=(1+dt/dx*(2*cf(m)-cf(m+1)))*U[m]-dt/dx*cf(m)*U[m+1]
      }
      else{
        Unou[m]=(1+dt/dx*(2*cf(m)-cf(0)))*U[m]-dt/dx*cf(m)*U[0]
      }
    }
  }
  U = Unou
  
  P = 0
  for (i in 1:M) {
    P = P + U[i]*dx
  }
  
  res = append(P, res)
  tim = append(t, tim)
  
  t = t + dt
}
k = floor(1/(dt*10))
comp = c(0:11)*k
C = c()
V = c()
for (i in 1:length(res)) {
  if (i %in% comp) {
    C = c(C,tim[i])
    V = c(V, res[i])
  }
}

plot(C, V)




xv <- (0:(M-1))*dx
cv <- cf(xv)
A <- matrix(rep(0,M*M), nrow=M)
for(i in 1:M) {
  ifelse( cv[i]>0,
          A[i,i] <- 1 - dt/dx * (2*cv[i]-cv[ifelse(i-1>=1,i-1,M)]),
          A[i,i] <- 1 + dt/dx * (2*cv[i]-cv[ifelse(i+1<=M,i+1,1)]) )
}
for(i in 2:M) {
  ifelse( cv[i]>0,
          A[i,i-1] <- cv[i]*dt/dx,
          A[i,i-1] <- 0 )
}
for(i in 1:(M-1)) {
  ifelse( cv[i]>0,
          A[i,i+1] <- 0,
          A[i,i+1] <- -cv[i]*dt/dx )
}
if(cv[1]>0) {
  A[1,M] <- cv[i]*dt/dx
  A[M,1] <- 0
} else {
  A[1,M] <- 0
  A[M,1] <- -cv[i]*dt/dx
}

vapsA <- eigen(A)$values
plot(as.complex(vapsA), xlim=c(-1.5,1.5),ylim=c(-1.5,1.5),pch=20, xlab="Re", ylab="Im")
lines(exp(-(0+1i)*seq(0, 2*pi, by=0.1)), col="purple")

