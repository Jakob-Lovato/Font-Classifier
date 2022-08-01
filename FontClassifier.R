# Data downloaded from https://www.kaggle.com/datasets/nikbearbrown/tmnist-alphabet-94-characters

library(tidyverse)
library(keras)
library(jpeg)

# Read in data
tmnist <- read.csv("/Users/jakoblovato/Desktop/Projects/Font Classifier/94_character_TMNIST.csv",
                   header = TRUE)

### Data pre-processing

# I remove symbols/any character not an upper/lower case letter or a number
# Symbols make up a large percent of the data and I want to focus on characters

data <- tmnist %>%
  filter(labels %in% c('0', '1', '2', '3', '4', '5', '6', 
                        '7', '8', '9', 'a', 'b', 'c', 'd', 
                        'e', 'f', 'g', 'h', 'i', 'j', 'k', 
                        'l', 'm', 'n', 'o', 'p', 'q', 'r', 
                        's', 't', 'u', 'v', 'w', 'x', 'y', 
                        'z', 'A', 'B', 'C', 'D', 'E', 'F', 
                        'G', 'H', 'I', 'J', 'K', 'L', 'M', 
                        'N', 'O', 'P', 'Q', 'R', 'S', 'T', 
                        'U', 'V', 'W', 'X', 'Y', 'Z'))

# Check new data to make sure only letters and characters are included
data$labels %>% 
  unique() %>%
  sort()

# Some fonts only include digits or don't inlcude all 62 characters; remove them
lessthan62 <- data %>% 
  count(names) %>% 
  filter(n < 62) %>%
  pull(names)

data <- data %>% filter(!(names %in% lessthan62))

# Some fonts have many variations (i.e. bold, semibold, extrabold, extrabolditalic...)
# Try to remove some of the extraneous variations to reduce data size
# Also remove odd sounding fonts I can't find manually on google fonts
data <- data %>% 
  filter(!grepl("ExtraBold|ExtraLight|LightItalic|MediumItalic|BlackItalic|ExtraBoldItalic|ExtralightItalic|SemiBoldItalic|ExtraCondensed|ExtraLight|Expanded|SemiCondensed|ThinItalic|SemiBold|Medium|BoldItalic|Thin|Black|Arabic|Devanagari|Hebrew|KR|JP|IMF|wght|IBM|Hindi|Hind|GenBas|Inline|AveriaSans|AveriaSerif|HK|SC|TC|HK|PostNo|Light", names))

# The unused factor levels from the deleted symbols in the data are still 
# present; remove them
data$labels <- data$labels %>%
  droplevels() 
data$names <- data$names %>%
  droplevels()

levels(data$labels)

# Number of fonts
data$names %>% 
  levels() %>%
  length()


# Save this new smaller dataset to save on storage (the full dataset
# is over 900MB, the reduced dataset is about 23 MB)

#write.table(data, file = "62_char_200_font_tmnist", row.names = FALSE)


# There are 1322 font families, still too many I think to allow for enough training
# data to be made and to not run for too long... I decided to pick 200 fonts manually,
# based on popularity rankings from Google Fonts

# I tried to pick about equal amounts from the five category filters on Google fonts:
# serif, sans serif, display, handwriting, and monospace

# Google fonts changes what fonts are available sometimes, so there is a disconnect
# as to the available fonts on the website and what is in this dataset... not all
# manually chosen fonts on Google fonts are in this dataset and vice versa. I am picking
# from the available fonts on Google fonts as of July 2022

# While there are over 200 fonts in the following list, not all I listed are in the
# dataset. So only those 200 that are both on Google fonts (currently) and in the 
# dataset are selected.

