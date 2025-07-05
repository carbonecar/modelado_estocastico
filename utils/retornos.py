import numpy as np

def retorno_logaritmico(p_final=None,p_inicial=None,retorno=None):
    """
        Despeja la variable se envían none. 
        retorno: es el retorno del periodo expresado como coeficiente
        p_final: es el precio final del activo
        p_inicial: es el precio inicial del activo
    """

    if p_final is None: 
        return np.exp(retorno)*p_inicial
    
    if p_inicial is None: 
        return p_final/(np.exp(retorno))
    
    if retorno is None: 
        return np.log(p_final/p_inicial)
    

