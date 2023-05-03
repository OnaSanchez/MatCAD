
lm(selling_price~poly(year, degree=4))
library("readxl")

path="C:/Users/onasa/Documents/2n2nsemestre/Dades Complexes/cars.xlsx"
data = read_excel(path)


cars_lm <- lm(data$selling_price ~ data$year + data$fuel + data$seller_type + data$transmission + data$owner + data$km_driven, data = data)
View(model.matrix(cars_lm))
model.matrix(cars_lm)
summary(cars_lm)

cars <- lm(data$selling_price~poly(data$year, degree=4))
plot(data$selling_price~data$year)
points(data$year, fitted(cars), col='red', pch=20 )
lines(data$year, fitted(cars), col='red')


plot(data$year, data$selling_price)
fit <- lm(data$selling_price~poly(data$year, degree=4), data=data)
lines(data$year, predict(fit), type="l", col="red", lwd=2)

# We fit a model
selling_price = data$seller_type
year = data$year
cars_poly <- lm(selling_price ~ poly(year,degree=4), data = data)

# We plot the polynomial using predictions
new_data <- data.frame(year=seq(from=1998,to=2020,by=0.1))
predict(cars_poly, new_data)
lines(predict(cars_poly, new_data))
plot(data$year,data$selling_price,col=rgb(0.4,0.4,0.8,0.6),pch=16 , cex=1.3, xlab='Year', ylab='Selling price')
lines(seq(from=1998,to=2020,by=0.1), predict(cars_poly, new_data), type="l", col="red", lwd=2)

# Selling price predictions for years 2007 and 2017
my_preds <- data.frame(year=c(2007, 2017))
predict(cars_poly, my_preds)

# 95% CI
confint(cars_poly, level=0.95)
# Plot of the confidence interval
ci = predict(cars_poly, data.frame(year=seq(from=1998,to=2020,by=0.1)), interval=c("confidence"))
lines(seq(from=1998,to=2020,by=0.1),ci[,2],col="orange",lty=1)
lines(seq(from=1998,to=2020,by=0.1),ci[,3],col="orange",lty=1)


brand = data$brand
brands_data <- subset(data, brand=='Audi' | brand=='Nissan')
boxplot(selling_price~brand, data=brands_data, cex.axis=0.8, xlab='Brand', ylab='Selling price')

fit = lm(selling_price~brands_data$brand, data=brands_data )
summary(aov(fit))
subset_nissan <- subset(data,brand=='Nissan')
subset_audi <- subset(data, brand=='Audi')


t.test(subset_audi$selling_price, subset_nissan$selling_price, alternative = "two.sided", conf.level = 0.95)

subset_nissan <- subset(data,brand=='Nissan')
subset_audi <- subset(data, brand=='Audi')
subset <-subset(data, brand=="Audi" | brand=="Nissan")

var(subset_nissan$selling_price)
var(subset_audi$selling_price)
sqrt(var(subset_nissan$selling_price))
sqrt(var(subset_audi$selling_price))


n1<-length(which(data$brand=="Nissan"))
n2<-length(which(data$brand=="Audi"))

var(subset_nissan$selling_price)*n1+var(subset_audi$selling_price)*n2

df=n1+n2-2
df

sigma=sqrt((var(subset_nissan$selling_price)*(n1-1)+var(subset_audi$selling_price)*(n2-1))/(n1+n2-2))
mean(subset_audi$selling_price)-mean(subset_nissan$selling_price)
num=(sum(subset_nissan$selling_price)/n1-sum(subset_audi$selling_price)/n2)

denom=sigma*sqrt(1/n1+1/n2)
Tstat<-num/denom
2*pt(abs(Tstat),df=81, lower.tail=FALSE)
xx<-pairwise.t.test(subset$selling_price, subset$brand, "none")
pairwise.t.test(subset$selling_price, subset$brand, "none")





