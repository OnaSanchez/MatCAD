#nombre de mostres
n = 10 

#probabilitat

p = seq(from = 0, to = 1, by = 0.05)
M = 500

#Per l'enunciat:
T = function(n, x){
  (sqrt(n))/(2*(sqrt(n)+n)) + (1/(sqrt(n)+n))*sum(x)
}

#En matrix 1 = rows, 2 = columns

That = matrix(data = NA, nrow = length(p), ncol = M) #o seria posar n????

for( i in 1 : length(p)){
  for ( j in 1 : M){
    s = rbinom(n, j, i) # num of observations, num of trials, prob of success on each trial
    That[i,j] = T(s)
  }
}

Bias = apply(That, MARGIN = 1, FUN = mean) - p #E(T) - p

Var = apply(That, MARGIN = 1, FUN = var)

MSE = Var + Bias^2

plot (p, MSE, )