selection <- c("RobotoSlab", "Merriweather", "Playfair", "Lora", "EBG",
               "NotoSerif", "EBGaramond", "LibreBaskerville", "SourceSerif",
               "Bitter", "Cinzel", "CrimsonText", "Arvo", "Taviraj", "CormorantSC",
               "BreeSerif", "CormorantGaramond", "Domine", "ZillaSlab", "Vollkorn",
               "DMSerifDisplay", "Prata",
               "Roboto", "OpenSans", "Lato", "Montserrat", "Poppins", "SourceSans",
               "Oswald", "Raleway", "Inter", "Ubuntu", "Nunito", "Mukta", "NunitoSans",
               "Rubik", "WorkSans", "NanumGothic", "FiraSans", "Quicksand", "Barlow",
               "Kanit", "TitilliumWeb", "Mulish", "Cairo", "Dosis",
               "BebasNeue", "Lobster", "Comfortaa", "AbrilFatface", "AlfaSlab",
               "Righteous", "Fredoka", "Baloo2", "LobsterTwo", "PatuaOne", "PassionOne",
               "Staatliches", "ConcertOne", "PressStart2P", "PoiretOne", "SpecialElite",
               "YesevaOne", "Bangers", "Bungee", "CarterOne", "LuckiestGuy", "TitanOne",
               "Playball", "OleoScript", "Gruppo", "Coda", "UnicaOne", "Lalezar", 
               "Monoton", "LilitaOne", "SigmarOne", "Shrikhand", "Audiowide",
               "FugazOne", "FrederickatheGreat", "Lemonada", "Chewy", "BowblbyOne",
               "DancingScript", "Pacifico", "ShadowsIntoLight", "Caveat", "IndieFlower",
               "PermanentMarker", "AmaticSC", "Satisfy", "Courgette", "GreatVibes",
               "Kalam", "KaushanScript", "Cookie", "PatrickHand", "Sacramento", 
               "GloriaHallelujah", "Mali", "Yellowtail", "Tangerine", "ArchitectsDaughter",
               "Neucha", "BerkshireSwash", "Merienda", "HomemadeApple", "Allura", "Handlee",
               "Parisienne", "MarckScript", "RockSalt", "AlexBrush", "BadScript", "Sriracha",
               "Pangolin", "NothingYouCouldDo", "Nanum", "Damion", "MrDafoe", "CaveatBrush",
               "Inconsolata", "SourceCode", "SpaceMono", "UbuntuMono", "Cousine", "NanumGothic",
               "FiraMono", "ShareTechMono", "AnonymourPro", "CourierPrime", "OverpassMono",
               "CutiveMono", "VT323", "FiraCode", "JetBraineMono", "OxygenMono", "DMMono", 
               "NovaMono", "B612Mono", "MajorMono", "AzeretMono", "RedHatMono")

data <- data %>%
  filter(grepl(paste(selection, collapse = "|"), names))

data$names <- data$names %>%
  droplevels()

# Check number of fonts: there are now 200
data$names %>% 
  unique() %>% 
  length()

# Create new dataset comprised of combinations of 5 characters
# Create num_samples instances for each of the 200 fonts

generate_combos <- function(df, num_samples){
  # This function takes in a dataframe where each row represents one digit
  # and returns an array of num_samples random combinations of characters for each font
  
  # Each character is stripped of left and right padding and random spacing
  # is added between the 5 characters to allow the network to train for 
  # different kerning (the typographic term for the spacing between letters)
  
  # Create empty array to append new images to
  num_fonts <- levels(df$names) %>% length()
  x_combos <- array(0, c(num_samples * num_fonts, 28, 28 * 5, 1))
  #x_combos <- vector(mode = "list", length = num_samples * num_fonts)
  
  font_list <- df$names %>% levels() %>% unique()
  
  iter_count <- 1
  
  for(font in font_list){
    data_subset <- df %>% filter(names == font)
    for(i in 1:num_samples){
      selected_labels <- sample(unique(data_subset$labels),
                                size = 5,
                                replace = FALSE) %>% droplevels()
      
      characters <- data_subset %>% 
        filter(labels %in% selected_labels) %>%
        select(-c("names", "labels"))
      
      char1 <- matrix(as.numeric(characters[1, ]), nrow = 28, byrow = TRUE)
      # Strip left and right padding (i.e. columns of all 0s)
      char1 <- char1[ , colSums(char1) > 0]
      
      char2 <- matrix(as.numeric(characters[2, ]), nrow = 28, byrow = TRUE)
      char2 <- char2[ , colSums(char2) > 0]
      
      char3 <- matrix(as.numeric(characters[3, ]), nrow = 28, byrow = TRUE)
      char3 <- char3[ , colSums(char3) > 0]
      
      char4 <- matrix(as.numeric(characters[4, ]), nrow = 28, byrow = TRUE)
      char4 <- char4[ , colSums(char4) > 0]
      
      char5 <- matrix(as.numeric(characters[5, ]), nrow = 28, byrow = TRUE)
      char5 <- char5[ , colSums(char5) > 0]
      
      # Select random kerning- between 1 and 10 columns between letters
      kerning <- matrix(0, nrow = 28, ncol = sample(1:10, 1))
      
      combo <- cbind(kerning, char1,
                     kerning, char2,
                     kerning, char3,
                     kerning, char4,
                     kerning, char5,
                     kerning)
      
      # The CNN will take in objects of dimension 28 x (28 * 5) , 28 x 140
      # Pad or crop sides to get width of 140
      
      # If too wide:
      if(ncol(combo) > 140){
        while(ncol(combo) > 140){
          # Randomly pick leftmost or rightmost column to delete
          index <- sample(c(1, ncol(combo)), 1)
          combo <- combo[ , -index]
        }
      }
      
      # If too narrow:
      if(ncol(combo < 140)){
        # Generate blank column to add
        new_col <- matrix(0, nrow = 28)
        while(ncol(combo) < 140){
          # Randomly pick left or right to add column
          side <- sample(c("left", "right"), 1)
          if(side == "left"){
            combo <- cbind(new_col, combo)
          }
          else{
            combo <- cbind(combo, new_col)
          }
        }
      }
      
      # Add the 5 character combo to the pre-made array to store the training data
      x_combos[iter_count,,,] <- combo
      iter_count <- iter_count + 1
    }
  }
  # simplify2array() takes the list of individual matrices and combines them to an array
  # simplify2array() stacks based on the third axis, so aperm() reorders the axes since
  # keras wants the number of samples as the first axis
  # Finally, k_reshape() is used just to add the fourth axis of 1, representing the
  # single color channel for each image
  # x_combos <- x_combos %>%
  #   simplify2array() %>%
  #   aperm(c(3, 1, 2)) %>%
  #   k_reshape(c(num_samples * num_fonts, 28, 140, 1)) %>%
  #   as.array()
  
  
  return(x_combos)
}

