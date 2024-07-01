# Install and load necessary packages
install.packages('olsrr')
install.packages('ggplot2')
install.packages('car')
install.packages('ggpubr')
install.packages('rstatix')
install.packages('dplyr')
library(stats)  
library(olsrr)
library(ggplot2)
library(car)
library(ggpubr)
library(rstatix)
library(dplyr)

# Set working directory to the script's location (useful for portability)
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

# Load data
vw_data <- read.csv("vw_data.csv", header = TRUE)

# Data preprocessing
vw_data$lp100km <- (100 * 3.785) / (1.609 / vw_data$mpg)
vw_data$age <- 2020 - vw_data$year
vw_data$year <- NULL
vw_data$X <- NULL
vw_data$mpg <- NULL

# Linear regression without log transformation
lm_price <- lm(price ~ ., data = vw_data)
summary(lm_price)

# QQ plot for residuals (without log)
ggplot(data = as.data.frame(lm_price$residuals), aes(sample = lm_price$residuals)) + 
  geom_qq(color = "black") +
  geom_qq_line(color = "blue") +
  labs(y = "Residuals", x = "Theoretical Quantiles (Price Model)") +
  theme_bw(base_size = 14) +
  theme(axis.text = element_text(size = 14), axis.title = element_text(size = 16))

# Residuals vs Fitted plot (without log)
ggplot(vw_data, aes(y = residuals(lm_price), x = fitted(lm_price))) +
  geom_point() + 
  geom_abline(intercept = 0, slope = 0, col = "blue") +
  labs(y = "Residuals", x = "Fitted Values") +
  theme_bw(base_size = 14) +
  theme(axis.text = element_text(size = 14), axis.title = element_text(size = 16))

# Linear regression with log transformation
vw_data$logprice <- log(vw_data$price)
vw_data$price <- NULL

lm_logprice <- lm(logprice ~ ., data = vw_data) 
summary(lm_logprice)

# QQ plot for residuals (with log)
ggplot(data = as.data.frame(lm_logprice$residuals), aes(sample = lm_logprice$residuals)) + 
  geom_qq(color = "black") +
  geom_qq_line(color = "blue") +
  labs(y = "Residuals", x = "Theoretical Quantiles (Log Price Model)") +
  theme_bw(base_size = 14) +
  theme(axis.text = element_text(size = 14), axis.title = element_text(size = 16))

# Residuals vs Fitted plot (with log)
ggplot(vw_data, aes(y = residuals(lm_logprice), x = fitted(lm_logprice))) +
  geom_point() + 
  geom_abline(intercept = 0, slope = 0, col = "blue") +
  labs(y = "Residuals", x = "Fitted Values") +
  theme_bw(base_size = 14) +
  theme(axis.text = element_text(size = 14), axis.title = element_text(size = 16))

# Best Subset Selection using AIC
stepwise_AIC <- ols_step_all_possible(lm_logprice)
idx_AIC = which.min(stepwise_AIC$result$aic)
AIC<-min(stepwise_AIC$result$aic)

variables_in_aic <- stepwise_AIC$result$predictors[idx_AIC] # "model transmission mileage fuelType tax engineSize lp100km age"
variables_in_aic

lm_AIC <- lm(logprice ~ model +transmission +mileage +fuelType +tax 
             +engineSize +lp100km +age, data = vw_data) 
summary(lm_AIC)
format(lm_AIC$coefficients, scientific = FALSE)



# QQ plot for residuals (AIC model)
ggplot(data = as.data.frame(lm_AIC$residuals), aes(sample = lm_AIC$residuals)) + 
  geom_qq(color = "black") +
  geom_qq_line(color = "blue") +
  labs(y = "Residuals", x = "Theoretical Quantiles (AIC Model)") +
  theme_bw(base_size = 14) +
  theme(axis.text = element_text(size = 14), axis.title = element_text(size = 16))

# Residuals vs Fitted plot (AIC model)
ggplot(vw_data, aes(y = residuals(lm_AIC), x = fitted(lm_AIC))) +
  geom_point() + 
  geom_abline(intercept = 0, slope = 0, col = "blue") +
  labs(y = "Residuals", x = "Fitted Values") +
  theme_bw(base_size = 14) +
  theme(axis.text = element_text(size = 14), axis.title = element_text(size = 16))


# Confidence Intervals
conf <- confint(lm_AIC, level = 0.95)

# Variance Inflation Factors (VIF)
vif <- vif(lm_AIC)


# Summary
summary_data <- list(
  lm_price_summary = summary(lm_price),
  lm_logprice_summary = summary(lm_logprice),
  lm_AIC_summary = summary(lm_AIC),
  AIC_min = min(stepwise_AIC$result$aic),
  variables_in_AIC_model = variables_in_aic,
  confidence_intervals = conf,
  vif = vif
)
summary_data

