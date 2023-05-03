u0 <- function(x) {x*(1-x)}
v0 = 0
c = 1
gam = 0.2
M <- 200
gt = 0
dx <- 1/(M)
mu <- 1
s <- 1
dt <- mu * dx ^ s
tfinal <- 10

Un = matrix(0, 1, M)
U0 = matrix(0, 1, M)
U_1 = matrix(0, 1, M)

A = matrix(0, M, M)
D = matrix(0, M, M)

for( m in 1:(M) ){
  U0[m] = u0(m*dx)
  U_1[m] = U0[m]
}
U_1 = t(U_1)
U0 = t(U0)

for( i in 1:(M) ){
  D[i, i] = 1+gam*dt
  
  A[i, i] = 2*(1-mu*mu)+gam*dt
  if( i > 1 ) { A[i, i-1] = mu*mu*c }
  if( i < M ) { A[i, i+1] = mu*mu*c }
}

D = solve(D)
RAZZ = function(Up, U) {
  RES = D%*%(A%*%U-Up)
  return(RES)
}

Energy = function(Up, U){
  ret = c()
  for ( i in 2:(length(U)) ){
    res = ( ((U[i]-Up[i])/dt)**2+((U[i]-U[i-1])/dx)**2 )
    ret = c(ret, res)
  }
  ret = 0.5*sum(ret)* dx
  return(ret)
}

pos = c()
tim = c()

t = 0
E = c()

while (t <= tfinal) {
  Un = RAZZ(U_1, U0)
  
  Un[length(Un)] = 0
  Un[1] = 0
  
  En = Energy(U0, Un)
  
  pos = c(pos, Un[100])
  tim = c(tim,t)
  
  U_1 = U0
  U0 = Un
  
  E = c(E, En)
  
  t = t+dt
}

plot(tim, pos, col = 'purple', type ='l')
plot(tim, E, col = 'blue', type ='l')
###############################################################################