# Generate training data
x <- generate_combos(data, 250)

# Standardize values
x <- x / 255

# Generate sample image of random data point
plot(as.raster(x[sample(1:nrow(x), 1),,,]))

# Create response variable
font_list <- data$names %>% 
  levels() %>% 
  unique()

y_numeric <- font_list %>%
  as.factor() %>%
  rep(each = 250) %>%
  as.numeric()

# One-hot-encode response
# Subtract 1 since keras uses python - encoding needs to start at 0, not 1
y <- to_categorical(y_numeric - 1, num_classes = 200)

# Generate validation data (25 combos for each font)
x_val <- generate_combos(data, 25)
x_val <- x_val / 255

y_val_numeric <- font_list %>%
  as.factor() %>%
  rep(each = 25) %>%
  as.numeric()

y_val <- to_categorical(y_val_numeric - 1, num_classes = 200)

# Create functions to later use to decode output of network
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


# Scramble x and y data (both will be scrambled in same order)
scramble <- sample(1:50000)
x_train <- x[scramble,,,] %>% 
  k_reshape(c(50000, 28, 140, 1)) %>%
  as.array()
y_train <- y[scramble, ]

scramble_val <- sample(1:5000)
x_test <- x_val[scramble_val,,,] %>%
  k_reshape(c(5000, 28, 140, 1)) %>%
  as.array()
y_test <- y_val[scramble_val, ]

### Create model

# Define Convolutional Neural Netowork
model <- keras_model_sequential() %>%
  layer_conv_2d(filters = 32, 
                kernel_size = c(3, 3),
                padding = "same",
                activation = "relu",
                input_shape = c(28, 140, 1)) %>%
  layer_max_pooling_2d(pool_size = c(2, 2)) %>%
  layer_conv_2d(filters = 64,
                kernel_size = c(3, 3),
                padding = "same",
                activation = "relu") %>%
  layer_max_pooling_2d(pool_size = c(2, 2)) %>%
  layer_conv_2d(filters = 128,
                kernel_size = c(3, 3),
                padding = "same",
                activation = "relu") %>%
  layer_max_pooling_2d(pool_size = c(2, 2)) %>%
  layer_flatten() %>%
  layer_dropout(rate = 0.4) %>%
  layer_dense(units = 256,
              activation = "relu") %>%
  layer_dense(units = 200, activation = "softmax")

model %>% compile(loss = "categorical_crossentropy",
                   optimizer = optimizer_rmsprop(),
                   metrics = c("accuracy"))

history <- model %>% fit(x = x_train,
                         y = y_train,
                         epochs = 10,
                         batch_size = 128,
                         validation_data = list(x_test, y_test)
)

# Save model
save_model_tf(model, "saved_model/my_model")

# Try predicting one of the validation images
plot(as.raster(x_test[123,,,]))
model %>% 
  predict(k_reshape(x_test[123,,,], c(1, 28, 140, 1))) %>%
  k_argmax() %>%
  as.numeric() %>%
  decode_result()
# True font
y_test[123,] %>%
  {which((.) == 1)} %>%
  {decode_result((.) - 1)}


# Now predict probabilities of belonging to a certain class, i.e. return the most
# similar font

