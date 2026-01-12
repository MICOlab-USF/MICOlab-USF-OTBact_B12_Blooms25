library(shiny)
library(shinyWidgets)
library(ggOceanMaps)
library(ggspatial)
library(tidyr)
library(dplyr)
library(magrittr)
library(gridExtra)
`%ni%` = Negate(`%in%`)
library(lubridate)

TBcolors <- c("#9e0142", "#d53e4f", "#f46d43", "#fdae61", "#fee08b", "#e6f598", "#abdda4", "#66c2a5", "#3288bd", "#5e4fa2"  )

dt <- data.frame(lon = c(-82.3, -82.3, -82.9, -82.9), lat = c(27.65, 28.1, 28.1, 27.65))

df <- read.csv("CleanedData.csv")

names(df) <- c("Station_Number", "Date", "Chla" , "Temperature" ,"Salinity","Latitude","Longitude",      "Bacteria")

date_choices <- c("2025-05-08", "2025-05-23", "2025-06-11", "2025-06-19", "2025-07-01", "2025-07-18", "2025-07-31", "2025-08-13", "2025-08-29", "2025-09-11", "2025-09-25", "2025-10-14")

dummies <- read.csv("dummyvals4legend.csv")
dummies$Date <- date_choices

locs <- read.csv("locs.csv")

df <- rbind(df, dummies)

df_long <- df %>% pivot_longer(!c("Station_Number", "Date", "Latitude", "Longitude"), names_to = "Var", values_to = "Value")

df_long4lines <- df_long %>% filter(Station_Number %ni% c(11, 12))

df_long4lines$Station_Number <- factor(as.character(df_long4lines$Station_Number), levels = c("1", "2", "3", "4", "5", "6", "7", "8", "9", "10"))
df_long4lines$Date <- ymd(df_long4lines$Date)
# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Old Tampa Bay, Summer 2025"),
    
    # Sidebar layout with input and output definitions ----
    sidebarLayout(
      
      # Sidebar panel for inputs ----
      sidebarPanel(
        
        # Input: Selector for variable to plot against mpg ----
        selectInput("variable", "Variable:",
                    c("Temperature (ºC)" = "Temperature",
                      "Salinity (PSU)" = "Salinity",
                      "Chlorophyll a (µg/L)" = "Chla",
                      "Bacteria Conc. (cells/µl)" = "Bacteria")),
        
         sliderTextInput( # Use sliderTextInput for discrete choices
             inputId = "dateSlider",
              label = "Select a Date:",
              choices = date_choices,
              selected = "2025-05-08", # Initial selected range
              grid = TRUE)
        
      ),
      
      mainPanel(
          
          # Output: Formatted text for caption ----
          h3(textOutput("caption")),
          plotOutput("map"), 
          plotOutput("lines")
        )
      )
    )



# Define server logic required to plot
server <- function(input, output) {
  # Compute the formula text ----
  # This is in a reactive expression since it is shared by the
  # output$caption and output$mpgPlot functions
  formulaText <- reactive({
   paste0( input$"variable",", ", input$dateSlider)
  })
  # Return the formula text for printing as a caption ----
  output$caption <- renderText({
    formulaText()
  })
  
  # Generate a plot of the requested variable against mpg ---
  output$map <- renderPlot({ basemap(data = dt, bathymetry = TRUE) + geom_point(data = (df_long %>% filter(Date == input$dateSlider) %>% filter(Var == input$variable)), aes(x = Longitude, y = Latitude, color =  Value), size = 5) + xlab("") + ylab("") + theme(legend.position = "right")  + geom_text(data = locs, aes(x = Longitude, y = Latitude, label = station_number),size = 6, nudge_x = 0.025) + scale_color_continuous(type = "viridis") + theme(axis.text = element_blank(),legend.title = element_text(size = 16),legend.text = element_text(size = 14))
  })
  
  output$lines <- renderPlot({df_long4lines %>% filter(Var == input$variable) %>%  ggplot(aes(x=Date, y = Value, color = Station_Number)) + geom_point() + theme_test() + scale_color_manual(values = TBcolors)  + geom_line() + xlab("Time (months)") + ylab("") + ggtitle(input$"variable") + theme(axis.text.x = element_text(size = 14), axis.text.y = element_text(size = 14), axis.title.x = element_text(size = 16), axis.title.y = element_text(size = 16),legend.title = element_text(size = 16),legend.text = element_text(size = 14) )
  })
  
}

# Run the application 
shinyApp(ui = ui, server = server)

#rsconnect::deployApp("~/Desktop/tberf/OTBact")
