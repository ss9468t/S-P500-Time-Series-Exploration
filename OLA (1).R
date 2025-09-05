#importing the dataset
library(xts)
library(quantmod)
library(stats)
library(forecast)
library(tidyverse)
library(tseries)

#Loading	stock	prices	by	symbol
getSymbols("^GSPC", from = '2009-01-01',
           to = "2023-10-31",warnings = TRUE,
           auto.assign = TRUE)
GSPC

#plot adjusted against time-horizon
plot(GSPC$GSPC.Adjusted)
time <- ts(GSPC$GSPC.Adjusted)
plot(time)



#forecast model for adjusted
fcas <- forecast(GSPC$GSPC.Adjusted, h = 200)
plot(fcas)

#arima model
auto.arima(GSPC$GSPC.Adjusted)
gs <- data.frame(GSPC)

#log returns
y <- length(GSPC$GSPC.Adjusted[-1])
Rett <- GSPC$GSPC.Adjusted[-1]/GSPC$GSPC.Adjusted[-y]-1
Rett
ret <- diff(log(GSPC$GSPC.Adjusted))
ret

plot(100*Rett,type = "l",xlab = "Time",ylab = "log_return",col = 2)
lines(100*ret,col = 1,cex = 0.1)


#Summary of log return
summary(ret)

# Cleaning Missing Values
# Cleaning Missing Values
which(is.na(ret))
t_mean <- mean(ret, na.rm = TRUE)
ret[1,1] <- t_mean
print(t_mean)



#Spectrum
?spectrum
raw = spectrum(ret)
View(ret)

#For Kurtosis amd Skewnes and Mean
kurtosis(ret)
skewness(ret)
mean(ret)


#Plot for Smoothing

smooth <- spectrum(ret,spans = c(20,5,20),main = "Smooth",ylim = c(1e-2,1e-5))

#ACF and PACF
Acf(ret)
Pacf(ret)


#Ljung-Box Test and Hypothesis Testing

library(tseries)
Ljung_box <- Box.test(ret,lag = 10, type = "Ljung-Box")
p_value <- Ljung_box$p.value
if (p_value < 0.05){
  print("Reject H0. The Data Exhibits Autocorrelation")
} else{
  print("Fail to Reject H0. There is no significant evidence of any Autocorrelation.")
}

#Dickey fuller

adf_test <- adf.test(ret)

#Test for stationarity using Kpss Test

kpss <- kpss.test(ret)
p_value <- kpss$p.value
if (p_value > 0.05){
  print("Fail to Reject H0. The Data is Stationary")
} else{
  print("Reject H0. The Data is not Stationary")
}

#Normality Test
ja <- jarque.bera.test(ret)
jp_value <- ja$p.value


if (jp_value > 0.05){
  print("Fail to reject H0. Returns Appears to be Normally Distributed")
} else{
  print("Reject H0. Returns do not appear to be Normally Distributed")
}



#Arima Model
model <- auto.arima(ret)

ar_coe <- model$coef[1:2]
ma_coe <- model$coef[(2+1):(2+2)]
print(ar_coe)
print(ma_coe)

#Equation of coefficients

eqn <- paste0("y[t] = ",paste(ar_coeff,collapse = "+"),"*y[t-",1:2,"] + ",
              paste(ma_coeff,collapse = "+"),"e[t-",1:2,"]")
print(eqn)

checkresiduals(model)
fcast <- forecast(model,h = 100,level = c(0,50,95))
plot(fcast)

residuals %>% mean(model)
Acf(residuals)





