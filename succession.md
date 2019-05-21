Sucesión ecológica - modelos cuantitativos con R
================
Abril 2019

![](succession_files/figure-markdown_github/sucesion_stand_dev0_100.png)

#### Configuración previa

El ejercicio requiere escasa preparación previa. Usamos las librerías **popbio** para manipular las probabilidades de sustitución, y **pander** para mejorar la presentación de resultados:

``` r
library(popbio)
library(pander)
```

#### Un modelos analítico de sucesión

Estos modelos son simplificaciones de los procesos reales, pero pueden servir para comprender mejor los procesos que conducen la sustitución de especies, y para comparar la dinámica de distintas comunidades. El modelo analítico de Horn (1981) de sucesión secundaria forestal parte de la composición inicial de adultos de las especies arbóreas, y la proporción de cada especie entre los juveniles. Dicha proporción indicaría la probabilidad de que un adulto de la especie A sea reemplazado por otro de su misma especie, u otra. Cada reemplazo puede ser representado como una transición, con una determinada probabilidad.

El ejemplo a continuación de sucesión secundaria forestal<sup>1</sup> <sup>y</sup> <sup>2</sup> incluye cuatro especies arbóreas norteamericanas: *Betula populifolia* (GB en la imagen), *Nyssa sylvatica* (BG), *Acer rubrum* (RM) y *Fagus grandifolia* (BE).

![](succession_files/figure-markdown_github/sustituciones.jpg)

La matriz contiene las probabilidades de sustitución, en columnas, en un intervalo de tiempo (50 años en el trabajo original de Horn). Así la probabilidad de que *Betula* GB sea sustituido por *Nyssa* BG es 0.36, mientras que la probabilidad de que \* Acer\* RM sea sustituido por *Fagus* BE es 0.31.

Para introducir los datos y construir la matriz podemos definir primero los **nombres** de las especies, almacenándolos en un vector de texto con `c()`. A continuación almacenamos las **probabilidades** de sustitución en otro vector, numérico en este caso (i.e. valores sin comillas). Por último, combinamos ambos objetos en la **matriz** de proyección con `matrix2()`:

``` r
especies <- c("Betula","Nyssa","Acer","Fagus") 

probabilidades <- c(
  0.05, 0.01,   0.00,   0.00,
  0.36, 0.57,   0.14,   0.01,
  0.50, 0.25,   0.55,   0.03,
  0.09, 0.17,   0.31,   0.96
  )

matriz <- matrix2(probabilidades, especies)
pander(matriz)
```

<table style="width:61%;">
<colgroup>
<col width="18%" />
<col width="12%" />
<col width="11%" />
<col width="9%" />
<col width="9%" />
</colgroup>
<thead>
<tr class="header">
<th align="center"> </th>
<th align="center">Betula</th>
<th align="center">Nyssa</th>
<th align="center">Acer</th>
<th align="center">Fagus</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="center"><strong>Betula</strong></td>
<td align="center">0.05</td>
<td align="center">0.01</td>
<td align="center">0</td>
<td align="center">0</td>
</tr>
<tr class="even">
<td align="center"><strong>Nyssa</strong></td>
<td align="center">0.36</td>
<td align="center">0.57</td>
<td align="center">0.14</td>
<td align="center">0.01</td>
</tr>
<tr class="odd">
<td align="center"><strong>Acer</strong></td>
<td align="center">0.5</td>
<td align="center">0.25</td>
<td align="center">0.55</td>
<td align="center">0.03</td>
</tr>
<tr class="even">
<td align="center"><strong>Fagus</strong></td>
<td align="center">0.09</td>
<td align="center">0.17</td>
<td align="center">0.31</td>
<td align="center">0.96</td>
</tr>
</tbody>
</table>

#### Proyecciones

Para saber las abundancias o proporciones de las distintas especies en el futuro, a partir de las probabilidades de sustitución, proyectamos los cambios del parche forestal asumiendo que la composición inicial **N<sub>0</sub>** son 100 abedules *Betula populifolia*. Definimos también un vector de intervalos de **tiempo** con el generador de secuencias `seq()`:

``` r
n0 <- c(100,0,0,0)
tiempo <- seq(from=50, to=300, by=50)
```

Para almacenar los resultados de cada intervalo de sustitución, las **proyecciones**, construimos una matriz con 5 filas (intervalos de tiempo) y 4 columnas (especies), por el momento vacía. Usamos los nombres de las especies y los 5 primeros intervalos de tiempo para identificar las columnas `colnames()` y las filas `rownames()` de **proyecciones**:

``` r
proyecciones <- matrix(nrow = 6, ncol = 4)

colnames(proyecciones) <- especies
rownames(proyecciones) <- tiempo[1:6]

pander(proyecciones)
```

