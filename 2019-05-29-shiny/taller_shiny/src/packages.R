
## Chequear versión de R 
strsplit(version[['version.string']], ' ')[[1]][3]

# Última versión disponible: "3.6.0"


## Actualizar R desde consola

# if(!require(installr)){
#   install.packages("installr")
#   library(installr)
# }
# updateR()


## Paquetes

### Tidyverse
if(!require(tidyverse)){
  install.packages("tidyverse")
  library(tidyverse)
}

### Shiny
if(!require(shiny)){
  install.packages("shiny")
  library(shiny)
}

### Shiny Dashboard
if(!require(shinydashboard)){
  install.packages("shinydashboard")
  library(shinydashboard)
}

### Shiny Widgets
if(!require(shinyWidgets)){
  install.packages("shinyWidgets")
  library(shinyWidgets)
}

### DT
if(!require(DT)){
  install.packages("DT")
  library(DT)
}

### Janitor
if(!require(janitor)){
  install.packages("janitor")
  library(janitor)
}


