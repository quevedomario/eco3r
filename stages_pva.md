Estocasticidad en dinámica de poblaciones estructuradas
================

Para este ejercicio son necesarias las librerías **popbio** y
**diagram**

``` r
library(diagram)
library (popbio) 
```

(Con *botón derecho + abrir en nueva pestaña* o *Ctrl click* los enlaces
se abrirán en otra pestaña)  
Este ejercicio desarrolla un análisis de viabilidad para una población
de *Lotus
arinagensis*.

![](stages_pva_draft_files/figure-markdown_github/lotus_arinagensis1.jpg)
La imagen es una captura de pantalla de la información recogida en el
Atlas y Libro Rojo de la Flora Vascular Amenazada de España, [disponible
en
pdf](https://www.miteco.gob.es/es/biodiversidad/temas/inventarios-nacionales/829_tcm30-99330.pdf).

El ejercicio practica la inclusión de la variabilidad ambiental no
predecible, *estocasticidad ambiental*, en los modelos de poblaciones
estructuradas vistos anteriormente en
<https://github.com/quevedomario/eco3r/blob/master/stages.md> y en
<https://github.com/quevedomario/eco3r/blob/master/stages2.md>

El modelo está estructurado en 4 estadios, plántulas y 3 clases de
reproductores. Introducimos el vector de estadios:

``` r
lotus_stages <- c ("plántula", "repro1", "repro2", "repro3")
```

Definimos además dos vectores alternativos de abundancias en t = 0,
*N<sub>0</sub>*; uno con el mismo número de individuos por estadio, y
otro con mayoría del estadio 4, *repro3*:

``` r
lotus_n0 <- c (100,100,100,100)
lotus_n0_alt <- c(10,10,10,370)
```

Introducimos las probabilidades de transición<sup>1</sup>:

``` r
lotus_trans <- c(
  0.000, 0.165, 0.711, 2.215, 
  0.000, 0.000, 0.000, 0.000, 
  0.000, 0.013, 0.013, 0.002,
  0.182, 0.286, 0.436, 0.624
) 
```

Y construimos la matriz de transición combinando estadios y
transiciones:

``` r
lotus_matrix <- matrix2(lotus_trans, lotus_stages)
```

Una vez definido el modelo de la población, podemos empezar a extraerle
información. Por ejemplo, dibujando el ciclo de vida de *L. arinagensis*
con la función `plotmat()`, la cual presenta muchos ajustes (e.g. muchos
*argumentos*) que determinarán el aspecto final del gráfico:

``` r
plotmat(lotus_matrix, relsize =.86, self.cex = 0.5, self.shifty=0.051,
        box.prop = 0.3, box.type = "round" ,box.size = 0.1, lwd = 1, pos =, 
        arr.col = "blue", arr.lcol = "black", arr.type = "triangle",
        main = "")
```

![](stages_pva_files/figure-gfm/unnamed-chunk-6-1.png)<!-- -->

El ciclo de vida facilita la interpretación visual de las transiciones
observadas en la población, y de las diferencias dentro de la misma:
algunos individuos permanecen en el mismo estadio entre t y t + 1; otros
regresan a estadios anteriores; y otros se “saltan” estadios en el
crecimiento. Esas peculiaridades, especialmente habituales en organismos
modulares con modelos basados en tamaño o estadio reproductor, se
modelan eficientemente con estas matrices.

Los cálculos deterministas se extraerían de manera análoga a la vista en
ejercicios anteriores
(<https://github.com/quevedomario/eco3r/blob/master/stages.md> y
<https://github.com/quevedomario/eco3r/blob/master/stages2.md>), desde
los cuales es fácil adaptar el código.

Por ahora con obtener lambda es suficiente, para compararla con los
resultados que incorporen estocasticidad más adelante:

``` r
lambda (lotus_matrix)
```

    ## [1] 1.020247

Para incorporar estocasticidad ambiental una posibilidad es contar con
información sobre la variación de las tasas vitales de la matriz de
transición. En este caso disponemos de datos de tres temporadas de
campo, tres matrices anuales<sup>1</sup>. La matriz de transición
anterior, **lotus\_matrix**, es una matriz promedio de las siguientes:

``` r
lotus_20022003 <- matrix(c(
  0.000, 0.496, 0.972, 1.743,
  0.000, 0.000, 0.000, 0.000,
  0.000, 0.006, 0.000, 0.000,
  0.379, 0.480, 0.540, 0.602
), nrow = 4, byrow = TRUE, dimnames = list(lotus_stages, lotus_stages))

lotus_20032004 <- matrix(c(
  0.000, 0.000, 0.076, 1.002,
  0.000, 0.000, 0.000, 0.000,
  0.000, 0.000, 0.023, 0.006,
  0.167, 0.120, 0.349, 0.569
), nrow = 4, byrow = TRUE, dimnames = list(lotus_stages, lotus_stages))

lotus_20042005 <- matrix(c(
  0.000, 0.000, 1.086, 3.900,
  0.000, 0.000, 0.000, 0.000,
  0.000, 0.032, 0.016, 0.000,
  0.000, 0.258, 0.419, 0.701
), nrow = 4, byrow = TRUE, dimnames = list(lotus_stages, lotus_stages))
```

Una vez introducidas en la memoria de la sesión de R, combinamos las
tres matrices en una lista, formato requerido por la librería `popbio()`
para realizar algunos cálculos:

``` r
lotus_lista <- list(lotus_20022003, lotus_20032004, lotus_20042005)
```

A continuación podemos simular el crecimiento bajo influencia de
estocásticidad ambiental con la función `stoch.projection()`, a partir
de 2 o más matrices de proyección (tenemos 3). El resultado de esa
proyección estocástica lo almacenamos en un objeto
**lotus\_stoch\_proj**. Los argumentos de la función son el tiempo de
proyección `tmax=` y el número de repeticiones `nreps=`:

``` r
set.seed(12345)
lotus_stoch_proj <- stoch.projection (lotus_lista, lotus_n0, tmax=25, nreps=1000)
tail (lotus_stoch_proj)
```

    ##             [,1] [,2]         [,3]      [,4]
    ##  [995,] 708.6796    0 0.0212812949 127.67828
    ##  [996,] 167.5644    0 1.0033793562 140.10900
    ##  [997,] 885.2619    0 0.0000000000 159.12015
    ##  [998,] 113.6824    0 0.0000000000  20.43369
    ##  [999,] 368.3432    0 0.0000000000  66.20733
    ## [1000,] 860.6234    0 0.0003223415 154.69605

La función `tail()`anterior muestra las 6 últimas de las 1000
(`nreps=1000`) proyecciones estocásticas de nuestro conjunto de matrices
de *Lotus arinagensis*. Nos muestra el tamaño de cada estadio a los 25
años (`tmax=25`), sometido a variación ambiental. Las fluctuaciones son
consecuencia de los distintos valores de las transiciones obtenidos en
las tres temporadas de campo, y recogidos en las matrices
**lotus\_20022003**, **lotus\_20032004** y **lotus\_20042005**. Por
ejemplo, el elemento \[4,1\] de las matrices indica la probabilidad de
transición del estadio *plántula* a *repro3* entre t y t+1, y oscila
entre 0 y 0.379. Y en el resultado la abundancia del estadio *plántula*
oscila entre 113.7 (repetición 998) y 885.3 (repetición 997) en las 6
últimas repeticiones de la proyección.

La función `set.seed(12345)` es responsable de que todos obtengamos el
mismo resultado a pesar de “jugar” con números aleatorios. Le dice al
generador de números aleatorios por donde empezar a generar. De no
definirlo onbtendríamos un resultado diferente para cada proyección. Es
decir, proporciona un código repetible. El resultado general, eso sí,
será esencialmente el mismo si el número de repeticiones `nreps=` es
suficientemente grande.

Nos podemos preguntar cómo afecta la estocasticidad ambiental a la tasa
de crecimiento lambda. El valor determinista de la misma `lambda
(lotus_matrix)` era 1.02. la librería **popbio** calcula la tasa de
crecimiento estocástico mediante dos aproximaciones, usando la función
`stoch.growth.rate()`:

  - Una a partir de *simulación*, utilizando en cada repetición una de
    las matrices disponibles en **lotus\_lista**, 3 en este caso.
  - Otra *analítica*, basada en los elementos de esas matrices. Esta se
    llama *aproximación analítica de Tuljapurkar*.

Aparecen identificadas como $sim y $aprox en los resultados:

``` r
(lotus_stoch_r <- stoch.growth.rate (lotus_lista, prob = NULL))
```

    ## [1] Calculating stochastic growth at time 1
    ## [1] Calculating stochastic growth at time 10000
    ## [1] Calculating stochastic growth at time 20000
    ## [1] Calculating stochastic growth at time 30000
    ## [1] Calculating stochastic growth at time 40000
    ## [1] Calculating stochastic growth at time 50000

    ## $approx
    ## [1] -0.004196428
    ## 
    ## $sim
    ## [1] -0.009065402
    ## 
    ## $sim.CI
    ## [1] -0.013909218 -0.004221587

Esos valores ligeramente inferiores a 0 corresponden en realidad a la
tasa intrínseca de crecimiento *r*; para obtener *lambda* tenemos que
usar *e* elevado a la tasa simulada y analítica, respectivamente.
`exp()` es la función que devuelve el resultado de *e<sup>x</sup>*:

``` r
(lotus_lambda_sim <- exp(lotus_stoch_r$sim))
```

    ## [1] 0.9909756

``` r
(lotus_lambda_anal <- exp(lotus_stoch_r$approx))
```

    ## [1] 0.9958124

A partir de ambos aproximaciones a la influencia de la variabilidad
ambiental en la *tasa asintótica de crecimiento lambda* obtenemos
valores inferiores a la *lambda determinista (1.02)*. En este caso de
hecho la incorporación de la estocasticidad deja lambda por debajo de 1,
es decir, **indica una tendencia decreciente** (si bien muy tenue).

### Enlaces, referencias, anotaciones de código

Para abrir los enlaces en otra pestaña, *botón derecho + abrir en nueva
pestaña*, o *Ctrl click*)  
1\. Datos incluidos en Iriondo et al. (Eds). 2009. [Poblaciones en
peligro: viabilidad demográfica de la flora vascular amenazada de
España. Madrid: Ministerio de Medio Ambiente, y Medio Rural y
Marino](https://www.miteco.gob.es/es/biodiversidad/temas/inventarios-nacionales/viabilidaddemografica_tcm30-99752.pdf)