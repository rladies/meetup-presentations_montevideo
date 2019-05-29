
## app 1 ##

# Descripción: 
#  - definición básica de una app sin argumentos

# User Interface
ui <- dashboardPage(
  dashboardHeader(),
  dashboardSidebar(),
  dashboardBody()
)

# Server
server <- function(input, output) { }

shinyApp(ui, server)
