* Modelado Estocastico - Universidad de San Andres

* Clase 9 - MODELOS VAR

cd ~/Downloads   
use "Precios_y_Dinero.dta",clear

gen obs=_n                      
// El siguiente comando es muy util como variable tiempo, para trabajar con series de tiempo, cuando necesitamos generar una variable tiempo
tsmktim yearmm, start(2003m1)   // ADO file que hay que instalar por unica vez. Si no lo tienen instalado, les aparece un mensaje de error y el link los lleva a instalarlo 

tsset yearmm

gen infl=IPC/IPC[_n-1] - 1    // Genero variable Inflacion
gen crec_m= M/M[_n-1] - 1     // Genero variable Tasa de Crecimiento de la Base Monetaria

dfgls infl                    // Corroboro que sea estacionaria
dfgls crec_m                  // Corroboro que sea estacionaria

// Para correr VAR debo chequear previamente que las series sean estacionarias 


var infl crec_m, lags(1/2)      // Asi corro un VAR(2) bivariado
varsoc                          // Selection Order Criteria

var infl crec_m, lags(1/8)      // Asi corro un VAR(8) bivariado 
varsoc

var infl crec_m, lags(1/2)
varstable                       // Estabilidad del VAR (que no haya raices unitarias) 

predict residuo1, residuals     // Guardo Residuos
varlmar                         // Testeo si los residuos estan autocorrelacionados

vargranger                      // Testeo por Causalidad en Sentido de Granger

// Decimos que "x" causa en sentido de Granger a "y" si rezagos de "x" explican a "y"


