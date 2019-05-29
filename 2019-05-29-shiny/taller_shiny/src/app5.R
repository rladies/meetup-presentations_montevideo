
## app 5  ##

# User Interface

header <- dashboardHeader(
  title = "Header", 
  
  # Incorpora Logo desde la web:
  tags$li(a(href = 'https://rladies.org/',
            img(src = "https://rladies.org/wp-content/uploads/2016/12/R-LadiesGlobal.png",
                height="30px"),
            style = "padding-top:10px; padding-bottom:10px;"),
          class = "dropdown")
)

sidebar <- dashboardSidebar(
  sidebarMenu(
    
    # Se incorporan íconos a cada menuItem (https://glyphsearch.com/)
    menuItem("Item 1", tabName = "item1", icon = icon("arrow-right", lib = "glyphicon"),                                         # Glyphicon
             menuSubItem("SubItem 1", tabName = "subitem1", icon = icon("arrow-circle-right", lib = "font-awesome")),            # Font Awesome
             startExpanded = TRUE),
    menuItem("Item 2", tabName = "item2", icon = icon("arrow-right", lib = "glyphicon"))
  )
)

body <- dashboardBody(
  tabItems(
    tabItem(tabName = "subitem1",
            fluidRow(
              box(                                                                                 # ?shinydashboard::box 
                title = "Caja simple con Inputs",
                width = 4,
                status = "warning",                                                                # ?shinydashboard::validStatuses
                solidHeader = TRUE,
                collapsible = TRUE,
                sliderInput(inputId = "slider", 
                            label = "Seleccione año:", 
                            min = 2010, 
                            max = 2018, 
                            value = 2014, 
                            sep = NULL)
              ),
              
              tabBox(                                                                              # ?shinydashboard::tabBox 
                title = "Caja con pestañas",
                width = 8,
                tabPanel("Tab1", "Pestaña 1"),
                tabPanel("Tab2", "Pestaña 2"),
                selected = "Tab2"
              )),
            
            fluidRow(
              column(4),
              column(8,
                     infoBox("Info Box", 10000,                                                    # ?shinydashboard::infoBox 
                             icon = icon("list"),
                             color = 'aqua',                                                       # ?shinydashboard::validColors
                             fill = TRUE))
              
            )),
    tabItem(tabName = "item2",
            fluidRow(
              box(
                title = "Caja simple sin fondo", 
                status = "success",
                textInput("text", "Ingresar texto:")),                                             # ?shiny::textInput
              box(
                title = "Caja simple con fondo",
                background = "orange",
                solidHeader = FALSE)
            ))
    ))

ui <- dashboardPage(header, sidebar, body,  skin = "black")

# Server
server <- function(input, output) { }

shinyApp(ui, server)

