Sucesión ecológica con R
================

![](succession_files/figure-markdown_github/sucesion_stand_dev0_100.png)

(Es recomendable usar **“crtl. click” al pulsar en los enlaces**,
abriéndolos así en pestañas nuevas; la opción no es configurable en
origen en GitHub el momento de escribir esto.)

### Un modelo analítico de sucesión

Estos modelos son simplificaciones de los procesos reales, pero permiten
fijarse en los aspectos básicos de la dinámica de sustitución de
especies, y compararla entre distintas comunidades, o vías de sucesión.

Planteamos un modelo matricial análogo al usado para modelar [dinámica
de poblaciones
estructuradas](https://github.com/quevedomario/eco3r/blob/master/stages.md)
en clases de edad o estadios. Dicho modelo matricial plantea de qué
manera las comunidades cambian de estado a lo largo del pulsos discretos
de tiempo, sin solapamiento.

El ejercicio requiere escasa preparación previa. Usamos las librerías
**popbio** para procesar las probabilidades de sustitución y **diagram**
para dibujar ciclos. No son imprescindibles, todo se podría hacer con R
básico.

Cargando las librerías:

``` r
library(popbio)
library(diagram)
```

Vamos a usar como ejemplo el cambio temporal en un ecosistema cuyos
estadios reconocibles a lo largo de una sucesión ecológica son *espacio
abierto*, *pradera*, *matorral*, y *bosque*<sup>1</sup>. Esencialmente
un esquema de sucesión común a los ecosistemas forestales templados.

#### Matriz de transición

Un modelo como este en el que reconocemos 4 estados (*fases*,
*estadios*, da igual) requiere una matriz cuadrada con cuatro filas y
cuatro columnas, que contienen las probabilidades de transición **del
estado actual (columnas) al siguiente (filas)**.

Para introducir los datos y construir la matriz definimos primero las
etiquetas de los **estados**, almacenándolos en un vector de texto con
`c()`.

``` r
estados <- c("espacio abierto","pradera","matorral","bosque") 
```

A continuación almacenamos las **probabilidades** de transición en otro
vector, numérico en este caso (i.e. valores sin comillas).

``` r
probabilidades <- c(
  0.10, 0.10,   0.10,   0.01,
  0.90, 0.10,   0.00,   0.00,
  0.00, 0.80,   0.10,   0.00,
  0.00, 0.00,   0.80,   0.99
  )
```

Por último, combinamos estados y probabilidades en la **matriz** de
proyección con la función `matrix2()`. Los paréntesis rodeando a esta le
piden a R que nos la enseñe directamente:

``` r
(matriz <- matrix2(probabilidades, estados))
```

    ##                 espacio abierto pradera matorral bosque
    ## espacio abierto             0.1     0.1      0.1   0.01
    ## pradera                     0.9     0.1      0.0   0.00
    ## matorral                    0.0     0.8      0.1   0.00
    ## bosque                      0.0     0.0      0.8   0.99

La matriz muestra probabilidades de sustitución del tiempo *t* al tiempo
*t+1*. Se lee así: - La probabilidad de reemplazo de un parche de
*espacio abierto* por *pradera* es 0.9, \[2,1\]. - La probabilidad de
que una perturbación “reinicie” un parche de *bosque* a *espacio
abierto* es de 0.01, \[1,4\]. - La diagonal de la matriz indica la
probabilidad de que un parche permanezca en el mismo estado entre *t* y
*t+1*. - Los valores de cada columna deben sumar 1.0, ya que recojen el
estado de los parches en un tiempo *t*.

El conjunto de probabilidades de transición definido en la **matriz**
indica un **modelo de facilitación**<sup>2</sup>, aquel en el que
distinguimos especies pioneras, intermedias y tardías. Las primeras
(e.g. leguminosas como *Lupinus* spp., fijadoras de nitrógeno) inician
la sucesión, modificando el contexto abiótico y facilitando la entrada
posterior de especies intermedias.

![](succession_files/figure-gfm/lupinus.jpg)

#### Diagrama de sucesión

Podemos representar gráficamente las transiciones de la matriz con la
intimidante pero útil función `plotmat()`, vista en ejercicios
anteriores
(e.g. <https://github.com/quevedomario/eco3r/blob/master/stages.md>).
`?plotmat` devuelve la explicación del significado de cada argumento de
la
función.

``` r
plotmat(matriz, relsize =0.65, self.cex = 0.5, self.shifty=0.10, self.shiftx = c(0.07,0.16,-0.23,0),
        box.prop = c(0.35,0.25,0.25,0.25), box.type = "round", box.size = 0.14, lwd = 1.2, 
        arr.col ="green", arr.lcol = "black", arr.type = "triangle", txt.col = "blue")
```

<img src="succession_files/figure-gfm/unnamed-chunk-5-1.png" style="display: block; margin: auto;" />

#### Proyecciones

Necesitamos fijar el estado inicial de la simulación. En este ejemplo
partiremos de un paisaje - la foto fija de un ecosistema - en el que
tenemos 500 parches de hábitat, todos en el estado inicial de la
sucesión, *espacio abierto*. Con esa información construimos el
**vector de estado inicial**, **N<sub>0</sub>**; en este caso los 500
parches de hábitat evaluados están en fase *espacio abierto*:

``` r
n0 <- c(500,0,0,0)
```

Para almacenar los resultados de cada intervalo de sustitución
construimos una matriz con tantas filas como intervalos de tiempo
pretendidos, y 4 columnas para los 4 estados. La primera línea del
código a continuación deja definida una matriz llamada **proyecciones**
para 12 intervalos, y de momento vacía.

La segunda define la variable de intervalos de tiempo, hasta 20.

A continuación usamos los nombres de los estados y 12 intervalos de
tiempo para etiquetar las columnas de **proyecciones** con `colnames()`
y las filas con `rownames()`.

``` r
proyecciones <- matrix(nrow = 12, ncol = 4)

tiempo <- seq(from=0, to=20, by=1)

colnames(proyecciones) <- estados
rownames(proyecciones) <- (tiempo[2:13])
proyecciones
```

    ##    espacio abierto pradera matorral bosque
    ## 1               NA      NA       NA     NA
    ## 2               NA      NA       NA     NA
    ## 3               NA      NA       NA     NA
    ## 4               NA      NA       NA     NA
    ## 5               NA      NA       NA     NA
    ## 6               NA      NA       NA     NA
    ## 7               NA      NA       NA     NA
    ## 8               NA      NA       NA     NA
    ## 9               NA      NA       NA     NA
    ## 10              NA      NA       NA     NA
    ## 11              NA      NA       NA     NA
    ## 12              NA      NA       NA     NA

Las proyecciones de estos modelos de sustitución son multiplicaciones
sucesivas de la matriz de probabilidades por el vector de abundancias en
el tiempo *t*, o *vector de estado*. Para automatizar las proyecciones
durante *i* intervalos de sustitución podemos usar un bucle.

Una de las formas de prepararlos en **R** es la función `for()`:

``` r
for (i in 1:12) {
  n0 <- matriz %*% n0
  proyecciones[i,] <- n0
  proyecciones[i,]
  Sys.sleep(0.4)
}

proyecciones
```

    ##    espacio abierto    pradera   matorral   bosque
    ## 1        50.000000 450.000000   0.000000   0.0000
    ## 2        50.000000  90.000000 360.000000   0.0000
    ## 3        50.000000  54.000000 108.000000 288.0000
    ## 4        24.080000  50.400000  54.000000 371.5200
    ## 5        16.563200  26.712000  45.720000 411.0048
    ## 6        13.009568  17.578080  25.941600 443.4708
    ## 7        10.087632  13.466419  16.656624 459.7893
    ## 8         8.618961  10.425511  12.438798 468.5167
    ## 9         7.833494   8.799616   9.584289 473.7826
    ## 10        7.359566   7.930106   7.998122 476.7122
    ## 11        7.095901   7.416620   7.143897 478.3436
    ## 12        6.949078   7.127973   6.647686 479.2753

Ese bucle `for` se lee “*para cada intervalo de tiempo de 1 a 12,
almacena como n0 el resultado de multiplicar la matriz por el
N<sub>0</sub> previo, guarda el resultado en la fila i de proyecciones,
y muestra esa última fila o vector de estado*”<sup>3</sup>.  
En la consola **R** aparecerán los vectores de estado *N<sub>1</sub>* a
*N<sub>12</sub>*.

Para pintar los resultados nos interesa tener en el mismo conjunto de
datos el estado inicial de la sucesión, aquel *N<sub>0</sub>* con 500
parches de *espacio abierto* que ha sido modificado por las iteraciones
del bucle anterior.

El código a continuación construye de nuevo un el vector *inicial*, lo
combina en **todo** con los resultados de **proyecciones**, y elimina
los nombres de las filas (para pintarlo más fácil):

``` r
inicial <- c(500,0,0,0)
todo <- rbind(inicial, proyecciones)
rownames(todo) <- NULL
todo
```

    ##       espacio abierto    pradera   matorral   bosque
    ##  [1,]      500.000000   0.000000   0.000000   0.0000
    ##  [2,]       50.000000 450.000000   0.000000   0.0000
    ##  [3,]       50.000000  90.000000 360.000000   0.0000
    ##  [4,]       50.000000  54.000000 108.000000 288.0000
    ##  [5,]       24.080000  50.400000  54.000000 371.5200
    ##  [6,]       16.563200  26.712000  45.720000 411.0048
    ##  [7,]       13.009568  17.578080  25.941600 443.4708
    ##  [8,]       10.087632  13.466419  16.656624 459.7893
    ##  [9,]        8.618961  10.425511  12.438798 468.5167
    ## [10,]        7.833494   8.799616   9.584289 473.7826
    ## [11,]        7.359566   7.930106   7.998122 476.7122
    ## [12,]        7.095901   7.416620   7.143897 478.3436
    ## [13,]        6.949078   7.127973   6.647686 479.2753

A continuación pintamos el cambio de los parches entre los intervalos
t=0 y t=12. En negro *espacio abierto*, en azul *pradera*, en rojo
*matorral*, y en verde *bosque*.

La proyección de cada tipo de parche está almacenada en cada una de las
columnas de **todo**. `plot()` pinta la primera curva, la de *espacio
abierto*, almacenada en la columna 1 \[,1\], y a continuación añadimos
el resto de curvas a ese primer gráfico con
`lines()`<sup>4</sup>:

``` r
plot(tiempo[1:13], todo[,1], type="l", xlab="intervalos", ylab = "parches", ylim = c(0,500),
     main="")
lines(tiempo[1:13], todo[,2], col="blue")
lines(tiempo[1:13], todo[,3], col="red")
lines(tiempo[1:13], todo[,4], col="green")
```

<img src="succession_files/figure-gfm/unnamed-chunk-10-1.png" style="display: block; margin: auto;" />

El gráfico ilustra una propiedad de estos modelos analíticos: al
multiplicar sucesivamente los vectores de estado por la misma matriz de
transición, se alcanza una *estructura estable*. Es decir, el vector de
estado deja de cambiar por mucho que proyectemos la dinámica. Y esa
estructura se alcanza independientemente de cual sea el estado inicial.
En nuestro ejemplo esa dinámica empieza a ser aparente a partir de
*N<sub>6</sub>*.

Adaptando el código anterior es fácil incluir cambios en las
probabilidades de sustitución. Estas podrían derivarse por ejemplo de
una mayor frecuencia de perturbaciones, que reduciría proporción de
parches en estados tardíos.

#### Referencias y notas

1.  Ejemplo adaptado de Gotelli NJ. 2008. A primer of ecology (AD
    Sinauer, Ed). Sunderland: Sinauer.  
2.  Hay modelos alternativos de reemplazo de especies, esencialmente
    basados en el tipo de control de la dinámica ejercido por las
    especies que colonizan un espacio reiniciado por la perturbación. Al
    menos habrá que tener en cuenta la posibilidad de que las
    colonizadoras no tengan especial influencia en qué se asienta
    después (**modelo de tolerancia**), o que impidan el asentamiento
    de nuevas especies hasta una nueva perturbación (**modelo de
    inhibición**).
3.  En cada repetición **n0** es sustituido por el resultado de
    multiplicar el anterior por la matriz, si bien el contenido queda
    guardado en **proyecciones**. Los bucles `for(){}` son útiles para
    repetir cálculos y almacenar los resultados sucesivos. Entre
    paréntesis llevan siempre la variable que identifica la secuencia
    de repeticiones; entre corchetes, el conjunto de operaciones en
    orden de ejecución. En el ejemplo, `Sys.sleep()` introduce un
    retraso de medio segundo para ver los resultados sucesivos en la
    consola. Para acelerar el código podemos prescindir de la
    visualización de resultados intermedios, y del retraso.  
4.  `tiempo[1:13]` hace referencia a las posiciones primera a
    decimotercera en el vector tiempo, que corresponden a los intervalos
    *t<sub>0</sub>* a *t<sub>12</sub>*.
