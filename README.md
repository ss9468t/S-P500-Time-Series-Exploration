# Time Series Analysis of Log-Returns for S&P 500

This project performs a comprehensive time series analysis of the **S&P 500 (GSPC)** index log-returns using daily data from **January 1, 2009, to October 31, 2023**.  

The analysis covers:
- Data extraction
- Log-return transformation
- Statistical properties (mean, skewness, kurtosis)
- Autocorrelation analysis
- Stationarity and normality testing
- ARIMA modeling
- Residual diagnostics

---

## 📊 Dataset
- **Source:** Yahoo Finance via `quantmod` R package  
- **Index:** S&P 500 (^GSPC)  
- **Period:** 2009-01-01 → 2023-10-31  

```r
# Load required package
install.packages("quantmod")
library(quantmod)

# Obtain data
getSymbols("^GSPC", from = '2009-01-01', to = "2023-10-31")
