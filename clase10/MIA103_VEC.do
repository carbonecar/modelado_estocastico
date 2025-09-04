// Modelado Estocastico -  MIA 103 - Universidad de San Andres

cd ~/Downloads                // Ruteo de directorio

// Ejemplo II.5.9 de Carol Alexander: Metodologia Engle-Granger
clear
import excel "Examples_II.5.xls", sheet("EX_II.5.9(a)") cellrange(A1:E2737) firstrow
gen obs=_n
tsset obs
gen ftse=FTSE100/36.879
gen sp=SP500/6.2073
tsline ftse sp
gen sp_pounds=SP500*FX
gen spp=sp_pounds/3.9879858
tsline ftse spp

dfgls ftse, notrend
dfuller ftse, lags(`r(optlag)') regress
dfgls D.ftse, notrend
dfuller D.ftse, lags(`r(optlag)') regress


dfgls spp, notrend
dfuller spp, lags(`r(optlag)') regress
dfgls D.spp, notrend
dfuller D.spp, lags(`r(optlag)')  regress

reg ftse spp
predict res, resid
tsline res

dfuller res, lags(3) noconstant regress  // Usamos opcion noconstant porque los residuos tienen media cero
// los residuos no son estacionarios y consecuentemente estamos frente a un problema de regresion espuria



// Ejemplo II.5.10 de Carol Alexander: Cointegracion en tasa de interes de UK, Metodologia: Tests de Johansen (traza y maximo autovalor)

use UK_rates, clear
gen obs=_n
tsset obs
tsline  mth1 mth2 mth3 mth6 mth9 mth12
// 1. Primero testeamos por raices unitarias cada tasa
// 2. Luego elegimos el número de lags segun alguno de los criterios de seleccion:
varsoc mth1 mth2 mth3 mth6 mth9 mth12
// 3. Testeamos por la cantidad de relaciones de cointegracion
vecrank mth1 mth2 mth3 mth6 mth9 mth12, trend(constant) max           // Trace y Max stat
vecrank mth1 mth2 mth3 mth6 mth9 mth12, trend(constant) max level99   //  al 99%
vecrank mth1 mth2 mth3 mth6 mth9 mth12, trend(constant) max levela    //  al 95% y 99%
// 4. Si encuentro que hay al amenos una relación de cointegracion, estimo el VECM:
vec mth1 mth2 mth3 mth6 mth9 mth12, trend(constant) rank(4)
// 5. Tests de Diagnostico
veclmar                  // Test LM de Autocorrelacion serial
vecnorm, jbera           // Jarque Bera si queremos testear normalidad de los residuos
vecstable                // Estabilidad del VEC


// Usemos solo dos tasas para analizar el caso bivariado: mth1 y mth12
tsline  mth1 mth12
dfgls mth1
dfgls mth12
varsoc mth1 mth12
vecrank mth1 mth12, trend(constant) max levela
vec mth1 mth12, trend(constant) rank(1) lags(2)
veclmar                  
vecnorm, jbera          
vecstable, graph

// Matriz pi = alfa * beta´  (la notacion en clase es la misma que sigue Stata)              
        
matrix list e(alpha)     
matrix list e(beta) 
matrix list e(pi)


// Veamos un caso mas simple: el caso bivariado
// Causalidad en Sentido de Granger en VECM: caso de VARSOC indicando que cantidad optima es de 2 lags
vec mth1 mth12, trend(constant) rank(1) lags(2)
test ([D_mth1]L1._ce1=0) ([D_mth1]LD.mth12=0)    // H0: mth12 no causa en sentido de Granger a mth1
test ([D_mth12]LD.mth1=0) ([D_mth12]L1._ce1=0)   // H0: mth1 no causa en sentido de Granger a mth12


/* Opciones de tendencia en VECM
Fuente: Manual de Stata:   https://www.stata.com/manuals13/tsvec.pdf#tsvec
1)trend(trend): permite trend lineal y cuadrático en las series en niveles 
2)trend(rtrend): excluye solamente la posibilidad de trend en las series en diferencias. "rtrend" = restricted trend. 
3)trend(constant): permite un trend en las series en niveles y que la ecuacion de cointegracion tenga media diferente de cero.
4)trend(rconstant): no hay trend lineal ni cuadratico pero permite que la ecuacion de cointegracion tenga media diferente de cero. "rconstant"=restricted constant
5)trend(none): implica que no hay trend en niveles ni en diferencias y la ecuacion de cointegracion esta restringida a ser estacionaria y tener media igual a cero.

Cuando suele usarse cada una de estas opciones:
1)trend(trend): series que son I(1) y que en diferencias exhiben un trend; podrian ser variables nominales (precios, base monetaria) en momentos de alta inflacion o espiral inflacionaria
2)trend(rtrend): es apropiado para series que son I(1) y que tienen una tendencia, como precios de activos financieros o agregados macroeconomicos(GDP, consumo, empleo)
3)trend(constant): es apropiado para series que son I(1) y que tienen una tendencia, como precios de activos financieros o agregados macroeconomicos(GDP, consumo, empleo)
4)trend(rconstant): se usa con series que son I(1) sin tendencia deterministica, como tasas de interes o tipo de cambio real
5)trend(none): esta opcion no es relevante para trabajos empiricos. 

La diferencia entre 2 y 3 es que en la ecuacion de cointegracion (el residuo de cointegracion) se permite un trend en (2) y no lo permite en (3)
