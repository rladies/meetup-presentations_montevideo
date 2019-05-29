
## app 6 ##

# Inputs
# bd <- readr::read_rds('data/bd.rds')

choice_departamento <- (bd %>% select(departamento) %>% unique() %>% arrange(departamento))$departamento


# User Interface

header <- dashboardHeader(
  title = "Población"
  )

sidebar <- dashboardSidebar(
  sidebarMenu(
    menuItem("por género", tabName = "por_genero", icon = icon("arrow-right", lib = "glyphicon"))
  )
)

body <- dashboardBody(
  tabItems(
    tabItem(tabName = "por_genero",
            fluidRow(
              box(
                title = "Inputs",
                width = 4,
                status = "warning",
                sliderInput(inputId = "input_anio", 
                            label = "1. Seleccione año:", 
                            min = 2011, max = 2018, value = 2014, sep = NULL),
                selectInput(inputId = "input_dpto",
                            label = "2. Seleccione departamento:",
                            choices = choice_departamento,
                            selected = choice_departamento[2])
              ),
              
              tabBox(
                title = "Población por género",
                width = 8,
                tabPanel("Output", 
                         fluidRow(
                           column(12,
                           uiOutput("nota"),
                           br(), 
                           plotOutput("plot", height = 450,  width = "100%"),
                           br())
                           ),
                         fluidRow(
                           column(2),
                           column(8,
                                  br(),
                                  DT::dataTableOutput("tabla"),
                                  br()
                                  ))
                         )
              )))
))

ui <- dashboardPage(header, sidebar, body)

# Server
server <- function(input, output) {
  
  output$nota <- renderUI({
    helpText(h5(str_c("Departamento: ", input$input_dpto)),
             h5(str_c("Año: ", input$input_anio)))
  })
  
  datasetInput <- reactive({
    bd %>% 
      filter(anio == input$input_anio,
             departamento == input$input_dpto) %>% 
      group_by(genero) %>% 
      summarise(total = sum(ponderador)) %>% 
      ungroup() %>% 
      janitor::adorn_totals()
  })
  
  
  output$plot <- renderPlot({
    ggplot(datasetInput(), 
           aes(x = genero, 
               y = total, 
               fill = genero)) +
      geom_col(position = "dodge2") +
      geom_text(aes(label = format(total, big.mark = ".", decimal.mark = ",")),
                vjust = 1.6,
                color="white",
                position = position_dodge(0.9),
                size = 5)+
      
      labs(x = "Género", 
           y = "Población", 
           colour = "",
           size = "",
           fill = "") +
      theme(axis.line = element_line())
  })
  
  output$tabla <- DT::renderDataTable({
    DT::datatable(
      datasetInput() %>%
        rename_at(1:2, ~c("Género", "Total")),
      rownames = FALSE,
      options = list(
        paging = FALSE,
        searching = FALSE,
        info = FALSE,
        lengthChange = FALSE)) %>% 
      formatCurrency(2, digits = 0, currency = "", mark = ".", dec.mark =  ",")
  })
  
}

shinyApp(ui, server)

