import numpy as np

def funcion_normal(valor,media=0,varianza=1):
    
    """
        Aplica a la variable valor la función de la normal con media y variarianzas
    """
    numerador=-(valor-media)**2
    constante=1/(np.sqrt(2*varianza*np.pi))
    
    return constante* (np.exp((numerador/(2*varianza))))
