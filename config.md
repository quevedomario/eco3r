Configuración previa
================
Enero de 2019

Para desarrollar los ejercicios en un ordenador personal necesitaréis un ordenador con varios componentes de software libre y gratuito (instalados en las aulas de informática de la Facultad de Biología, así como en la del departamento B.O.S.):

1.  **R** [(https://www.r-project.org/)](https://www.r-project.org/) es el entorno de análisis y representación gráfica de datos estándar actualmente en ciencias, y disponible tanto para [Windows como Linux y MAC OS](https://cloud.r-project.org/).
2.  **[Rstudio](https://www.rstudio.com/products/rstudio/download/#download)**: interfaz gratuita que facilita el trabajo con R. En caso de instalarlo en un ordenador personal, **instalad primero R, y a continuación RStudio**.
    -   El orden de instalación es necesario para que RStudio se asocie correctamente a R. Una vez instalado, trabajad directamente con RStudio. Las instalaciones de R o RStudio no presentan a priori complicaciones, y las opciones por defecto son válidas.
    -   El aspecto de RStudio, colores y disposición de paneles, puede configurarse una vez instalado desde la barra de menús, con **Tools :: Global Options…**. Puede por tanto diferir entre los ejemplos y los usuarios. No es importante para el desarrollo de los ejercicios.

R instala por defecto muchas funciones genéricas de análisis de datos. Sin embargo para acceder a funciones específicas (desde dinámica de poblaciones a genómica) será necesario agregar **librerías adicionales**: conjuntos de funciones específicas, conocidas en otros entornos como *apps*, *plugins*, etc. y que en R se llaman **packages** (si bien aquí usaré el genérico librerías; <https://cloud.r-project.org/web/packages/index.html>).
Para instalar librerías adicionales desde la barra de menús de RStudio, usad **Tools :: Install Packages…**.

Una de esas librerías controla una interfaz guiada, **R Commander**, que proporciona un comportamiento tipo *pinchar con el ratón*, útil como introducción más amable al entorno R. Para utilizarla, instalad las librerías o paquetes **Rcmdr** y **RcmdrPlugin.EcoVirtual**, en ese orden. Para instalarlas desde la consola, usando código, la orden de instalación de ambas sería:

`install.packages("Rcmdr", "RcmdrPlugin.EcoVirtual")`

La primera añade R Commander a R, y la segunda añade funciones relacionadas con modelos de dinámica de poblaciones.

![](config_files/R%20Commander_004.png)
