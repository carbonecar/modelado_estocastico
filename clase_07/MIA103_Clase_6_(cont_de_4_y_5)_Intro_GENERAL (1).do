* Introduccion a STATA - (Do Files) - MIA -  Modelado Estocastico - Universidad de San Andres

* Este DO file es la continuacion de los DO files introductorios de clase 4 y clase 5. Arrancamos en el punto 6 ahora

*con el asterisco ustedes pueden escribir aclaraciones que les sean utiles en un mismo renglon o linea
*Stata no va a leer lo que escriban en la linea despues del asterisco como parte del codigo

clear

*con CLEAR borran si habia una base de datos abierta previamente

cd "C:\Users\fergr\_UdeSA\Stata"

*con cd ... especificamos el directorio desde donde vamos a trabajar (ruta)

// La doble barra cumple el mismo rol que el asterisco pero puede usarse a continuacion de un comando

cd ~/Downloads   // Establezco la carpeta de Descargas como directorio ruta


// Abriendo un Excel

import excel ceo.xlsx, sheet("Hoja1") cellrange(A1:B71) firstrow clear

regress Compensacion_CEO Ganancias   // Corre una regresion por MCO (de var_dep en lista de var_independientes) con constante

rename Compensacion_CEO comp_ceo  // Cambio el nombre a una variable

regress comp_ceo Ganancias   // Corro nuevamente la misma regresion con var_dep renombrada

test (Ganancias=0)   // testeo la hipotesis nula que el beta que multiplica a Ganancias es cero contra la alternativa que es diferente a cero

save ceo   // guardo la base de datos en formato dta (Stata)


// Regresion Multiple 

use ejemplo_casa, clear // Stata va a buscar esta base de datos en el (ultimo) directorio que le acabo de indicar 

regress saleprice lotsize bedroom bath stories driveway recroom basement gas aircond garage desireloc // Regresion por MCO

test (gas=0) (bath=0) // Test F de que estos dos betas son simultaneamente iguales a cero

* Abriendo Excel

import excel Ejemplo_Casa.xls, sheet("HPRICE") firstrow clear

/* Cuando usamos barra y asterisco, Stata entiende que todo lo
 que escribamos
a partir de la barra y asterisco
no es parte del code, 
hasta que cerremos con asterisco y barra (OJO, se empieza con barra asterisco
 y se cierra con asterisco barra), es decir, 
podemos escribir la cantidad de lineas que querramos, o solamente en una parte de una linea como ayuda memoria
sin que Stata lo tome como parte del code. Se va a ver de este color, verde, cuando tengan abierto el do-file */

* VEAMOS ALGUNAS COSAS MUY UTILES

* (1) ¿Como calculamos el valor predicho de y (y sombrero) o los residuos de la ultima regresion corrida?

use ejemplo_casa, clear
regress saleprice lotsize bedroom bath stories driveway recroom basement gas aircond garage desireloc
predict y_sombrero, xb                 /*crea la variable y_sombrero con los valores predichos de y (recta estimada)*/ 
predict res, residual                  /*crea la variable res que sera igual a los residuos */


* (2) ¿Como corremos el test de heterocedasticidad de White?
use Ejemplo_Casa, clear   // Alternativamente, siempre podemos especificar el directorio completo donde se encuentra ul archivo
/* Recordemos que el test de heterocedasticidad de White consiste en regresar los residuos por MCO/OLS 
(Monimos Cuadrados Ordinarios/Ordinary Least Squares) al cuadrado contra todas las variables Explicativas, 
sus cuadrados y sus productos cruzados. De manera que tenemos que tener corrida una regresion cuando 
ejecutemos el comando del test de White para que Stata entienda cuales son los residuos y cuales son las 
variables explicativas sobre las cuales debera correr esa regresion auxiliar con las Xs, sus cuadrados y 
sus productos cruzados y calcular el estadistico del test de White
 
El comando es "estat imtest, white" y al ejecutarlo, Stata reportara el estadistico de White y el p-value correspondiente. 
Recordemos que el estadistico tiene una distribucion chi-cuadrado con un cantidad de grados de libertad igual a 
las pendientes que hay que estimar en la regresion auxiliar, en este caso 71, y se reporta entre parentesis 
donde dice chi2(.) */

regress saleprice lotsize bedroom bath stories driveway recroom basement gas aircond garage desireloc
estat imtest, white


