
## app 2 ##

# Descripción: 
#  - se incorporan argumentos a cada componente

# User Interface
ui <- dashboardPage(
  
  dashboardHeader(
    disable = FALSE,
    title = NULL, 
    titleWidth = 230
    ),
  
  dashboardSidebar(
    disable = FALSE, 
    width = 230,
    sidebarMenu(menuItem(""))
    ),
  
  dashboardBody(
    "Idem"
    )
)

# Server
server <- function(input, output) { }

shinyApp(ui, server)
