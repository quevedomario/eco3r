Modelos de poblaciones estructuradas. Análisis determinista 1
================
Marzo de 2019

### Librerías utilizadas

``` r
library (popbio)
library(diagram)
library(pander)
```

### Introducción

Trabajamos con poblaciones en las que los individuos presentan características *a priori* contrastadas desde el punto de vista de la dinámica de la población, asociadas a su edad o estado fisiológico, ya sea por contribuir de forma diferencial a la reproducción o por presentar diferentes supervivencias. En líneas generales los modelos de poblaciones estructuradas los podemos representar mediante ciclos de vida:

![](stages_files/figure-markdown_github/life_cycle_stage.png)

Ese esquema genérico muestra una población modelada a partir de 4 tipos de individuos, las "cajas", agrupados en clases de edad o estadios. Las flechas indican las transiciones posibles entre clases o estadios. A ese ciclo de vida le correspondería la visión numérica aportada por las matrices de transición:

![](stages_files/figure-markdown_github/structured_matrices.png)

La primera fila de las matrices de transición, ya sean de edades (dcha.) o de estadios (izda.), muestra el *esquema de fecundidad*, expresada como promedio de individuos contribuidos al momento *t+1*, producidos por cada individuo presente en el momento *t*. El resto de valores distintos de cero en la matriz representan probabilidades de supervivencia entre *t* y *t+1*, ya sea *permaneciendo* en el mismo estadio, e.g. *P<sub>2</sub>* en la matriz de estadios, o *creciendo* al siguiente, e.g. *G<sub>3</sub>* en estadios o *S<sub>2</sub>* en edades.

### Matriz de proyección (estadios)

Para el ejercicio usamos datos de un modelo estructurado en estadios de una población de orcas *Orcinus orca*. Los datos están incluidos en la librería `popbio` (Caswell 2001)<sup>1,2</sup>.

El código a continuación carga en memoria los datos **whale**, y visualiza a continuación la matriz. la visualización incluye un pequeño truco estético: la función `pander()` rodeando al conjunto de datos devuelve una matriz con un formato más enriquecido útil especialmente para la producción de informes en pdf o html; es opcional:

``` r
data (whale)
pander (whale)
```

<table style="width:83%;">
<colgroup>
<col width="23%" />
<col width="15%" />
<col width="15%" />
<col width="12%" />
<col width="16%" />
</colgroup>
<thead>
<tr class="header">
<th align="center"> </th>
<th align="center">yearling</th>
<th align="center">juvenile</th>
<th align="center">mature</th>
<th align="center">postreprod</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="center"><strong>yearling</strong></td>
<td align="center">0</td>
<td align="center">0.0043</td>
<td align="center">0.1132</td>
<td align="center">0</td>
</tr>
<tr class="even">
<td align="center"><strong>juvenile</strong></td>
<td align="center">0.9775</td>
<td align="center">0.9111</td>
<td align="center">0</td>
<td align="center">0</td>
</tr>
<tr class="odd">
<td align="center"><strong>mature</strong></td>
<td align="center">0</td>
<td align="center">0.0736</td>
<td align="center">0.9534</td>
<td align="center">0</td>
</tr>
<tr class="even">
<td align="center"><strong>postreprod</strong></td>
<td align="center">0</td>
<td align="center">0</td>
<td align="center">0.0452</td>
<td align="center">0.9804</td>
</tr>
</tbody>
</table>

En el modelo la población está dividida en individuos de primer año **yearling**, juveniles no reproductores **juvenile**, individuos reproductores **mature**, y postreproductores **postreprod**. Este último estadio es muy peculiar: muy pocas especies en la naturaleza conservan aquellos individuos que han dejado de contribuir a la reproducción<sup>3</sup>.

