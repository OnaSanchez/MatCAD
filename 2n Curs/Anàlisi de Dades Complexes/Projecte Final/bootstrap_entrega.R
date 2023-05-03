library("readxl")

path="C:/Users/onasa/Documents/2n2nsemestre/Dades Complexes/valorant.xlsx"
data = read_excel(path)
data

#Initial representation of the data:

#Percentages of the favourite weapons for a 23 person sample

guardian = 0
phantom = 0
vandal = 0
sheriff = 0
bucky = 0
shorty = 0
operator = 0
others = 0

for (i in data$`Number associated`){
  if (i==0){
    guardian = guardian + 1
  } else if (i==1){
    phantom = phantom + 1
  } else if (i==2){
    vandal = vandal + 1
  } else if (i==3){
    sheriff = sheriff + 1
  } else if (i==4){
    bucky = bucky + 1
  } else if (i==5){
    shorty = shorty + 1
  } else if (i==6){
    operator = operator + 1
  } else{
    others = others + 1
  }
    
}
#Others is not shown as it has 0% probability
slices <- c(guardian, phantom, vandal, sheriff, bucky, shorty, operator)
lbls <- c("Guardian", "Phantom", "Vandal", "Sheriff", "Bucky", "Shorty", "Operator")
pct <- round(slices/sum(slices)*100)
lbls <- paste(lbls, pct) # add percents to labels
lbls <- paste(lbls,"%",sep="") # ad % to labels
pie(slices,labels = lbls, col=rainbow(length(lbls)),
    main="Favourite weapon in Valorant")


#non-parametric bootstrap

#Extra information with the median
non_param_median = function(x){
  x = median(sample(x, size = length(x), replace = TRUE))
  return (x)
}

stats_median = replicate(1000, non_param_median(data$`Number associated`))
stats_median
mean(stats_median)
median(stats_median)
sd_median = sd(stats_median)
sd_median
CImedian = quantile(stats_median, probs = c(0.025, 0.975))
CImedian
hist(stats_median)
boxplot(stats_median)

#For the mean, histogram and boxplot:
non_param__mean = function(x){
  x = mean(sample(x, size = length(x), replace = TRUE))
  return (x)
}

stats_mean = replicate(1000, non_param__mean(data$`Number associated`))
stats_mean
final_mean = mean(stats_mean)
sd_mean = sd(stats_mean)
sd_mean
CImean = quantile(stats_mean, probs = c(0.025, 0.975))
CImean

boxplot (stats_mean)
hist(stats_mean)

#We see in the boxplot some outliers, now what if we remove from the dataset the values 
#that only appear one time?

path_relevant="C:/Users/onasa/Documents/2n2nsemestre/Dades Complexes/valorant_filtrado.xlsx"
data_relevant = read_excel(path_relevant)
data_relevant

non_param__mean = function(x){
  x = mean(sample(x, size = length(x), replace = TRUE))
  return (x)
}

stats_mean = replicate(1000, non_param__mean(data_relevant$`Number associated`))
stats_mean
mean(stats_mean)
sd_mean = sd(stats_mean)
sd_mean
CImean = quantile(stats_mean, probs = c(0.025, 0.975))
CImean
boxplot (stats_mean)
hist(stats_mean)


#parametric bootstrap
#I am going to use a binomial distribution where the success is to get a vandal
# to see what is the probability for a person you are going against to select
# a vandal (assuming that they choose their favourite weapon)

#For the estimated probability we will use:
p = vandal/length(data$Nickname)
p = 1-(1-p)^5

prob_random_samples = rbinom(1000,20,p)/20
prob_random_samples
mitjana = mean(prob_random_samples)
mitjana

Bias = mitjana-p
Bias

sd(prob_random_samples)

quantile(prob_random_samples, probs = c(0.025, 0.975))

boxplot (prob_random_samples)
hist(prob_random_samples)




