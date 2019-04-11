Comunidades
================
Mario Quevedo
Marzo de 2019

Introducción al análisis de comunidades ecológicas en R
-------------------------------------------------------

El título de este tutorial es un ejemplo de la laxitud del término *comunidad*. Rara vez podemos obtener datos de comunidades completas; los datos se referirán más frecuentemente a *taxocenosis*, o a porciones más o menos arbitrarias de una comunidad ecológica local. En este caso tenemos dos conjuntos de datos: invertebrados fluviales en Asturias, y aves en la Sierra Nevada española.

Antes de entrar a analizar datos, es siempre recomendable echarles un vistazo, especialmente si trabajamos con datos recogidos por otros. Para entender la estuctura de los datos que luego cargaremos para el análisis, lo más fácil es abrir **comunidades.xls**, incluido en el archivo comprimido **comunidades.zip**. Incluye varias hojas de cálculo:

-   **esva** contiene datos de abundancia de familias de invertebrados fluviales durante varios muestreos semanales en primavera de 2016, en el [r?o Esva (occidente de Asturias)](https://es.wikipedia.org/wiki/R%C3%ADo_Esva); formaron parte del TFG de Sara Fern?ndez Rodr?guez. Las columnas son los taxones encontrados en las muestras, as? como variables adicionales como pH o turbidez del agua.

-   **semanas** agrega los datos de **esva** por semana y localidad de muestreo.

-   **sierra** contiene parte de los datos utilizados en la Pr?ctica de Aula *Diversidad*; concretamente las abundancias de aves a 5 altitudes en la Sierra Nevada espa?ola.

-   **esva\_vegan**, **semanas\_vegan** y **sierra\_vegan** son versiones simplificadas de las anteriores, conservando solo las abundancias de invertebrados por requisitos de formato de algunas funciones en R.

### Configuraci?n previa

Los procedimientos incluidos a continuaci?n asumen la instalación previa de [R](https://www.r-project.org/) y [RStudio](https://www.rstudio.com/), para trabajar en este último. Instrucciones al respecto se encuentran en el apartado *Configuración* del módulo **Ecología en código abierto** del Campus Virtual.

### Carga de datos

Cambiad la carpeta de trabajo a aquella que contenga los archivos de datos (no es imprescindible, pero por el momento facilita el trabajo). En RStudio, `Session :: Set Working Directory :: Choose Directory...`

A continuaci?n, cargad los datos con la l?nea de c?digo siguiente, o bien haciendo doble *click* sobre el archivo en el explorador.

``` r
load("communities_DATA.RData")
```

El archivo con extensi?n **RData** contiene las hojas de datos (`data.frame` es el t?rmino en la jerga de R).

Para ver los datos ya en **RStudio** podemos usar la pesta?a **Environment**; esta muestra los distintos conjuntos de datos disponibles en memoria, tras cargar el archivo **RData** anterior. Un icono con forma de tabla sirve para mostrar los datos. A medida que obtengamos resultados, estos pasar?n a estar disponibles tambi?n en memoria para ser reutilizados, y aparecer?n en ese listado.

Puede costar acostumbrarse a la presentaci?n cruda de datos en R; para eso tenemos los mismos datos en la hoja de c?lculo **comunidades.xls**. En este caso los datos ya est?n cargados, pero en **RStudio** es sencillo importar datos en varios formatos, incluido el de MS Excel, a trav?s de `File :: Import dataset`.

------------------------------------------------------------------------

### Estructura de comunidades

Las funciones m?s espec?ficas en R est?n incluidas en librer?as adicionales, *packages* en jerga R. Una de esas librer?as, dise?ada espec?ficamente para calcular m?tricas de comunidades, es [**vegan**](https://www.rdocumentation.org/packages/vegan/versions/2.4-2).

Para instalarla pod?is usar los men?s de RStudio (`Tools :: Install Packages`, escribiendo *vegan* en el cuadro de di?logo). Lo mismo se consigue con el c?digo `install.packages("vegan", dependencies = TRUE)`. Este se leer?a en "humano" *instala vegan y otras librer?as de las que dependa para funcionar*.

Una vez instalada, habilitamos la librer?a con:

``` r
library(vegan)
```

#### ?ndices de diversidad

Algunas funciones t?picas de ecolog?a de comunidades son los **?ndices de diversidad**. La l?nea de c?digo siguiente usa la funci?n `diversity` incluida en la libreria de funciones `vegan` para calcular los ?ndices de diversidad de Shannon de cada muestra (fila) de la hoja de datos **esva\_vegan**. Adem?s de calcularlos, los almacena en memoria en un objeto llamado **H**:

``` r
(H <- diversity (esva_vegan, index="shannon"))
```

    ##  [1] 1.5229551 0.0000000 1.3321790 1.7074754 1.4451484 1.9079826 1.6440866
    ##  [8] 1.9032217 1.4556827 1.4819703 1.4278916 1.6449917 0.9002561 1.2624264
    ## [15] 1.7829506 1.2916445 1.5778513 1.4054709 1.5437592 1.0821209 2.0250496
    ## [22] 2.0499721 1.6301058 2.0142427 2.2228320 2.1946404 1.9902080 1.9809018
    ## [29] 2.0026461 1.8218454 1.8729043

Usamos en este caso **esva\_vegan** porque las funciones de an?lisis de comunidades requieren hojas de datos exclusivamente num?ricas, conteniendo solamente las abundancias por tax?n.

A continuaci?n, calculamos y almacenamos los ?ndices de diversidad de Simpson en un objeto llamado **D**.

``` r
D <- diversity (esva_vegan, index="invsimpson")
```

Observar?is que en este caso no vemos los valores de la D de Simpson. Rodear una orden entre par?ntesis, como en el caso anterior, implica mostrar en la consola el resultado, adem?s de guardarlo en memoria. Si queremos ver los valores de diversidad de Simpson, escribimos simplemente `D` en la consola (o los vemos en la pesta?a **Environment**).

Almacenamos tambi?n la riqueza de especies en un objeto llamado **S**, aprovechando la funci?n `specnumber`, que devuelve el n?mero de taxones para cada muestra (fila) de la hoja de datos:

``` r
(S <- specnumber(esva_vegan))
```

    ##  [1]  5  1  4  7  8  9  9 12 10  5  7 12  3  6  8  7 12 10 12  8 15 13 14
    ## [24] 14 19 16 14 14 13 11 17

Usando ahora R como una calculadora, obtenemos la equitatividad en *versi?n Simpson* (se leer?a *asigna a J el resultado de dividir D por S*):

``` r
J <- D/S
```

?C?mo var?a la equitatividad de la comunidad durante el muestreo? Para obtener una primera impresi?n del contenido de los datos podemos *pintar* esa equitatividad que acabamos de calcular frente al ordinal de la semana de muestreo.

El c?digo a continuaci?n se leer?a: *Pinta J frente a la semanda de muestreo, contenida en la columna "semana" de la hoja **esva***. El c?digo a?ade tambi?n un t?tulo al gr?fico, opcional.

``` r
plot (J ~ esva$semana, main="Macroinvertebrados; equitatividad; semanas 13 a 22 de 2016")
```

![](communities_files/figure-markdown_github/unnamed-chunk-7-1.png)

#### Acumulaci?n de taxones en funci?n del esfuerzo de muestreo

Una funci?n para calcular la funci?n de *rarefacci?n* es `specaccum`. El c?digo a continuaci?n calcula la curva a partir de permutar las muestras 100 veces, y la almacena en `tax_acum` (podemos usar cualquier nombre para los objetos creados). A continuaci?n la pinta con `plot`, definiendo las etiquetas de los ejes X e Y con `xlab` `ylab`:

``` r
tax_acum <- (specaccum (esva_vegan,  method="random", permutations = 100)) 
plot (tax_acum, xlab = "muestras", ylab = "familias")
```

![](communities_files/figure-markdown_github/unnamed-chunk-8-1.png) El gr?fico muestra el valor central de la curva de acumulaci?n de especies; las barras indican la variaci?n alrededor de ese valor central. Dicho de otra forma, para cada n?mero de muestras tendremos un promedio de especies esperables, y unos intervalos de confianza resultantes de las 100 permutaciones de los datos.

Observamos en la "comunidad" estudiada la esperable curva asint?tica de acumulaci?n de taxones en funci?n del esfuerzo de muestreo o an?lisis. En este caso es bastante gradual, si bien muestra un cambio de pendiente a partir de 6 - 8 muestras. El esfuerzo de muestreo deber?a ser superior a ese n?mero de muestras para representar adecuadamente la diversidad de la comunidad.

Una interpretaci?n m?s naturalista: 10 muestras obtenidas con pescas de red Surber en un r?o cant?brico encontraron entre 20 y 30 familias distintas de invertebrados de agua dulce.

Es posible tambi?n *pintar* todas las permutaciones en lugar de la media e intervalos de confianza. Se consigue a?adiendo `random = TRUE` a aquella orden `plot`:

``` r
plot (tax_acum, xlab = "muestras", ylab = "familias", random = TRUE)
```

![](communities_files/figure-markdown_github/unnamed-chunk-9-1.png)

#### Acumulaci?n de taxones por individuos

La funci?n `rarecurve` calcula y pinta la acumulaci?n de taxones en funci?n del n?mero de individuos.

``` r
rarecurve(semanas_vegan, sample = 50, col =  c("black", "forestgreen", "blue", "red", "violet", "orange", "navy"),lwd = 1.5, xlab="individuos identificados", ylab="taxones encontrados")
```

![](communities_files/figure-markdown_github/unnamed-chunk-10-1.png) La l?nea vertical marca el tama?o muestral de referencia, especificado en el c?digo con la opci?n `sample=`. las l?neas horizontales muestran la riqueza de especies correspondiente a ese tama?o de muestra de referencia.

Las posibilidades de an?lisis son exhaustivas. Podemos por ejemplo extraer con facilidad la pendiente de las curvas para un determinado n?mero de individuos identificados; 20 y 50 en este caso:

``` r
rareslope(semanas_vegan, sample=c(20,50))
```

    ##            N20        N50
    ## [1,] 0.2765801 0.00000000
    ## [2,] 0.1896223 0.08871895
    ## [3,] 0.1871894 0.07662702
    ## [4,] 0.1533780 0.07192327
    ## [5,] 0.1594760 0.08721711
    ## [6,] 0.1731237 0.07258878
    ## [7,] 0.1379084 0.05808134

Un vistazo a **semanas** ayuda a recordar a qu? datos corresponden esos resultados, presentados por filas.

#### Curvas diversidad-dominancia

Los *rangos de abundancias* o curvas deversidad-dominancia se utilizan en la comparaci?n de comunidades basada en la equitatividad. Comunidades en las que los individuos est?n m?s distribuidos entre distintas especies, en lugar de dominadas por muchos individuos de algunas, presentar?n pendientes menores.

Para que esa comparaci?n no sea meramente cualitativa, *a ojo*, podemos ajustar modelos num?ricos a los datos. La funci?n `radfit` ajusta varios modelos de curvas diversidad-dominancia, incluyendo los vistos en clase *reserva de nicho* (*preemption*) y el de *fracci?n aleatoria o broken-stick* (*null*).

El c?digo a continuaci?n estima con `radfit` que modelo se ajusta mejor a cada una de las 5 altitudes de Sierra Nevada, y los pinta con `plot`.

``` r
modelos_sierra <- radfit (sierra_vegan)
plot (modelos_sierra, xlab="rango de abundancias", ylab="log (abundancia)")
```

![](communities_files/figure-markdown_github/unnamed-chunk-12-1.png)

Una evaluaci?n puramente visual de los datos podr?a llevarnos a interpretar que el panel 1 (1300 m) y el 5 (3100) corresponden a modelos distintos, ya que la comunidad de aves a 1300 metros es m?s rica en especies, y aparentemente m?s equitativa. No obstante, ambos conjuntos de datos se ajustan mejor al modelo de *reserva de nicho*, denominado *preemption* en R.

Es posible usar la misma funci?n con una parte de los datos, por ejemplo una altitud (o fila). La salida a continuaci?n indica el ajuste num?rico de los modelos a los datos abundancia de aves a 1300 m s.n.m., almacenados en la fila 1 de la hoja **sierra\_vegan**. Interpretar esa salida se escapa de los contenidos del curso, pero esencialmente el mejor ajuste se produce cuando la desviaci?n de los datos al modelo es m?nima (*Deviance*):

``` r
(modelo_1300 <- radfit (sierra_vegan [1,]))
```

    ## 
    ## RAD models, family poisson 
    ## No. of species 30, total abundance 794
    ## 
    ##            par1     par2        par3        Deviance AIC      BIC     
    ## Null                                         60.8833 190.8125 190.8125
    ## Preemption  0.14718                           9.0421 140.9713 142.3725
    ## Lognormal   2.6233   1.1922                  31.0554 164.9846 167.7870
    ## Zipf        0.24157 -0.97564                118.3544 252.2836 255.0860
    ## Mandelbrot    Inf   -1.0791e+05  6.7811e+05   8.9850 144.9142 149.1178

`plot (modelo_1300)` pinta los 5 modelos superpuestos a los datos del 1300 m s.n.m. En este caso puede resultar m?s clara una representaci?n en rejilla:

``` r
radlattice (modelo_1300)
```

![](communities_files/figure-markdown_github/unnamed-chunk-14-1.png)

Y el equivalente para 2180 m, cuyos datos est?n en la fila 3 de los datos **sierra\_vegan**:

``` r
(modelo_2180 <- radfit (sierra_vegan [3,]))
```

    ## 
    ## RAD models, family poisson 
    ## No. of species 12, total abundance 385
    ## 
    ##            par1        par2    par3    Deviance AIC     BIC    
    ## Null                                   22.6651  78.7322 78.7322
    ## Preemption  0.29887                     6.5806  64.6477 65.1326
    ## Lognormal   2.8777      1.1844          6.2430  66.3102 67.2800
    ## Zipf        0.3835     -1.1854         27.8673  87.9344 88.9042
    ## Mandelbrot  1.6055e+09 -7.7089  17.138  5.4438  67.5110 68.9657

``` r
radlattice (modelo_2180)
```

![](communities_files/figure-markdown_github/unnamed-chunk-15-1.png)