No es una sorpresa que **yearling** no contribuya a la reproducción, y tampoco lo será en el caso de **postreprod**, definidos precisamente por haber alcanzado la menopausia. Algo más sorprendente será la pequeña proporción de individuos a priori juveniles que sí contribuyen; es el valor contenido en la celda \[1, 2\]. Los valores de las filas 2, 3 y 4 representan probabilidades de supervivencia permaneciendo en el mismo estadio, e.g. `whale[2,2]`, o pasando al siguiente `whale[3,2]`. En general, las supervivencias son muy altas y la fecundidad baja, como corresponde a un predador apical.

### Diagrama de transiciones con `plotmat()`

Los ciclos de vida como el genérico del esquema anterior pueden ser útiles para entender visualmente las transiciones entre clases o estadios, e incluso como paso previo antes de plantear un modelo estructurado. Seguramente sean fáciles casi siempre de pintar a mano<sup>5</sup>, algo menos usando software genérico.

En **R** se pueden dibujar con `plotmat()`, a partir de una matriz de transición.

La función `plotmat()` tiene una aspecto algo intimidante al admitir muchos argumentos que modifican la estética del ciclo resultante; no todos son necesarios. El comando más simple `plotmat(whale)` pinta una versión muy mejorable del ciclo de las orcas, en la que algunos valores quedan superpuestos, y la disposición de los estadios no es buena. Por eso usamos el argumento `pos=` dentro de `plotmat()`para definir la posición de los estadios en un espacio XY<sup>4</sup> entre 0 y 1:

``` r
posit <- cbind (c(0.6, 0.9, 0, 0), c(1, 0, 0, 0.8))
posit
```

    ##      [,1] [,2]
    ## [1,]  0.6  1.0
    ## [2,]  0.9  0.0
    ## [3,]  0.0  0.0
    ## [4,]  0.0  0.8

``` r
plotmat(whale, pos=posit, relsize =0.75, self.shifty=0.05, box.prop = 0.2,
        box.type = "square", box.size = 0.12, lwd = 1, arr.col = "green",
        arr.lcol = "black", arr.type = "triangle", main = "Orcas")
```

![](stages_files/figure-markdown_github/unnamed-chunk-3-1.png)

### Calculos básicos

Una vez comprendida la estructura del modelo, extraemos la información numérica contenida en la matriz de transición; es decir, aquella dependiente solo de la combinación de valores de supervivencia y fecundidad. La función que extrae buena parte de esa información determinista del modelo es `eigen.analysis()`. Como en el caso anterior, `pander()` es una mera opción estética. Los parámetros están explicados a continuación de la salida:

``` r
pander(eigen.analysis (whale))
```

-   **lambda1**: *1.025*
-   **stable.stage**:

    <table style="width:60%;">
    <colgroup>
    <col width="15%" />
    <col width="15%" />
    <col width="12%" />
    <col width="16%" />
    </colgroup>
    <thead>
    <tr class="header">
    <th align="center">yearling</th>
    <th align="center">juvenile</th>
    <th align="center">mature</th>
    <th align="center">postreprod</th>
    </tr>
    </thead>
    <tbody>
    <tr class="odd">
    <td align="center">0.03697</td>
    <td align="center">0.3161</td>
    <td align="center">0.3229</td>
    <td align="center">0.324</td>
    </tr>
    </tbody>
    </table>

-   **sensitivities**:

    <table style="width:90%;">
    <colgroup>
    <col width="23%" />
    <col width="16%" />
    <col width="16%" />
    <col width="16%" />
    <col width="16%" />
    </colgroup>
    <thead>
    <tr class="header">
    <th align="center"> </th>
    <th align="center">yearling</th>
    <th align="center">juvenile</th>
    <th align="center">mature</th>
    <th align="center">postreprod</th>
    </tr>
    </thead>
    <tbody>
    <tr class="odd">
    <td align="center"><strong>yearling</strong></td>
    <td align="center">0.04221</td>
    <td align="center">0.3608</td>
    <td align="center">0.3686</td>
    <td align="center">0.3699</td>
    </tr>
    <tr class="even">
    <td align="center"><strong>juvenile</strong></td>
    <td align="center">0.04428</td>
    <td align="center">0.3785</td>
    <td align="center">0.3867</td>
    <td align="center">0.3881</td>
    </tr>
    <tr class="odd">
    <td align="center"><strong>mature</strong></td>
    <td align="center">0.06632</td>
    <td align="center">0.567</td>
    <td align="center">0.5793</td>
    <td align="center">0.5813</td>
    </tr>
    <tr class="even">
    <td align="center"><strong>postreprod</strong></td>
    <td align="center">2.533e-17</td>
    <td align="center">2.166e-16</td>
    <td align="center">2.213e-16</td>
    <td align="center">2.22e-16</td>
    </tr>
    </tbody>
    </table>