get_top_3_classes <- function(data_point, nn_model){
  # This function takes in a single point of data as well as a trained neural netowrk
  # model, and returns the top 3 predicted classes for the data
  percentages <- nn_model %>%
    predict(k_reshape(data_point, c(1, 28, 140, 1)))
  
  top3indices <- order(percentages, decreasing = TRUE)[1:3]
  percentages[, top3indices]
  cat("The 3 most similar fonts are:",
      paste(decode_result(top3indices[1] - 1), ": ", round(percentages[, top3indices[1]], 4) * 100, "%", sep = ""),
      paste(decode_result(top3indices[2] - 1), ": ", round(percentages[, top3indices[2]], 4) * 100, "%", sep = ""),
      paste(decode_result(top3indices[3] - 1), ": ", round(percentages[, top3indices[3]], 4) * 100, "%", sep = ""),
      sep = "\n"
  )
}

plot(as.raster(x_test[125,,,]))
get_top_3_classes(x_test[125,,,], model)
# True font
y_test[125,] %>%
  {which((.) == 1)} %>%
  {decode_result((.) - 1)}

# Classify a non-synthetic test point! Upload screenshot of random font and get 
# similar fonts as output
# One font I know is not in the dataset is Helvetica, so I will test that font

library(imager)
helvetica <- load.image("/Users/jakoblovato/Desktop/Projects/Font Classifier/Test Images/helvetica_hello_cropped.png")
str(helvetica)

# Reshape image
helvetica <- helvetica %>% 
  resize(size_x = 140, size_y = 28, size_c = 1, interpolation_type = 2) %>%
  as.array() %>%
  aperm(c(3, 2, 1, 4))

# Make background 0, foreground 1
helvetica <- 1 - helvetica

# Standardize
helvetica <- (helvetica - mean(helvetica)) / sd(helvetica)
helvetica <- (helvetica - min(helvetica)) / (max(helvetica) - min(helvetica))
plot(as.raster(helvetica[1,,,]))

get_top_3_classes(helvetica, model)

# Now try a photograph of text to see how it can classify
library(imagerExtra)
lavender <- load.image("/Users/jakoblovato/Desktop/Projects/Font Classifier/Test Images/lavener.png")
str(lavender)

# Reshape image and converto to greyscale and adjust black and white threshold
lavender <- lavender %>%
  grayscale() %>%
  ThresholdTriclass(stopval = 0.01) %>%
  resize(size_x = 140, size_y = 28, size_c = 1, interpolation_type = 2) %>%
  as.array() %>%
  aperm(c(3, 2, 1, 4))

plot(as.raster(lavender[1,,,]))

# Make background 0, foreground 1
lavender <- 1 - lavender

lavender <- (lavender - mean(lavender)) / sd(lavender)
lavender <- (lavender - min(lavender)) / (max(lavender) - min(lavender))


plot(as.raster(lavender[1,,,]))

get_top_3_classes(lavender, model)

# The predictions don't look very accurate when cross-checking the actual fonts
# on Google fonts... perhaps because this image has 6 letters instead of 5
lavender_5 <- load.image("/Users/jakoblovato/Desktop/Projects/Font Classifier/Test Images/lavender_5_letters.png")

lavender_5 <- lavender_5 %>%
  rm.alpha() %>% #remove alpha color channel since I annotated this image to crop to 5 letters
  grayscale() %>%
  ThresholdTriclass(stopval = 0.01) %>%
  resize(size_x = 140, size_y = 28, size_c = 1, interpolation_type = 2) %>%
  as.array() %>%
  aperm(c(3, 2, 1, 4))

lavender_5 <- 1 - lavender_5
plot(as.raster(lavender_5[1,,,]))

get_top_3_classes(lavender_5, model)
# Suggested fonts now look a bit more accurate...

# Try another image
chili <- load.image("/Users/jakoblovato/Desktop/Projects/Font Classifier/Test Images/chili.png")
chili <- chili %>%
  rm.alpha() %>% #remove alpha color channel since I annotated this image to crop to 5 letters
  grayscale() %>%
  ThresholdTriclass(stopval = 0.01) %>%
  resize(size_x = 140, size_y = 28, size_c = 1, interpolation_type = 2) %>%
  as.array() %>%
  aperm(c(3, 2, 1, 4))

chili <- 1 - chili
plot(as.raster(chili[1,,,]))

get_top_3_classes(chili, model)
# Here, the 1.1% suggestion (Righteous) looks far more similar to the font in the
# photo than the 85.87% suggestion (Barlow Bold) does