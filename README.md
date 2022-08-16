# font-classifier
Convolutional Neural Network to Classify Fonts

This model is deployed as a web app using Shiny: http://jakoblovato.shinyapps.io/findafont/

Data from: https://www.kaggle.com/datasets/nikbearbrown/tmnist-alphabet-94-characters

This dataset contains over over 281,000 images of individual letters and characters from over two thousand fonts pulled from [Google Fonts](https://fonts.google.com).

It is a common task of graphic designers to try and find the names of fonts seen in the real world (i.e. billboards, movie posters, other graphic designers' works, etc.), to use in their own works. This can be challanging, as unless one knows who made the design or has a very trained eye for fonts, typically asking around is the only way to discover what the font is.

This model uses a convolutional neural network to identify fonts or suggest similar fonts to the user's input which are freely available on Google Fonts. I chose a subset of 200 of the most popular fonts on Google Fonts due to limited computing power. Due to this, the point of the model is not to identify all fonts (there are hundreds of thousands? Millions?) but rather to suggest similar fonts to the one the user is trying to identify. 

Because individual characters alone are not enough to train a CNN to identify fonts (each character is so vastly different on it's own, no patterns would be able to be picked up), I used the dataset to create a synthetic training set by creating 250 random combinations of upper & lower case letters, as well as the ten digits. Each training image was also given random kerning (the typographic term for the spacing between letters) so that the model wouldn't accidentally be trained to identify based on kerning.

Here are some sample training images:

![image](https://user-images.githubusercontent.com/106411094/184989152-de131693-eb51-4743-81d1-31f23e056d91.png)

![image](https://user-images.githubusercontent.com/106411094/184989185-ab2b7846-318d-4756-b110-8aa105981100.png)

![image](https://user-images.githubusercontent.com/106411094/184989222-828d57f2-8d09-4a9e-b184-6a03098257f4.png)

![image](https://user-images.githubusercontent.com/106411094/184989253-20c5c196-fdfe-4fdf-89b0-c91220848506.png)

![image](https://user-images.githubusercontent.com/106411094/184989298-5c53f735-3de4-4316-b312-aa4ae5b71318.png)