-   **elasticities**:

    <table style="width:88%;">
    <colgroup>
    <col width="23%" />
    <col width="15%" />
    <col width="15%" />
    <col width="16%" />
    <col width="16%" />
    </colgroup>
    <thead>
    <tr class="header">
    <th align="center"> </th>
    <th align="center">yearling</th>
    <th align="center">juvenile</th>
    <th align="center">mature</th>
    <th align="center">postreprod</th>
    </tr>
    </thead>
    <tbody>
    <tr class="odd">
    <td align="center"><strong>yearling</strong></td>
    <td align="center">0</td>
    <td align="center">0.001513</td>
    <td align="center">0.0407</td>
    <td align="center">0</td>
    </tr>
    <tr class="even">
    <td align="center"><strong>juvenile</strong></td>
    <td align="center">0.04221</td>
    <td align="center">0.3363</td>
    <td align="center">0</td>
    <td align="center">0</td>
    </tr>
    <tr class="odd">
    <td align="center"><strong>mature</strong></td>
    <td align="center">0</td>
    <td align="center">0.0407</td>
    <td align="center">0.5386</td>
    <td align="center">0</td>
    </tr>
    <tr class="even">
    <td align="center"><strong>postreprod</strong></td>
    <td align="center">0</td>
    <td align="center">0</td>
    <td align="center">9.753e-18</td>
    <td align="center">2.123e-16</td>
    </tr>
    </tbody>
    </table>

-   **repro.value**:

    <table style="width:60%;">
    <colgroup>
    <col width="15%" />
    <col width="15%" />
    <col width="12%" />
    <col width="16%" />
    </colgroup>
    <thead>
    <tr class="header">
    <th align="center">yearling</th>
    <th align="center">juvenile</th>
    <th align="center">mature</th>
    <th align="center">postreprod</th>
    </tr>
    </thead>
    <tbody>
    <tr class="odd">
    <td align="center">1</td>
    <td align="center">1.049</td>
    <td align="center">1.571</td>
    <td align="center">6.002e-16</td>
    </tr>
    </tbody>
    </table>

-   **damping.ratio**: *1.046*

<!-- end of list -->
**lambda1** muestra el valor de la tasa de crecimiento determinista. En matemáticas corresponde con el *valor propio* de la matriz, *eigenvalue* en inglés.

**stable.stage** indica la proporción de individuos de cada estadio en la población, una vez que esta alcanza un distribución estable. La convergencia a esa proporción estable de edades o estadios es una característica formal de este tipo de modelos, consecuencia de usar una matriz de proyección invariable. En el caso de esta población de orcas los individuos están repartidos de forma casi idéntica entre juveniles, reproductores, y postreproductores.

**sensitivities** y **elasticities** reflejan dos formas de expresar la contribución de cada elemento de la matriz a la tasa de crecimiento lambda. las *elasticidades* son más fáciles de interpretar al representar una proporción. En este caso indican que los dos elementos con más influencia en la dinámica son las supervivencias de reproductores y juveniles (`whale[3,3]` y `whale[2,2]`). No nos ocupamos aquí del resto de parámetros incluidos en la salida de `eigen.analysis()`.