<table style="width:57%;">
<colgroup>
<col width="13%" />
<col width="12%" />
<col width="11%" />
<col width="9%" />
<col width="9%" />
</colgroup>
<thead>
<tr class="header">
<th align="center"> </th>
<th align="center">Betula</th>
<th align="center">Nyssa</th>
<th align="center">Acer</th>
<th align="center">Fagus</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="center"><strong>50</strong></td>
<td align="center">NA</td>
<td align="center">NA</td>
<td align="center">NA</td>
<td align="center">NA</td>
</tr>
<tr class="even">
<td align="center"><strong>100</strong></td>
<td align="center">NA</td>
<td align="center">NA</td>
<td align="center">NA</td>
<td align="center">NA</td>
</tr>
<tr class="odd">
<td align="center"><strong>150</strong></td>
<td align="center">NA</td>
<td align="center">NA</td>
<td align="center">NA</td>
<td align="center">NA</td>
</tr>
<tr class="even">
<td align="center"><strong>200</strong></td>
<td align="center">NA</td>
<td align="center">NA</td>
<td align="center">NA</td>
<td align="center">NA</td>
</tr>
<tr class="odd">
<td align="center"><strong>250</strong></td>
<td align="center">NA</td>
<td align="center">NA</td>
<td align="center">NA</td>
<td align="center">NA</td>
</tr>
<tr class="even">
<td align="center"><strong>300</strong></td>
<td align="center">NA</td>
<td align="center">NA</td>
<td align="center">NA</td>
<td align="center">NA</td>
</tr>
</tbody>
</table>

Para proyectar la dinámica del modelo durante *i* intervalos de sustitución podemos usar un bucle. Una de las formas de prepararlos en **R** es la función `for()`

``` r
for (i in 1:6) {
  n0 <- matriz %*% n0
  proyecciones[i,] <- n0
  pander(proyecciones)
  Sys.sleep(1)
  }
```

El código se lee "*para cada intervalo de tiempo i entre 1 a 6, multiplica matriz por N<sub>0</sub>, y guarda el resultado en la columna i de proyecciones*"<sup>3</sup>. En la consola **R** aparecerá el estado de la matriz en cada intervalo vía `pander(proyecciones)`.

<table style="width:60%;">
<colgroup>
<col width="13%" />
<col width="12%" />
<col width="11%" />
<col width="11%" />
<col width="11%" />
</colgroup>
<thead>
<tr class="header">
<th align="center"> </th>
<th align="center">Betula</th>
<th align="center">Nyssa</th>
<th align="center">Acer</th>
<th align="center">Fagus</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="center"><strong>50</strong></td>
<td align="center">5</td>
<td align="center">36</td>
<td align="center">50</td>
<td align="center">9</td>
</tr>
<tr class="even">
<td align="center"><strong>100</strong></td>
<td align="center">0.61</td>
<td align="center">29.41</td>
<td align="center">39.27</td>
<td align="center">30.71</td>
</tr>
<tr class="odd">
<td align="center"><strong>150</strong></td>
<td align="center">0.3246</td>
<td align="center">22.79</td>
<td align="center">30.18</td>
<td align="center">46.71</td>
</tr>
<tr class="even">
<td align="center"><strong>200</strong></td>
<td align="center">0.2441</td>
<td align="center">17.8</td>
<td align="center">23.86</td>
<td align="center">58.1</td>
</tr>
<tr class="odd">
<td align="center"><strong>250</strong></td>
<td align="center">0.1902</td>
<td align="center">14.15</td>
<td align="center">19.44</td>
<td align="center">66.22</td>
</tr>
<tr class="even">
<td align="center"><strong>300</strong></td>
<td align="center">0.151</td>
<td align="center">11.52</td>
<td align="center">16.31</td>
<td align="center">72.02</td>
</tr>
</tbody>
</table>

Usando los resultados almacenados en **proyecciones** podemos pintar el cambio de abundancia de las 4 especies entre los intervalos 1 y 6, t<sub>50</sub> y t<sub>300</sub>. En negro *Betula*, en azul *Nyssa*, en rojo *Acer*, y en verde *Fagus*:

``` r
plot(tiempo[1:6], proyecciones[,1], type="l", ylim=c(0,70), ylab = "individuos",
     main="Proyección de N0 durante 5 intervalos de sustitución")
lines(tiempo[1:6], proyecciones[,2], col="blue")
lines(tiempo[1:6], proyecciones[,3], col="red")
lines(tiempo[1:6], proyecciones[,4], col="green")
```

![](succession_files/figure-markdown_github/unnamed-chunk-7-1.png)

La proyección de cada especie está almacenada en una fila de **proyecciones**. El código define un gráfico `plot()` con la primera curva, la de los *Betula*, y a continuación añade el resto de curvas a dicho gráfico con `lines()`.

Adaptando el código anterior es inmediato proyectar la sustitución de especies más tiempo, o incluir cambios en las probabilidades de sustitución. Por ejemplo, si perturbaciones recurrentes incrementan un 35% la **probabilidad global de transición a arces** y **disminuyen la de las hayas** en la misma magnitud, ¿cuál es la proporción de arces y hayas tras 6 intervalos de sustitución?

#### Referencias y anotaciones de código

1.  Morin PJ. 2011. Community Ecology, 2nd Edition. Wiley. Tabla 13.2.
2.  Horn HS. 1975. Markovian properties of forest succession. En *Ecology and Evolution of Communities*; Cody ML, Diamond JM (eds.). Harvard University Press, Cambridge, MS.
3.  En cada repetición **n0** es sustituido por el resultado de multiplicar el anterior por la matriz, si bien el contenido queda guardado en **proyecciones**. Los bucles `for(){}` son útiles para repetir cálculos y almacenar los resultados sucesivos. Entre paréntesis llevan siempre la variable que identifica la secuencia de repeticiones; entre corchetes, el conjunto de comandos u operaciones en orden de ejecución. En el ejemplo, `Sys.sleep()` introduce un retraso de un segundo para ver los resultados sucesivos en la consola. Para acelerar el código podemos prescindir de la visualización de resultados intermedios, y del retraso.
