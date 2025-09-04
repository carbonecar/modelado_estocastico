* Modelado Estocastico - Universidad de San Andres

// ADF - DFGLS y Metodologia Box Jenkins

cd ~/Downloads                // Ruteo de directorio

use wheat.dta, clear          // Abro base de datos del precio del trigo
tsset yearmm                  // Indico a Stata que yearmm es mi variable tiempo
tsline wheat_srw              // Grafico la serie de tiempo del precio del trigo srw
gen lws=ln(wheat_srw)         // Creo el logaritmo natural del precio del trigo
gen dlws=D.lws                // Creo la primera diferencia del logaritmo = Retorno log del trigo srw
tsline dlws                   // Grafico los retornos logaritmicos del trigo srw


dfgls dlws                    // Corro un DFGLS (por defecto, con tendencia deterministica)

dfuller dlws, lags(8) trend regress     // Corro el ADF con la cantidad optima de lags segun criterio Ng Perron con tendencia deterministica
dfuller dlws, lags(1) trend regress     // Corro el ADF con la cantidad optima de lags segun MAIC o SB (coinciden) con tendencia deterministica

// Como la tendencia deterministica ano es estadisticamente significativa, correspondería volver a correr todo sin tendencia determinsitica

dfgls dlws, notrend               // Corro DFGLS (sin tendencia deterministica)
dfuller dlws, lags(8) regress     // Corro el ADF con la cantidad optima de lags segun criterio Ng Perron sin tendencia deterministica
dfuller dlws, lags(1) regress     // Corro el ADF con la cantidad optima de lags segun MAIC o SB (coinciden) sin tendencia deterministica

// Hasta aca seria el PASO CERO: corroboramos que nuestra serie de tiempo es estacionaria.

// Se pueden automatizar estos dos pasos usando macro locales: Stata guarda la cantidad optima de lags de los 3 criterios despues de correr dfgls

dfgls dlws                    
dfuller dlws, lags(`r(optlag)') trend regress    // Esto es Ng Perron
dfgls dlws 
dfuller dlws, lags(`r(maiclag)') trend regress   // Esto es Modified Akaike Information Criterion (MAIC)
dfgls dlws 
dfuller dlws, lags(`r(sclag)') trend regress     // Esto es Schwarz Information Criterion (SB)
dfgls dlws 

dfgls dlws, notrend                   
dfuller dlws, lags(`r(optlag)') regress    // Esto es Ng Perron
dfgls dlws 
dfuller dlws, lags(`r(maiclag)') regress   // Esto es Modfied Akaike Information Criterion (MAIC)
dfgls dlws 
dfuller dlws, lags(`r(sclag)') regress     // Esto es Schwarz Information Criterion (SB)
dfgls dlws




// Arrancamos ahora con la metodologia Box-Jenkins: debemos asegurarnos que la serie sea estacionaria

drop if _n>468                // Me quedo con la muestra hasta Dic 2018 (para comparar luego mi estimacion con los datos reales)

// Paso 1: miro la funcion de autocorrelacion (ACF) y la funcion de autocorrelacion parcial (PACF)
// En base a estas hago guesses, o sea, propongo que tipo de ARMA(p,q) es nuestra serie
ac dlws
pac dlws

// Paso 2: Estimacion y seleccion del modelo

arima dlws, arima(1,0,1)
estat ic

arima dlws, arima(1,0,8)
estat ic

arima dlws, ar(1) ma(1,7,8)
estat ic

arima dlws, ar(1) ma(7,8)
estat ic

// En base a los IC, armo una tabla como se muestra en el PDF Clase 7: aca buscamos el menor AIC, el menor Hanan Quinn, el menor SC

// Paso 3: Diagnostico

arima dlws, ar(1) ma(7,8)     // Supongamos que elegi este modelo
predict resid1, residuals     // Guardo los residuos
wntestq resid1                // Test de Pormanteau: bajo H0 los residuos son ruido blanco; en este caso queremos no rechazar H0
estat aroots                  // Corroboro que las inversas de las raices esten en el circulo unitario