* (3) Tambien podemos correr el test de heterocedasticidad de Breusch Pagan; se ejecuta con este comando:
estat hettest lotsize
/*Recordemos que el estadistico de este test se calcula a partir del ESS (Explained Sum of Squares o Suma de Cuadrados Explicada) 
de una regresion donde la variable dependiente son los residuos al cuadrado de la regresion original 
(es decir, la del ultimo comando, regress) divididos por el RSS sobre "N" de esta regresion
en la(s) variable(s) (varlist) que nosotros sospechamos que genera(n) la heterocedasticidad. 
El estadistico de este test es ESS/2 y tiene una distribucion chi-cuadrado con q grados de libertad, 
donde q es la cantidad de pendientes que hay que estimar en la regresion auxiliar (se excluye la constante). 
En este caso, solo hemos elegido "lotsize" como la unica variable que sospechamos que genera la heterocedasticidad.*/

* (4) Estimacion bajo Heterocedasticidad usando White Heteroskedasticity Standard Errors se corre con la siguiente opcion:

regress saleprice lotsize bedroom bath stories driveway recroom basement gas aircond garage desireloc, vce(robust)

* (5) LOG FILE: imaginense que ustedes trabajan en un paper con un coautor y quieren compartir los resultados de algunas regresiones, 
*  o lo que sea, lo que aparece en la ventana de resultados al ejecutar comandos... o simplemente lo quieren imprimir para leerlo 
*  y revisarlo en otro momento y en papel. Esto se puede lograr abriendo un log file. En Stata 16, pueden abrir uno directamente 
*  desde el icono que esta la derecha del icono de Imprimir, o simplemente, con el comando:


log using "intro.log", replace   // Sin opcion "replace" les permite correrlo una sola vez con ese nombre 

* Prueben de correr todo lo anterior, luego cierren el log (log close) y abran el archivo que acaban de crear
* El log file se abre desde el Explorador de Windows (si usan Windows), con click derecho, "open as Notepad"
* Es un archivo de texto y va a contener todo lo que haya aparecido en la ventana de resultados

log close

// (6) SERIES DE TIEMPO

// Vamos a abrir la base de datos:

use "Precios_y_Dinero_data.dta", clear


// (7) A proposito, las variables que estan en colorado indican que son alfanumericas. Para convertirlas a numericas usamos el comando destring
// se puede hacer para varias variables simultaneamente en la misma linea
// esto es algo que pasa muy seguido cuando bajan una base de datos de internet 

destring mmyy ipc m m_en_ars, replace

// vemos que mmyy tiene caracteres alfanumericos y consecuentemente no es convertida a numerica
// replace hace que las nuevas variables reemplacen a las anteriores. Alternativamente pueden darles otro nombre


// (8) ¿Como crear las series de inflacion y tasa de crecimiento de la base monetaria? ¿Como corremos el test de Dickey Fuller Aumentado?
gen obs=_n				// Genera variable con nombre obs que toma valires 1, 2, 3, etc 
tsset obs   						   // Debemos indicar cual es la variable tiempo  
gen inflacion=(ipc/ipc[_n-1] -1)*100   // Stata entiende por IPC[_n-1] el primer rezago de IPC 
gen crec_bm=(m/m[_n-1] -1)*100
dfuller inflacion, lags(2) trend regress   // Test ADF y "regress" permite ver la regresion

// Alternativamente, se pueden generar rezagos (lags) de esta manera, y crear luego inflacion crecimiento de la base monetaria
gen ipc1=L.ipc		      // Genera el primer rezago de IPC  
gen ipc2=L2.ipc           // Genera el segundo rezago de IPC 
gen inf = (ipc/ipc1 - 1 ) * 100    // Genera la serie inf que pueden corroborar es igual a inflacion

// Tambien pueden crear una serie en diferencias:
gen ipc_dif=D.ipc		      // Genera con el nombre IPC_dif las primeras diferencias de IPC  


// Por ultimo, conviene guardar la base de datos en formato stata (extension dta)

save "Precios_y_Dinero_1.dta", replace

// Para ver la funcion de correlacion y la funcion de correlacion parcial:

ac inflacion

pac inflacion

ac inflacion, level(99)

pac inflacion, level(99)

// Para correr una regresion con errores que son AR(1), podemos manejarnos desde el menu o ejecutar
 
arima inflacion crec_bm, arima(1,0,0)
 
