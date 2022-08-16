# Helper functions/objects for font classification shiny app

library(magrittr)
library(dplyr)
library(keras)
library(jpeg)
library(imager)
library(imagerExtra)

# Load in pre-trained model
#model <- load_model_tf("/my_model")

# Rescale and process image input
process_input_image <- function(image){
  image <- grayscale(image)
  # Pull color from side of image to pad sides with
  pad_color_left <- image[1, dim(image)[2] / 2, 1, 1]
  pad_color_right <- image[dim(image)[1], dim(image)[2] / 2, 1, 1]
  image <- image %>%
    pad(nPix = ((dim(image)[2] / 28 * 140) - dim(image)[1]) / 2, 
        axes = "x", pos = -1, val = pad_color_left) %>%
    pad(nPix = ((dim(image)[2] / 28 * 140) - dim(image)[1]) / 2, 
        axes = "x", pos = 1, val = pad_color_right) %>%
    ThresholdTriclass(stopval = 0.01) %>%
    resize(size_x = 140, size_y = 28, size_c = 1, interpolation_type = 2) %>%
    as.array() %>%
    aperm(c(3, 2, 1, 4))
  
  #If background is white and text is black
  if(image[1,1,1,1] == 1 | image[1,nrow(image), ncol(image),1] == 1 |
    image[1,1, ncol(image),1] == 1 | image[1,nrow(image), 1,1] == 1){
   image <- 1 - image
  }
  return(image)
}