Otro parámetro habitualmente importante en demografía es el **tiempo de generación**, interpretable como la edad media de los reproductores en la población. La función que lo extrae es intuitiva:

``` r
generation.time (whale)
```

    ## [1] 27.85079

### Proyección de la población de N<sub>0</sub> a N<sub>t</sub>

Los cálculos anteriores dependen exclusivamente de la estructura de la matriz de transición. Otros dependerán de la proyección de la población en el tiempo.

Para llevar a cabo dicha proyección necesitamos saber o simular cuántos individuos hay en cada estadio en t<sub>0</sub>.

El código a continuación define y almacena ese N<sub>0</sub> como **n0\_whale\_1**, con 10 individuos en cada uno de los 4 estadios. A continuación `pop.projection()` proyecta ese N<sub>0</sub> 50 intervalos de tiempo (N<sub>50</sub>) con los parámetros de la matriz de transición o proyección `whale`. Almacena los resultados en **whale\_nt\_1**:

``` r
n0_whale_1 <- c(10,10,10,10)
whale_nt_1 <- pop.projection (whale, n0_whale_1, 50)
```

`stage.vector.plot` usa los resultados de **whale\_nt\_1** para dibujar el cambio de las proporciones de los estadios entre t<sub>0</sub> y t<sub>50</sub>:

``` r
stage.vector.plot (whale_nt_1$stage.vectors, ylim = c(0, 0.6))
```

![](stages_files/figure-markdown_github/unnamed-chunk-7-1.png)

El modelo estructurado de la población de orcas `whale` predice que las proporciones de los distintos estadios alcancen una distribución estable a partir de 10-12 años, partiendo de 10 individuos en cada estadio. ¿Cambia mucho el resultado con el vector inicial de abundancias N<sub>0</sub>?

Para comprobarlo definimos un N<sub>0</sub> muy diferente, y lo proyectamos:

``` r
n0_whale_2 <- c(1,2,12,25)
whale_nt_2 <- pop.projection (whale, n0_whale_2, 50)
stage.vector.plot (whale_nt_2$stage.vectors, ylim = c(0, 0.6))
```

![](stages_files/figure-markdown_github/unnamed-chunk-8-1.png)

La convergencia a la distribución estable de estadios es más rápida ante la distribución de abundancias de **n0\_whale\_1**. Una interpretación posible es que esa distribución inicial corresponde a una población en mejor estado, dado el modelo contenido en la matriz de transición `whale`, que tiene una tasa de crecimiento lambda = 1.025, ligeramente positiva.

### Enlaces, referencias, anotaciones de código

Para abrir los enlaces en otra pestaña, *botón derecho + abrir en nueva pestaña*, o *Ctrl click*)
1. Caswell, H. 2001. Matrix population models: construction, analysis, and interpretation; 2nd ed. Sinauer

1.  Este otro ejercicio corto incluye instrucciones para introducir datos matriciales: *Ctrl. + click* <https://github.com/quevedomario/eco3r/blob/master/stages2.md>

2.  <https://www.theatlantic.com/science/archive/2017/01/why-do-killer-whales-go-through-menopause/512783/>

3.  Esas posiciones las almacenamos primero por comodidad como **posit**, y las usamos después en la función. **posit** contiene dos columnas, con las posiciones XY de los estadios. Así la primera fila (0.6,1) corresponde en el caso de las orcas a la posición de *yearling*. El resto de argumentos en la función `plotmat()` retocan aspectos estéticos, como el color de las flechas `arr.col = "green"`.

4.  O no; ver el ciclo de vida de *Arisaema triphyllum*, Jack-in-the-pulpit <https://en.wikipedia.org/wiki/Arisaema_triphyllum>, a partir de los datos incluidos en Akçakaya *et al.* 1999. Applied Population Ecology: Principles and Computer Exercises Using RAMAS EcoLab. Sinauer:

![](stages_files/figure-markdown_github/structured_jack_in_the_pulpit_600.jpg)
