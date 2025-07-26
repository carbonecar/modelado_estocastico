import numpy as np

def funcion_normal(valor,media=0,varianza=1):
    
    """
        Aplica a la variable valor la función de la normal con media y variarianzas
    """
    numerador=-(valor-media)**2
    constante=1/(np.sqrt(2*varianza*np.pi))
    
    return constante* (np.exp((numerador/(2*varianza))))


def funcion_densidad_mixture(valor,media_1,media_2,varianza_1,varianza_2,peso_1,peso_2):
    return funcion_normal(valor,media_1,varianza_1)*peso_1+funcion_normal(valor,media_2,varianza_2)*peso_2

    