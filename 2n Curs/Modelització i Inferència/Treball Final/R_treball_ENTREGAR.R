# Ona Sánchez Núñez
# NIU: 1601181


#EXERCICI 1

# a) Fet en el pdf.

# b) Estimacio per lambda. 

#dades
x = c(4, 1, 4, 2, 1, 1, 2, 1, 2, 2, 1, 1, 1, 1, 1, 5, 1, 3, 2, 1, 1, 2, 1, 2, 
      1, 1, 1, 1, 1, 1, 1, 1, 1, 5, 7, 2, 2, 2, 1, 6, 1, 1, 1, 1, 2, 1, 1, 1, 2, 2, 1,
      1, 1, 1, 2, 1, 1, 2, 5, 2, 1, 1, 2, 11, 1, 1, 2, 1, 3, 2, 1, 1, 1, 1, 1, 1, 1, 1, 2, 3, 7, 1, 1,
      13, 1, 1, 4, 1, 1, 10, 2, 1, 1, 1, 1, 1, 4, 5, 1, 19, 1, 1, 3, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 3, 4,
      2, 1, 1, 2, 1, 4, 1, 1, 8, 2, 3, 8, 1, 3, 4)
n = length(x)

#Funcio log-versemblansa de la Poisson:

logLik.trPoiss = function(lambda, x){
  (-sum(x)*log(lambda)+sum(log(factorial(x)))+n*log((exp(lambda))-1)) #exp(lambda) = e^lambda
}

#Maximitzem la log-versemblansa numericament:

lambda = mean(x) #per l'enunciat sabem que la lambda es la mitjana de dies
lambda
res = nlm( logLik.trPoiss,
       p = c(lambda), #lo que volem que maximitzi
       x,             #dades extres
       hessian = TRUE)
res 

#Com es pot veure al output a la seccio estimate, l'estimacio puntual de lambda es 2.2
est_puntual = res$estimate
est_puntual
#Calculem la informacio de fisher observada (tenim la funcio score calculada a l'apartat a):
#Derivada de la funcio score: -sum(x)/lambda + n*e^lambda / (e^lambda -1)^2
I = -((-sum(x)/est_puntual^2) + (n*exp(est_puntual))/((exp(est_puntual))-1)^2)
arrel = 1/sqrt(I)
Wald = c ( est_puntual - qnorm ( 0.975 ) * arrel , 
           est_puntual + qnorm ( 0.975 ) * arrel )
Wald

# c) L'apartat b demanava un interval de confiansa de Wald del 95%, pel que ja s'ha fet 
# amb un nivell de significacio alpha = 0.05. L'interval de confiansa compren els valors
# de lambda que pertanyen a (1.59, 2.12), com la hipotesis nulla es que lambda = 1
# (valor que es troba fora de l'interval de confiansa), descartem
# la hipotesis nulla, i ens quedem a favor de l'alternativa que diu que lambda es diferent a 1.




#EXERCICI 2

#Estadistic del test observat i el p-valor d'un test per dues poblacions (comparar les mitjanes).

# a) Creem la funcio amb els arguments que cal passar-li i 
# b) Creem el cos de la funcio on fem tots els calculs:


custom.ttest = function(x, y, test.type="two-sided", true.sigma=FALSE, sigma=NULL, alpha=0.05, paired=FALSE){
  t.stat = NULL
  n = length(x)
  m = length(y)
  pvalor = alpha
  # ComparaciÃ³ de variÃ ncies
  var.test = function(x=x, y=y, alpha=alpha, iguals = iguals){ 
    #Hipotesis Nulla --> son iguals
    #Hipotesis alternativa --> son diferents
    Sx2 = var(x)
    Sy2 = var(y)
    #Test statistic:
    t.stat =  Sx2/Sy2#W de la pag 39
    #Test statistic distribution:
    grausx = length(x)-1
    grausy = length(y)-1
    rechazo = qf(1-(alpha/2), grausx, grausy) 

    if(t.stat > rechazo || t.stat < -rechazo){ #si W esta a la region de rechazo la hipotesis nulla es falsa i no son iguals
      iguals = TRUE
    }
    else{
      iguals = FALSE # no podem rebutjar la nula --> son iguals
    }
    
    return (iguals)
  } 
  
  #hipotesis nulla --> mitjanes iguals
  #hipotesis alternativa --> mitjanes diferents
  
  if(true.sigma == TRUE && paired == FALSE){ #si coneixem les variancies poblacionals
    
    t.stat = (mean(x)-mean(y))/sqrt((var(x)/n) + var(y)/m)
    
    if(test.type == "right"){
      pvalor = 1-pnorm(t.stat,0,1)
    } 
    
    else if(test.type == "left"){
      pvalor = pnorm(-t.stat,0,1)
    }
    
    else{
      pvalor = pnorm(-t.stat,0,1) +1 -pnorm(t.stat,0,1)
    }
  }
  
  if(true.sigma == FALSE && paired == FALSE){ #si no coneixem les variances poblaciones
    
    iguals = var.test(x, y, alpha)
    
    if(iguals == TRUE){ #si les variancies son iguals
      Sp = sqrt((((n-1)*var(x)) + (m-1)*var(y))/(n+m-2))
      t.stat = (mean(x)-mean(y))/(Sp*sqrt((1/n)+ (1/m)))
      
      if(test.type == "right"){
        pvalor = 1-pt(abs(t.stat), n+m-2)
      } 
      
      else if(test.type == "left"){
        pvalor = pt(-abs(t.stat), n+m-2)
      }
      
      else{
        pvalor = pt(-abs(t.stat), n+m-2) +1 -pt(abs(t.stat), n+m-2)
      }
    }
    
    else if(iguals == FALSE){ #si les variancies son diferents
      
      t.stat = (mean(x) - mean(y))/sqrt((var(x)/n)+(var(y)/m))
      k = (var(x)/n + var(y)/m)^2/(((var(x)/n)^2/n-1)+((var(y)/m)^2/m-1))
      
      if(test.type == "right"){
        pvalor = 1-pt(abs(t.stat), k)
      } 
      
      else if(test.type == "left"){
        pvalor = pt(-abs(t.stat), k)
      }
      
      else {
        pvalor = pt(-abs(t.stat), k) +1 -pt(abs(t.stat), k)
      }
    }
  }
  
  # Si les dades estan aparellades:
  
  if(paired == TRUE){
      D = sum(x-y)/n
      t.stat = D*sqrt(n)/sd(x-y)
      if(test.type == "right"){
        pvalor = 1-pt(abs(t.stat), n-1)
      } 
      
      else if(test.type == "left"){
        pvalor = pt(-abs(t.stat), n-1)
      }
      
      else if(test.type == "two-sided"){
        pvalor = pt(-abs(t.stat), n-1) +1 -pt(abs(t.stat), n-1)
      }
  }
  
  return (cat(" ------------------- \n" ,
              "test statistic = " , t.stat , "\n" ,   #t.stat = estadistic del test calculat anteriorment
              "p-value = " , pvalor , "\n" ,         #p.value = p-valor calculat anteriorment
              "-------------------"))
}

# c)
#   i)

alpha = 0.05

x = c(115, 112, 107, 119, 115, 138, 126, 105, 104, 115)
y = c(128, 115, 106, 128, 122, 145, 132, 109, 102, 117)
n = length(x)
custom.ttest(x, y, "two-sided", FALSE, NULL, alpha, TRUE)

# Comprovacio:
t.test(x,y,"two.sided", paired=TRUE)

# Justificacio: Assumim que la hipotesis nulla es que la pressio arterial abans es igual
# a la de despres, i la hipotesis alternativa que la pressio canvia. A partir de la funcio
# custom.ttest (comprovant els resultats amb t.test) veiem que el p-valor es 0.0089 (menor a alpha = 0.05)
# per lo que es pot descartar la hipotesis nulla a favor de l'alternativa, i arribem a la 
# conclusio que la pressio arterial de les dones si canvia despres de prendre anticonceptius
# orals. Tambe podem dibuixar la 'region de rechazo' i veure si l'estadistic s'hi troba:

qt(1-alpha/2, n-1) # La 'region de rechazo' es (-infinit, -2.26)u(2.26, infinit) i el
                   # nostre estadistic es -3.32 per lo que veiem, com amb el pvalor, 
                   # que es pot rebutjar la hipotesis nulla.


#   ii)

x = c(137.5, 140.7, 106.9, 175.1, 177.3, 120.4, 77.9, 104.2)
y = c(103.3, 121.7, 98.4, 161.5, 167.8, 67.3)

custom.ttest(x,y)

# Comprovacio:
t.test(x,y,"two.sided")

