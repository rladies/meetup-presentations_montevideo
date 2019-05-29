
## app 3 ##

# Descripción: 
#  - Header:  Se agrega título y logo
#  - Sidebar: Se incorpora pestaña
#  - Body:    Se imprimen textos de distintos tamaños

# User Interface

header <- dashboardHeader(
  title = "Header", 
  titleWidth = 200,
  
  # Incorpora logo desde la web:
  tags$li(a(href = 'https://rladies.org/',
            img(src = "https://rladies.org/wp-content/uploads/2016/12/R-LadiesGlobal.png",
                height="30px"),
            style = "padding-top:10px; padding-bottom:10px;"),
          class = "dropdown")
  )
  
sidebar <- dashboardSidebar(
  width = 100,
  sidebarMenu(
    menuItem("Sidebar")
    )
  )
  
body <- dashboardBody(
  h1("Body"),
  h2("Body"),
  h3("Body"),
  h4("Body"),
  h5("Body")
  )

ui <- dashboardPage(header, sidebar, body)

# Server
server <- function(input, output) { }

shinyApp(ui, server)

