
## app 6 ##

# Inputs
# bd <- readr::read_rds('data/bd.rds')

choice_anio <- (bd %>% transmute(anio = as.numeric(anio)) %>% unique() %>% arrange(anio))$anio
choice_departamento <- (bd %>% select(departamento) %>% unique() %>% arrange(departamento))$departamento
choice_vble <- c("genero", "edad_categoria")
  
# User Interface

header <- dashboardHeader(
  title = "Población"
  )

sidebar <- dashboardSidebar(
  sidebarMenu(
    menuItem("por variable", tabName = "por_variable", icon = icon("arrow-right", lib = "glyphicon"))
  )
)

body <- dashboardBody(
  tabItems(
    tabItem(tabName = "por_variable",
            fluidRow(
              box(
                title = "Inputs",
                width = 4,
                status = "warning",
                sliderInput("input_anio", "1. Seleccione rango de años:",
                            min = min(choice_anio), max = max(choice_anio), value = c(min, max),
                            sep = ""),
                pickerInput("input_dpto", "2. Seleccione departamento(s):",
                            choices = choice_departamento,
                            options = list(`actions-box` = TRUE,
                                           `deselect-all-text` = "Ninguno",
                                           `select-all-text` = "Total Uruguay",
                                           `none-selected-text` = "Seleccione al menos un departamento.",
                                           `selected-text-format` = "count > 3"),
                            selected = choice_departamento[2],
                            multiple = TRUE),
                selectInput("input_vble", "3. Seleccione variable:", choice = choice_vble)),
              
              tabBox(
                title = "",
                width = 8,
                tabPanel("Tabla", 
                         fluidRow(
                           column(12,
                           uiOutput("nota.tabla"))
                           ),
                         fluidRow(
                           column(2),
                           column(8,
                                  br(),
                                  DT::dataTableOutput("tabla"),
                                  br()
                                  ))
                         ),
                
                tabPanel("Gráfico", 
                         fluidRow(
                           column(12,
                                  uiOutput("nota.plot"),
                                  br(),
                                  plotOutput("plot", height = 600,  width = "100%"),
                                  br()
                                  ))
                         )
              )))
))

ui <- dashboardPage(header, sidebar, body)

# Server
server <- function(input, output) {
  
  output$nota.tabla <- renderUI({
    a <- input$input_dpto
    b <- NULL
    for (i in 1:length(a)) {
      b <- str_c(b, a[i], sep = ', ')
    }
    
    helpText(h3("Población por variable"),
             h5(str_c('Variable: ', input$input_vble)),
             h5(if(length(input$input_dpto) == 19){"Total Uruguay"}
                else if(length(input$input_dpto)==1){str_c("Departamento: ", input$input_dpto, ".")}
                else {str_c('Departamentos: ',  b, '.')}),
             h5(if(input$input_anio[1] == input$input_anio[2]){str_c('Año: ', input$input_anio[1])}
                else {str_c('Período seleccionado: (', input$input_anio[1], ' - ', input$input_anio[2], ')')}))
  })
  
  datasetInput1 <- reactive({
    bd %>% 
      select(anio, departamento, variable = input$input_vble, ponderador) %>% 
      filter(anio >= input$input_anio[1],
             anio <= input$input_anio[2],
             departamento %in% input$input_dpto) %>%
      group_by(anio, departamento, variable) %>%
      summarise(total = sum(ponderador)) %>%
      ungroup()
  })
  
  output$tabla <- DT::renderDataTable({
    DT::datatable(
      datasetInput1() %>% 
        spread(anio, total) %>%
        janitor::adorn_totals(),
      rownames = FALSE,
      options = list(
        paging = TRUE,
        searching = FALSE,
        info = FALSE,
        lengthChange = FALSE)) %>% 
      formatCurrency(3:10, digits = 0, currency = "", mark = ".", dec.mark =  ",")
  })
  
  
  output$nota.plot <- renderUI({
    a <- input$input_dpto
    b <- NULL
    for (i in 1:length(a)) {
      b <- str_c(b, a[i], sep = ', ')
    }
    
    helpText(h3("Población por variable"),
             h5(str_c('Variable: ', input$input_vble)),
             h5(if(length(input$input_dpto) == 19){"Total Uruguay"}
                else if(length(input$input_dpto)==1){str_c("Departamento: ", input$input_dpto, ".")}
                else {str_c('Departamentos: ',  b, '.')}),
             h5(if(input$input_anio[1] == input$input_anio[2]){str_c('Año: ', input$input_anio[1])}
                else {str_c('Período seleccionado: (', input$input_anio[1], ' - ', input$input_anio[2], ')')}))
  })
  
  datasetInput2 <- reactive({
    datasetInput1() %>% 
      group_by(anio, variable) %>% 
      summarise(total = sum(total)) %>% 
      ungroup()
  })
  
  output$plot <- renderPlot({
    ggplot(datasetInput2(), 
           aes(x = anio, 
               y = total,
               fill = variable)) +
      geom_col(position = "dodge2") +
      geom_text(aes(label = format(total, big.mark = ".", decimal.mark = ",")),
                vjust = 1.6, 
                color="white",
                position = position_dodge(0.9),
                size = 5)+
      
      labs(x = "Año", 
           y = "Población", 
           colour = "",
           size = "",
           fill = "") +
      theme(axis.line = element_line())
})
  
}

shinyApp(ui, server)

