
from statsmodels.tsa.stattools import adfuller 
def test_dickey_fuller(series):
    """Realiza la prueba de Dickey-Fuller aumentado."""
    result = adfuller(series, autolag='AIC')
    print(f'Estadístico ADF: {result[0]}')
    print(f'Valor p: {result[1]}')
    print('Valores críticos:')
    for key, value in result[4].items():
        print(f'  {key}: {value}')

