# This is a shiny app implementation of the Font Classifier model I wrote
# Jakob Lovato, July 2022

library(magrittr)
library(dplyr)
library(keras)
library(jpeg)
library(imager)
library(imagerExtra)
library(shiny)
library(bslib)
library(sysfonts)

source("helpers.R")

# Load Keras model
model <- load_model_tf("my_model/")

# https://stackoverflow.com/questions/49506469/shiny-customise-fileinput
# custom function to remove form-control next to file upload button
fileInputOnlyButton <- function(..., label="") {
  temp <- fileInput(..., label=label)
  # Cut away the label
  temp$children[[1]] <- NULL
  # Cut away the input field (after label is cut, this is position 1 now)
  temp$children[[1]]$children[[2]] <- NULL
  # Remove input group classes (makes button flat on one side)
  temp$children[[1]]$attribs$class <- NULL
  temp$children[[1]]$children[[1]]$attribs$class <- NULL
  temp
}

my_theme <- bs_theme(
  heading_font = font_google("Sigmar One"),
  base_font = font_google("Overpass"),
  code_font = font_google("Montserrat")
)

#Create user interface
ui <- fluidPage(
  theme = my_theme,
  
  title = "Find-A-Font",
  
  titlePanel(h1("Find-A-Font",
             style = "color: rgba(245, 245, 245)")),
  
  tags$head(tags$style(HTML('body {
                             background-color: rgba(17, 19, 21);
              }
              pre {
              background-color: rgba(17, 19, 21);
              border-color: rgba(17, 19, 21);
              color: rgba(245, 245, 245);
              font-size: 30px;
              font-weight: 600;
              }'))),
  
  sidebarLayout(
    sidebarPanel(
      tags$style(".well {border-radius: 20px;
                 background-color: rgba(26, 28, 30);
                 border-color: rgba(26, 28, 30);
                 }
                 
                .btn-file {  
                background-color: rgba(60, 127, 248); 
                border-color: rgba(60, 127, 248);
                border-radius: 25px;
                color: rgba(245, 245, 245);
                }
                
                .shiny-file-input-progress {display: none}"),
      
      h2("Instructions",
         style = "color: rgba(245, 245, 245)"),
      
      p("1 - Take a screenshot or photo of your text. Please use an image where
        the text is not on top of any graphical or decorative backgrounds. Text of
        a single color on a plain background works best.",
        style = "color: rgba(200, 200, 200)"),
      
      p("2 - Center the text and crop the image tightly around", strong("five"), "letters. Make sure
        there are no harsh shadows or reflections if using a photo. See examples.",
        style = "color: rgba(200, 200, 200)"),
      
      p("3 - Click the button below and upload your image. You will then get the three most
        similar fonts available on Google Fonts!",
        style = "color: rgba(200, 200, 200)"),
      
      p("4 - Visit", a(href = "https://fonts.google.com","Google Fonts"), "to search for the suggested
        fonts.",
        style = "color: rgba(200, 200, 200)"),
      
      br(),
      
      fileInputOnlyButton("image", buttonLabel = "Upload Image", accept = c('image/png', 'image/jpeg')),
      
      br(),
      
      p("Note: Google Fonts sometimes changes their catalog, so not all fonts may be available
        all the time.",
        style = "color: rgba(200, 200, 200)"),
      
      br(),
      
      tags$a(
        href="https://github.com/Jakob-Lovato/font-classifier", 
        tags$img(src="github_logo.png",
                 height = "30"),
        tags$text("View project on Github")
      )
    ),
    
    mainPanel(
      tags$style(".well {border-radius: 20px;
                 background-color: rgba(26, 28, 30);
                 border-color: rgba(26, 28, 30);
                 }"),
      
      h1("Example Images:", 
         style = "color: rgba(245, 245, 245)"),
      
      h1("Good",
         style = "color: rgba(105, 220, 106)"),
      
      fluidRow(
        column(3,
               tags$img(src = "ender.jpg",
                        height = "50")),
        
        column(3,
               tags$img(src = "famil.jpg",
                        height = "50")),
      ),
      
      fluidRow(
        column(7,
               br(),
               p("Five letters cropped tightly with no background graphics or
            extraneous elements in the photo.",
            style = "color: rgba(200, 200, 200)")
        )
      ),
      
      h1("Bad",
         style = "color: rgba(232, 81, 69)"),
      
      fluidRow(
        column(2,
               tags$img(src = "style.jpg",
                        height = "50")),
        
        column(3,
               tags$img(src = "grape.jpg",
                        height = "50")),
        
        column(3,
               tags$img(src = "eucalyptus.jpg",
                        height = "50"))
      ),
      
      fluidRow(
        column(8,
               br(),
               p("First mage is not centered, is on a patterned background, and 
                 has non-text elements in the photo.",
            style = "color: rgba(200, 200, 200)"),
            
            p("Second image has glare, non-text elements in the top left, and includes
              a cut off letter from the next line underneath the letter 'G'.",
              style = "color: rgba(200, 200, 200)"),
            
            p("Third image contains more than five letters and is not straight.",
              style = "color: rgba(200, 200, 200)")
        )
      ),
      
    )
  )
)

# Server Logic
server <- function(input, output){
  modalResult <- function(failed = FALSE){
    processed_image <- process_input_image(load.image(input$image$datapath))
    modalDialog(
      renderPrint(get_top_3_classes(processed_image, model)),
      p("Note: Sometimes the first font isn't the closest match. Check all three!")
    )
  }
  observeEvent(input$image,
    {showModal(modalResult())}
  )

}

# Run App
shinyApp(ui, server)