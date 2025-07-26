// Maestria en Inteligencia Artificial
// Modelado Estocastico

// Ejercitacion 2 - Solucion 1E, 2E y 3

// Ejercicio 1E: generacion de valores aleatorios de la mixtura


clear                    // Borro de la memoria si habia una base de datos abierta
set obs 2000             // Creo base de datos de 2000 observaciones
*set seed 1              // Uso semilla, si quiero comparar con algun compañero
gen t = _n               // Creo la variable t que toma valores  1,2,3,...,2000
gen u=rnormal(-1,3)      // Genero valores aleatorios de una Normal (-1,3)
gen v=rnormal(-1,2)      // Genero valores aleatorios de una Normal (-1,2)
gen w = runiform()       // Genero valores aleatorios de una Uniforme (0,1)
gen mix = u              // Genero la mixtura (mix) como la Normal (-1,3)
replace mix = v if w > 0.4   // Reemplazo el valor de lq mixtura por la otra normal si la uniforme es mayor a 0.4

sum mix, d    // "sum" es la abreviacion de summarize. Reporta los estadisticos descriptivos. La opcion "d" significa "detail"
gen mix_s = (mix-`r(mean)')/`r(sd)'   // Genero la mixtura estandarizada, mix_s


preserve
// Grafico el QQ plot
sort mix_s
gen F=_n/_N
gen z=invnormal(F)
drop if _n==_N
scatter z mix_s
graph addplot line mix_s mix_s  // agrega la recta de 45 grados

restore


// Ejercicio 2E: generacion de valores aleatorios de la mixtura


clear                 
set obs 2000
set seed 1
gen t = _n
gen u=rnormal(1.2,0.3)
gen v=rnormal(-0.8,0.9)
gen w = runiform()
gen mix = u
replace mix = v if w > 0.35

sum mix, d    // "sum" es la abreviacion de summarize. La opcion "d" significa "detail"
gen mix_s = (mix-`r(mean)')/`r(sd)'   // Genero la mixtura estandarizada




sort mix_s
gen F=_n/_N
gen z=invnormal(F)
drop if _n==_N
twoway ///
	(scatter z mix_s, ///
		xline(0, lpattern(solid) lcolor(gs8)) ///
		yline(0, lpattern(solid) lcolor(gs8)) ///
		xline(-3, lpattern(dash) lcolor(gs8)) ///
		xline(+3, lpattern(dash) lcolor(gs8)) ///
		yline(-3, lpattern(dash) lcolor(gs8)) ///		
		yline(+3, lpattern(dash) lcolor(gs8)) ///
		xlabel(, grid) ylabel(, grid)) ///
	(line mix_s mix_s, lcolor(black)), ///
	xlabel(-4 (1) 4, grid) ///
	ylabel(-4 (1) 4, grid) ///
	aspect(1) ///
	legend(off) ///
	title("QQ PLOT")



// Ejercicio 3

cd ~/Downloads                                        // Ruteo de directorio

// Filtro Hodrick y Prescott (HP)
import excel "MIA103_Clase_2.xlsx", sheet("PBI Real USA") cellrange(B11:C106) clear firstrow   // Opcion firstrow se usa si la primera fila contiene el nombre de las variables
rename Año year                                       // Cambio nombre a variable Año
gen log_pbi=ln(GDP)                                   // Genero log del PBI
tsset year                                            // Debo indicarle a Stata cual es mi variable tiempo
tsfilter hp gdp_hp = log_pbi, smooth(100) trend(y_g)  // Aca corremos el filtro HP
tsline gdp_hp                                         // Grafico del componente ciclico
tsline log_pbi y_g                                    // Grafico del componente tendencial y de la serie de datos en logs

// Rolling whatever
//ssc install asrol                                   (hay que instalar este modulo por una unica vez)
// Tienen que instalarlo por unica vez
import excel "MIA103_Clase_2.xlsx", sheet("PBI Real USA") cellrange(B11:C106) clear firstrow   
rename Año year
gen log_pbi=ln(GDP)
tsset year
asrol log_pbi, stat(mean) window(year -5 6)           // Aca genero la rolling window
rename mean_5_log_pbi ygma
gen ycma = log_pbi - ygma

tsline ycma                     // Grafico del componente ciclico
tsline log_pbi ygma             //  Grafico del componente tendencial y de la serie de datos en logs

