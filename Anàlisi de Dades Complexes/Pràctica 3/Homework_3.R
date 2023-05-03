#EXERCISE 1
library(Ryacas)
#Introduction of the data
y = c(2, 3, 5, 6, 15, 15, 15, 24, 24, 24, 49, 75, 124, 156, 260, 316, 509, 715, 903, 1394, 1866,
      2702, 3270, 4203, 4704, 5925, 7864, 9937, 11592, 12940, 14230, 15026, 16157, 18773)

t = seq(1,34)
t2 =t*t

#Using glm
#A1
fit = glm(formula = y~t, family=poisson)
summary(fit)
plot(t,y)
lines(t,fit$fitted.values,type="p", col="orange")

#A2
fit = glm(formula = y~t+t2, family=poisson)
summary(fit)
plot(t,y)
lines(t,fit$fitted.values,type="p", col="orange")

#Using nlm
#A1
loglik<-function(beta){
  mu=exp(-beta[1]-beta[2]*t)
  loglik=-sum(-mu + y*log(mu))
  (loglik)}

llike = nlm(loglik,p=c(0,0), hessian=T)
llike$estimate = -llike$estimate
llike$estimate
plot1 = function(t){
  y = exp(llike$estimate[1]+llike$estimate[2]*t)
  return(y)
}

plot(t, y)
points(t,plot1(t), type = 'l', col='orange')


#A2
loglik<-function(beta){
  mu=exp(beta[1]+beta[2]*t+beta[3]*t2)
  loglik=-sum(-mu + y*log(mu))
  (loglik)}

llike = nlm(loglik,p=c(0,0,0), hessian=T)
llike

plot1 = function(t){
  y = exp(llike$estimate[1]+llike$estimate[2]*t+llike$estimate[3]*t2)
  return(y)
}

plot(t, y)
points(t,plot1(t), type = 'l', col='orange')


#Quan para de creixer?
#-->derivem i igualem a 0 per trobar la t
day=-llike$estimate[2]/(llike$estimate[3]*2)
day

#EXERCISE 2
# A0 --> 2
#param[2] --> c
#param[1] --> b

y = c(2, 3, 5, 6, 15, 15, 15, 24, 24, 24, 49, 75, 124, 156, 260, 316, 509, 715, 903, 1394, 1866,
      2702, 3270, 4203, 4704, 5925, 7864, 9937, 11592, 12940, 14230, 15026, 16157, 18773)

t = seq(1,34)
t = t-1 #t starts with 0 

loglik<-function(param){
  mu= ((2*param[2])/(2+(param[2]-2)*exp(-param[1]*t)))
  loglik=-sum(-mu + y*log(mu))
  }

llike = nlm(loglik,p=c(1,1), hessian=T)
llike
param = llike$estimate
param
fit = glm(formula = y~t, family=poisson)


plot1 = function(t){
  y = ((2*param[2])/(2+(param[2]-2)*exp(-param[1]*t)))
  return(y)
}

plot(t, y)
points(t,plot1(t), type = 'l', col='orange')



#Limit de A(t)
x = seq(1,34)
param = c(2,llike$estimate[1],llike$estimate[2])

lim = function(f,x=1,tol=0.0000000000001){
  next.diff=tol
  while(next.diff>=tol){
    next.diff = abs(f(x)-f(x+1))
    x = x + 1
  }
  return(list("Iterations"=x,"Limit"=f(x),"Next Value"=f(x+1)))
}

my.fun <- function(x){
  (param[1]*param[3])/(param[1]+(param[3]-param[1])*exp(-param[2]*x))}
lim(my.fun,1,1e-6)

#####EL LÍMIT DONA C####

#confidence interval
out = nlm(loglik, p=c(1,1), hessian = TRUE)
c = out$estimate[2] #C

hess = out$hessian
hess
# Confidence Intervals
conf.level = 0.95
crit = qnorm((1 + conf.level)/2)
inv.hess = solve(hess)
#param[1] + c(-1, 1) * crit * sqrt(inv.hess[1,1]) #estimar beta
c + c(-1, 1) * crit * sqrt(inv.hess[2,2]) #estimar C


