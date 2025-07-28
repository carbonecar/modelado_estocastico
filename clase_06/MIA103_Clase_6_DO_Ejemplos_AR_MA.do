* MIA103 - Modelado Estocastico

// (1) Como generamos un AR(1) en Stata:

clear
set obs 200     // Creo una base de datos de 200 observaciones
gen t = _n      // Creo la variable t que va a tomar valores 1,2,...,200
tsset t         // Le indico a Stata cual es mi variable tiempo

* Defino Parámetros
scalar rho = 0.7
scalar sigma = 1

* Genero un ruido blanco normal con media 0 y desvio sigma (=1)
gen e = rnormal(0, sigma)

// Creo el que va a ser mi proceso AR(1)
gen y = .

* Primer valor (puede ser cero o e[1])
replace y = e if t == 1

* Genero el proceso AR(1)
forvalues i = 2/200 {
    replace y = rho * y[_n-1] + e in `i'
}

* Serie de tiempo de y
tsline y

* Funcion de Autocorrelacion (ACF) y Funcion de Autocorrelacion Parcial (PACF)
ac y, saving(ac1, replace)
pac y, saving (pac1, replace)
graph combine ac1.gph pac1.gph



// (2) Como generamos un AR(2) en Stata:



clear
set obs 200                    // Cantidad de observaciones
gen t = _n                     // Variable de tiempo
tsset t                        // Declarar datos de series temporales

* Parámetros
scalar phi1 = 0.6              // rho(1) que lo llamo phi 1
scalar phi2 = -0.3             // rho(2) que lo llamo phi 2
scalar sigma = 1               // Desvío estándar 

* Genero un ruido blanco normal con media 0 y desvio sigma (=1)
gen e = rnormal(0, sigma)

* Creo el AR(2)
gen y2 = .

* Asignar los primeros dos valores (pueden ser cero o aleatorios)
replace y2 = e in 1
replace y2 = phi1 * y[_n-1] + e in 2

* Generar la serie AR(2)
forvalues i = 3/200 {
    replace y2 = phi1 * y[_n-1] + phi2 * y[_n-2] + e in `i'
}

* Serie de tiempo de y2
tsline y2

* Funcion de Autocorrelacion (ACF) y Funcion de Autocorrelacion Parcial (PACF)
ac y2, saving(ac2, replace)
pac y2, saving (pac2, replace)
graph combine ac2.gph pac2.gph




// GENERO un MA(1)

clear
set obs 200                    // Número de observaciones
gen t = _n                     // Variable de tiempo
tsset t                        // Declarar como serie temporal

* Parámetros
scalar theta1 = 0.8
scalar sigma = 1

* Generar ruido blanco
gen e = rnormal(0, sigma)

* Inicializar la variable de la serie MA(1)
gen y3 = .

* Primer valor: sin rezago disponible
replace y3 = e in 1

* A partir de t=2: y_t = e_t + theta * e_{t-1}
forvalues i = 2/200 {
    replace y3 = e + theta1 * e[_n-1] in `i'
}

* Serie de tiempo de y3
tsline y3

* Funcion de Autocorrelacion (ACF) y Funcion de Autocorrelacion Parcial (PACF)
ac y3, saving(ac3, replace)
pac y3, saving (pac3, replace)
graph combine ac3.gph pac3.gph

// GENERO un MA(4)

clear
set obs 250                        // Asegurate de tener suficientes observaciones
gen t = _n
tsset t

* Parámetros del MA(4)
scalar theta1 = 0.6
scalar theta2 = -0.4
scalar theta3 = 0.3
scalar theta4 = 0.2
scalar sigma = 1

* Generar ruido blanco normal
gen e = rnormal(0, sigma)

* Generar errores rezagados
gen e1 = L1.e
gen e2 = L2.e
gen e3 = L3.e
gen e4 = L4.e

* Inicializar variable
gen y4 = .

* Desde t=5 en adelante, se puede calcular y_t = e_t + sum(theta_i * e_{t-i})
forvalues i = 5/250 {
    replace y4 = e + theta1*e1 + theta2*e2 + theta3*e3 + theta4*e4 in `i'
}
* Serie de tiempo de y4
tsline y4

* Funcion de Autocorrelacion (ACF) y Funcion de Autocorrelacion Parcial (PACF)
ac y4, saving(ac4, replace)
pac y4, saving (pac4, replace)
graph combine ac4.gph pac4.gph


// AHORA GENEREMOS UN ARMA(1,1)

clear
set obs 250
gen t = _n
tsset t

* Parámetros del ARMA(1,1)
scalar phi = 0.5
scalar theta = 0.8
scalar sigma = 1

* Generar el ruido blanco
gen e = rnormal(0, sigma)

* Creo el ARMA(1,1)
gen y5 = .

* Establecer valores iniciales
replace y5 = e in 1


* Generar la serie ARMA(1,1)
forvalues i = 2/250 {
    replace y5 = phi * y[_n-1] + e + theta * e[_n-1] in `i'
}

* Serie de tiempo de y4
tsline y5

* Funcion de Autocorrelacion (ACF) y Funcion de Autocorrelacion Parcial (PACF)
ac y5, saving(ac5, replace)
pac y5, saving (pac5, replace)
graph combine ac5.gph pac5.gph