# Justificacio: Assumim que la hipotesis nulla es que el rendiment en les poblacions A i B
# son iguals, i la hipotesis alternativa que els rendiments son diferents. Veiem amb la funcio
# custom.ttest que el pvalor es 0.62, mentre que alpha es 0.05, per lo que no podem descartar
# la hipotesis nulla a favor de la alternativa (ja que pvalor > alpha). Aixi, arribem a la 
# conclusio que els rendiments de les maquines son iguals. 

# Altres comprovacions extres

custom.ttest(x,y, "rigth")
t.test(x,y,"less")

custom.ttest(x,y, "left")
t.test(x,y,"greater")



#EXERCICI 3


# a) diagrama de dispersio:

#dades
x = c (24.9, 35.0, 44.9, 55.1, 65.2, 75.2, 85.2, 95.2)
y = c (1.1330, 0.9772, 0.8532, 0.7550, 0.6723, 0.6021, 0.5420, 0.5074)

#representacio
plot ( x , y , 
       xlab = "Temperatura" , 
       ylab = "Viscositat" )

#Observem que quan la temperatura augmenta la viscositat disminueix de forma casi lineal,
#per lo que ens podem plantejar si hi ha correlacio entre les dues dades, per assegurar-ho
#o desmentir-ho, calculem la covariancia i la correlacio.

cov ( x , y )
cor ( x , y )

#La correlacio es diferent a 0, per lo que les dades estan relacionades entre elles,
#a mas, com es -0.97 (casi -1) veiem que es pot fer una regressio lineal.


# b) recta de regressio lineal i estimacio per B1:

mod = lm( y ~ x )
summary ( mod )

#Al fer el summary, veiem a l'apartat 'Estimate' els valors de B0 i B1 en aquest ordre.
#Observem que el valor de B1 es -0.0087578, aixo vol dir que el 'predictor' temperatura
#es multiplicara per -0.0087578 quan fem la prediccio de y amb el model de regressio lineal.
#Aixi, B1 es el pendent que indica el canvi de Y de mitjana quan X augmenta.
#Segons aquesta informacio: viscositat = 1.2815107 -0.0087578*temperatura + error.

#Recta de regressio:
B0 = 1.2815107 
B1 = -0.0087578

lines(c(0,100), c(B0,B0+B1*100), lwd = 3, col = "turquoise")


# c) Interval confiansa del 95% per B1

area_rebutjar = qt(0.975, length(y)-1)
S = 0.0007284 # ho sabem amb el summary
arrel = sqrt(length(y))

area1 = B1 - area_rebutjar*S
area2 = B1 + area_rebutjar*S

interval = c(area1, area2)
interval

# Podem descartar directament B1 = 0 perquè el 0 es troba fora de l'interval de 
# confiansa que hem creat per B1.

# d)  y = B0 + B1x
# Pel summary ja sabem que ens hauria de donar 0.96 (Ho veiem on posa Multiple R-squared: 0.9602)

SSmod = sum(((B0+B1*x) - mean(y))^2)
SSres = sum((y - (B0+B1*x))^2)
SSt = SSmod + SSres
R2 = SSmod/SSt
R2

# El coeficient de determinacio del model es la proporcio de variabilitat de y (viscositat) explicada pel
# regressor x (temperatura).
# A nosaltres ens dona 0.9601533, i com es un valor molt proper a 1 podem dir que la gran majoria
# de la variabilitat en y (la viscositat) s'explica pel model de regressio.

# El coeficient de correlacio de Pearson mostra la dependencia lineal que hi ha entre dues variables, 
# de manera que si dona 1, x i y estan perfectament relacionades positivament i si dona -1 negatiu.
# En el nostre cas, pel grafic es veu que tenim una dependencia lineal negativa, de manera que s'apoparia a -1.

# La relacio entre els dos coeficients es que quan s'apropen a 1 (en el cas de Pearson a 1 en valor
# absolut) vol dir que les dues variables estan relacionades linealment entre elles, i si s'apopen al 0 vol dir que
# encara que pot ser que estiguin relacionades, no es de forma lineal.



# e) Estimacio de sigma^2
#    Quan a l'apartat b) fem el summary(mod) veiem que el Residual standard error es 0.04743
#    (que es la estimacio de sigma), per lo que per trobar la estimacio de sigma^2 cal fer:

sigma = summary(mod)$sigma # o fer summary(mod)$sigma
sigma_quadrat = sigma^2
sigma_quadrat # es la estimacio de sigma^2


# f) Prediccio de viscositat per temperatura = 90 graus: 0.4933066
predict (mod, newdata = data.frame( x =  90))

