* Introduccion a STATA - (Do Files) - MIA -  Modelado Estocastico - Universidad de San Andres

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

* ¿Como calculamos el valor predicho de y (y sombrero) o los residuos de la ultima regresion corrida?

use ejemplo_casa, clear
regress saleprice lotsize bedroom bath stories driveway recroom basement gas aircond garage desireloc
predict y_sombrero, xb                 /*crea la variable y_sombrero con los valores predichos de y (recta estimada)*/ 
predict res, residual                  /*crea la variable res que sera igual a los residuos */

