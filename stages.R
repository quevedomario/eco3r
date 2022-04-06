browseURL("https://kevintshoemaker.github.io/NRES-470/LECTURE7.R")
browseURL("https://cjabradshaw.shinyapps.io/LeslieMatrixShiny/")

## ----setup, include=FALSE----------------------------------------------------------------------
knitr::opts_chunk$set(echo = TRUE)
options(warn=-1)


## ----message=FALSE, warning=FALSE--------------------------------------------------------------
library (popbio)
library(diagram)
library(pander)


## ----------------------------------------------------------------------------------------------
data (whale)
pander(whale)


## ----------------------------------------------------------------------------------------------
posit <- cbind (c(0.6, 0.9, 0, 0), c(1, 0, 0, 0.8))
posit
plotmat(whale, pos=posit, relsize =0.75, self.shifty=0.08, self.shiftx = c(0,0.13,-0.05,0), 
        box.prop = 0.3, box.type = "round", box.size = 0.12, lwd = 1, 
        arr.col = "red", arr.lcol = "black", arr.type = "triangle", 
        main = "Orcas")


## ----------------------------------------------------------------------------------------------
eigen.analysis (whale)


## ----------------------------------------------------------------------------------------------
generation.time (whale)


## ----------------------------------------------------------------------------------------------
n0_whale_1 <- c(10,10,10,10)
whale_nt_1 <- pop.projection (whale, n0_whale_1, 50)


## ----------------------------------------------------------------------------------------------
stage.vector.plot (whale_nt_1$stage.vectors, ylim = c(0, 0.6))


## ----------------------------------------------------------------------------------------------
n0_whale_2 <- c(1,2,12,25)
whale_nt_2 <- pop.projection (whale, n0_whale_2, 50)
stage.vector.plot (whale_nt_2$stage.vectors, ylim = c(0, 0.6))