font_list <-  c("AbrilFatface-Regular",         "AlexBrush-Regular",   
"AlfaSlabOne-Regular",          "Allura-Regular",
"ArchitectsDaughter-Regular",   "Arvo-Bold"                   ,
"Arvo-Italic"               ,   "Arvo-Regular"                ,
"Audiowide-Regular"         ,   "B612Mono-Bold"               ,
"B612Mono-Italic"           ,   "B612Mono-Regular"            ,
"BadScript-Regular"         ,   "Baloo2-Bold"                 ,
"Baloo2-Regular"            ,   "Bangers-Regular"             ,
"Barlow-Bold"               ,   "Barlow-Italic"               ,
"Barlow-Regular"            ,   "BarlowCondensed-Bold"        ,
"BarlowCondensed-Italic"    ,   "BarlowCondensed-Regular"     ,
"BebasNeue-Regular"         ,   "BerkshireSwash-Regular"      ,
"BreeSerif-Regular"         ,   "Bungee-Regular"              ,
"BungeeHairline-Regular"    ,   "BungeeOutline-Regular"       ,
"BungeeShade-Regular"       ,   "Cairo-Bold"                  ,
"Cairo-Regular"             ,   "CarterOne"                   ,
"CaveatBrush-Regular"       ,   "CinzelDecorative-Bold"       ,
"CinzelDecorative-Regular"  ,   "Coda-Regular"                ,
"ConcertOne-Regular"        ,   "Cookie-Regular"              ,
"CormorantGaramond-Bold"    ,   "CormorantGaramond-Italic"    ,
"CormorantGaramond-Regular" ,   "Courgette-Regular"           ,
"CourierPrime-Bold"         ,   "CourierPrime-Italic"         ,
"CourierPrime-Regular"      ,   "CrimsonText-Bold"            ,
"CrimsonText-Italic"        ,   "CrimsonText-Regular"         ,
"CutiveMono-Regular"        ,   "Damion-Regular"              ,
"DMMono-Italic"             ,   "DMMono-Regular"              ,
"DMSerifDisplay-Italic"     ,   "DMSerifDisplay-Regular"      ,
"EkMukta-Bold"              ,   "EkMukta-Regular"             ,
"FiraMono-Bold"             ,   "FiraMono-Regular"            ,
"FiraSans-Bold"             ,   "FiraSans-Italic"             ,
"FiraSans-Regular"          ,   "FiraSansCondensed-Bold"      ,
"FiraSansCondensed-Italic"  ,   "FiraSansCondensed-Regular"   ,
"FrederickatheGreat-Regular",   "FredokaOne-Regular"          ,
"FugazOne-Regular"          ,   "GloriaHallelujah"            ,
"GreatVibes-Regular"        ,   "Gruppo-Regular"              ,
"Handlee-Regular"           ,   "IndieFlower-Regular"         ,
"Kalam-Bold"                ,   "Kalam-Regular"               ,
"Kanit-Bold"                ,   "Kanit-Italic"                ,
"Kanit-Regular"             ,   "KaushanScript-Regular"       ,
"Lalezar-Regular"           ,   "Lato-Bold"                   ,
"Lato-Italic"               ,   "Lato-Regular"                ,
"LemonadaVFBeta"            ,   "LibreBaskerville-Bold"       ,
"LibreBaskerville-Italic"   ,   "LibreBaskerville-Regular"    ,
"LilitaOne-Regular"         ,   "Lobster-Regular"             ,
"LobsterTwo-Bold"           ,   "LobsterTwo-Italic"           ,
"LobsterTwo-Regular"        ,   "MajorMonoDisplay-Regular"    ,
"Mali-Bold"                 ,   "Mali-Italic"                 ,
"Mali-Regular"              ,   "MarckScript-Regular"         ,
"Merienda-Bold"             ,   "Merienda-Regular"            ,
"MeriendaOne-Regular"       ,   "Merriweather-Bold"           ,
"Merriweather-Italic"       ,   "Merriweather-Regular"        ,
"Monoton-Regular"           ,   "Montserrat-Bold"             ,
"Montserrat-Italic"         ,   "Montserrat-Regular"          ,
"MontserratAlternates-Bold" ,   "MontserratAlternates-Italic" ,
"MontserratAlternates-Regular", "MontserratSubrayada-Bold"    ,
"MontserratSubrayada-Regular" , "MrDafoe-Regular"             ,
"Mukta-Bold"                ,   "Mukta-Regular"               ,
"MuktaMahee-Bold"           ,   "MuktaMahee-Regular"          ,
"MuktaMalar-Bold"           ,   "MuktaMalar-Regular"          ,
"MuktaVaani-Bold"           ,   "MuktaVaani-Regular"          ,
"NanumBrushScript-Regular"  ,   "NanumGothic-Bold"            ,
"NanumGothic-Regular"       ,   "NanumGothicCoding-Bold"      ,
"NanumGothicCoding-Regular" ,   "NanumMyeongjo-Bold"          ,
"NanumMyeongjo-Regular"     ,   "NanumPenScript-Regular"      ,
"Neucha"                    ,   "NothingYouCouldDo"           ,
"NotoSerif-Bold"            ,   "NotoSerif-Italic"            ,
"NotoSerif-Regular"         ,   "NovaMono"                    ,
"Nunito-Bold"               ,   "Nunito-Italic"               ,
"Nunito-Regular"            ,   "NunitoSans-Bold"             ,
"NunitoSans-Italic"         ,   "NunitoSans-Regular"          ,
"OleoScript-Bold"           ,   "OleoScript-Regular"          ,
"OleoScriptSwashCaps-Bold"  ,   "OleoScriptSwashCaps-Regular" ,
"OverpassMono-Bold"         ,   "OverpassMono-Regular"        ,
"OxygenMono-Regular"        ,   "Pacifico-Regular"            ,
"Pangolin-Regular"          ,   "Parisienne-Regular"          ,
"PassionOne-Bold"           ,   "PassionOne-Regular"          ,
"PatrickHand-Regular"       ,   "PatuaOne-Regular"            ,
"Playball-Regular"          ,   "PoiretOne-Regular"           ,
"Poppins-Bold"              ,   "Poppins-Italic"              ,
"Poppins-Regular"           ,   "Prata-Regular"               ,
"PressStart2P-Regular"      ,   "RalewayDots-Regular"         ,
"Righteous-Regular"         ,   "RubikMonoOne-Regular"        ,
"RubikOne-Regular"          ,   "Sacramento-Regular"          ,
"ShareTechMono-Regular"     ,   "Shrikhand-Regular"           ,
"SigmarOne-Regular"         ,   "SourceCodePro-Bold"          ,
"SourceCodePro-Italic"      ,   "SourceCodePro-Regular"       ,
"SourceSansPro-Bold"        ,   "SourceSansPro-Italic"        ,
"SourceSansPro-Regular"     ,   "SourceSerifPro-Bold"         ,
"SourceSerifPro-Italic"     ,   "SourceSerifPro-Regular"      ,
"SpaceMono-Bold"            ,   "SpaceMono-Italic"            ,
"SpaceMono-Regular"         ,   "Sriracha-Regular"            ,
"Staatliches-Regular"       ,   "Tangerine-Bold"              ,
"Tangerine-Regular"         ,   "Taviraj-Bold"                ,
"Taviraj-Italic"            ,   "Taviraj-Regular"             ,
"TitanOne-Regular"          ,   "TitilliumWeb-Bold"           ,
"TitilliumWeb-Italic"       ,   "TitilliumWeb-Regular"        ,
"UnicaOne-Regular"          ,   "VT323-Regular"               ,
"YesevaOne-Regular"         ,   "ZillaSlab-Bold"              ,
"ZillaSlab-Italic"          ,   "ZillaSlab-Regular"           ,
"ZillaSlabHighlight-Bold"   ,   "ZillaSlabHighlight-Regular"
)

# Output of the neural network is numerical, this converts it to the actual font names
decode_dataframe <- data.frame(numeric = 0:199, font_name = font_list)
decode_result <- function(input){
  # Function takes in numeric value returned from neural network 
  # and returns the name of the predicted font
  name <- decode_dataframe %>%
    filter(numeric == input) %>%
    pull(font_name) %>%
    as.character()
  
  # Add spacing to names to make more legible output
  name <- gsub("([a-z])([A-Z])","\\1 \\2", name)
  name <- gsub("-", " - ", name)
  return(name)
}

get_top_3_classes <- function(data_point, nn_model){
  # This function takes in a single point of data as well as a trained neural netowrk
  # model, and returns the top 3 predicted classes for the data
  percentages <- nn_model %>%
    predict(k_reshape(data_point, c(1, 28, 140, 1)))
  
  top3indices <- order(percentages, decreasing = TRUE)[1:3]
  percentages[, top3indices]
  cat("Some similar fonts may be:",
      paste(decode_result(top3indices[1] - 1)),
      paste(decode_result(top3indices[2] - 1)),
      paste(decode_result(top3indices[3] - 1)),
      sep = "\n"
  )
}
