# Volkswagen_Price_Prediction
Analyze UK Volkswagen used car dataset to predict the price

Having an estimate of the used car price is useful for both buyers and sellers. If the price
is unknown, using figures of similar cars makes it possible to assess the most accurate
estimated price. There are different factors that can determine the quality of a car and
impact its price. Therefore, it is of great interest which factors are more significant to
estimate a used car price.

In this project, information on used cars which are manufactured by Volkswagen (VW)
is used. It contains the price of 2532 used cars and 8 other characteristics of each. The
given information was advertised on the e-commerce platform Exchange and Mart in
the UK in 2020, and it is an extraction of an available data set on Kaggle.
The purpose is to estimate the used car price using different parameters in a
linear regression model and find the most effective factors in determining the price.

In the first step, the data is preprocessed by converting a variable and computing a new
variable since aiming the project objective is more convenient using liters per 100km as
fuel consumption measurement unit, and also age instead of the year that the car was
first registered in. The linear regression model is used to predict a used car price. In
fact, the assumption of normality is examined with Quantile-Quantile plots, and the plot
of residuals versus fitted values is used to examine the homoscedasticity and linearity
assumption. In addition, the Akaike Information Criterion (AIC) is employed as the
best model selection criteria.
