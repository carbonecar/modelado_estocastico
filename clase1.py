import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import scipy.stats as stats
import statsmodels.api as sm







def funcion_normal(valor, media=0, varianza=1):
    numerador=-(valor-media)**2
    constante=1/(np.sqrt(2*varianza*np.pi))
    
    return constante* (np.exp((numerador/(2*varianza))))
def g(x):
    return (1 / np.sqrt(8 * np.pi)) * np.exp(-((x + 1.5)**2) / 8)

datos=np.arange(-8,8.1,0.1,dtype=float)
df_datos=pd.DataFrame(datos,columns=['serie'])

df_datos['distribucion_z']=df_datos['serie'].apply(funcion_normal,media=0,varianza=1)
df_datos['distribucion_g']=df_datos['serie'].apply(g)

print(df_datos)




print(g(8))
print(funcion_normal(8,-1.5,4))