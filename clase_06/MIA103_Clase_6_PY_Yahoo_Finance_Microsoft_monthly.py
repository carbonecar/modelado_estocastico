# -*- coding: utf-8 -*-
"""
Created on Sat Jul 26 08:25:29 2025

@author: fgrosz
"""

import os
import pandas as pd
import yfinance as yf
import statsmodels.api as sm

# Establecer carpeta de trabajo
ruta = r"C:\Users\fgrosz\Downloads"
os.chdir(ruta)

#%% Descargar datos mensuales directamente desde Yahoo Finance

start_date = "2020-06-01"

# Descargar precios mensuales ajustados automáticamente
sp500 = yf.download('^GSPC', start=start_date, interval='1mo', auto_adjust=True)
msft = yf.download('MSFT', start=start_date, interval='1mo', auto_adjust=True)

# Resetear índice y quedarnos con columnas necesarias
sp500 = sp500[['Close']].reset_index()
msft = msft[['Close']].reset_index()

# Renombrar columnas
sp500.columns = ['Date', 'SP500']
msft.columns = ['Date', 'MSFT']

#%% Calcular retornos simples mensuales

# Merge por fecha (último día hábil de cada mes)
merged = pd.merge(sp500, msft, on='Date', how='inner')

# Calcular retornos
merged['SP500_ret'] = merged['SP500'].pct_change()
merged['MSFT_ret'] = merged['MSFT'].pct_change()

# Eliminar primera fila (NaN en retornos) y última fila (puede ser parcial si es el mes actual)
df_reg = merged.iloc[1:-1].copy()

#%% Estimar beta de MSFT (regresión simple)

# Variables
y = df_reg['MSFT_ret']
X = sm.add_constant(df_reg['SP500_ret'])  # intercepto

# Regresión
modelo = sm.OLS(y, X).fit()

# Mostrar resumen
print(modelo.summary())

#%% Exportar base final si querés
merged.to_excel("SP500_MSFT_monthly_returns_direct.xlsx", index=False)
