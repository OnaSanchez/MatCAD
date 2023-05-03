#1. Details of the dataset:
library(datasets)
data("EuStockMarkets")
esm = data.frame(EuStockMarkets)
model_full<-lm(DAX~., data=esm)
summary(model_full)

#   Models to be analysed:
model<-update(model_full, .~.-SMI)
summary(model)

model<-update(model_full, .~.-CAC)
summary(model)

model<-update(model_full, .~.-FTSE)
summary(model)

model<-update(model_full, .~.-SMI-CAC)
summary(model)

model<-update(model_full, .~.-SMI-FTSE)
summary(model)

model<-update(model_full, .~.-FTSE-CAC)
summary(model)

library(MASS)

#2.  backward selection using p-value
model<-update(model_full, .~.-SMI)
summary(model)
model<-update(model_full, .~.-CAC)
summary(model)
model<-update(model_full, .~.-FTSE)
summary(model)
model=model_full
summary(model)

#    backward selection using AIC criteria
model_backward <- stepAIC(model_full, trace = TRUE, direction = "backward")
#    forward selection using p-value
colnames(esm)
model_null<-lm(DAX~1, data=EuStockMarkets)
summary(model_null)
model<-update(model_null, .~.+SMI)
summary(model)
model<-update(model_null, .~.+CAC)
summary(model)
model<-update(model_null, .~.+FTSE)
summary(model)
model<-update(model_null, .~.+SMI+CAC)
summary(model)
model<-update(model_null, .~.+SMI+FTSE)
summary(model)
model<-update(model_null, .~.+SMI+CAC+FTSE)
summary(model)

#    forward selection using AIC criteria
model_full<-formula(DAX~SMI+CAC+FTSE)
model_null<-lm(DAX~1, data=esm)
model_backward <- stepAIC(model_null, trace = TRUE, direction = "forward", scope=model_full)

#3. Best possible subset of variables to select the best fit model
library(olsrr)
model<-lm(DAX~SMI+CAC+FTSE, data=EuStockMarkets)
ols_step_all_possible(model)
ols_step_best_subset(model)

library(leaps)
model_subsets<-regsubsets(DAX~SMI+CAC+FTSE, data=EuStockMarkets, nbest=2)
summary(model_subsets)$which

