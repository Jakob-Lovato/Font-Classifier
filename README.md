# font-classifier
Convolutional Neural Network to Classify Fonts

This model is deployed as a web app using Shiny: http://jakoblovato.shinyapps.io/findafont/

Data from: https://www.kaggle.com/datasets/nikbearbrown/tmnist-alphabet-94-characters

This dataset contains over over 281,000 images of individual letters and characters from over two thousand fonts pulled from [Google Fonts](https://fonts.google.com).

It is a common task of graphic designers to try and find the names of fonts seen in the real world (i.e. billboards, movie posters, other graphic designers' works, etc.), to use in their own works. This can be challanging, as unless one knows who made the design or has a very trained eye for fonts, typically asking around is the only way to discover what the font is.

This model uses a convolutional neural network to identify fonts or suggest similar fonts to the user's input which are freely available on Google Fonts. I chose a subset of 200 of the most popular fonts on Google Fonts due to limited computing power. Due to this, the point of the model is not to identify all fonts (there are hundreds of thousands? Millions?) but rather to suggest similar fonts to the one the user is trying to identify. 

Because individual characters alone are not enough to train a CNN to identify fonts (each character is so vastly different on it's own, no patterns would be able to be picked up), I used the dataset to create a synthetic training set by creating 250 random combinations of upper & lower case letters, as well as the ten digits. Each training image was also given random kerning (the typographic term for the spacing between letters) so that the model wouldn't accidentally be trained to identify based on kerning.

Here are some sample training images:

<img width="481" alt="Screen Shot 2022-08-16 at 2 35 59 PM" src="https://user-images.githubusercontent.com/106411094/184989535-24782348-e020-406d-a64d-42d00f472725.png">

<img width="480" alt="Screen Shot 2022-08-16 at 2 36 14 PM" src="https://user-images.githubusercontent.com/106411094/184989574-55503d8d-52dd-4b5d-88a1-3618fab1dd21.png">

<img width="479" alt="Screen Shot 2022-08-16 at 2 36 37 PM" src="https://user-images.githubusercontent.com/106411094/184989614-183f5ebf-9d0e-4875-a1b3-efa91cdcb1f3.png">

<img width="479" alt="Screen Shot 2022-08-16 at 2 36 51 PM" src="https://user-images.githubusercontent.com/106411094/184989647-ed217c41-a406-43b4-84c3-435b2cb9f172.png">

<img width="479" alt="Screen Shot 2022-08-16 at 2 37 07 PM" src="https://user-images.githubusercontent.com/106411094/184989681-070615ca-5d15-479b-9524-43543fa0090d.png">

<img width="479" alt="Screen Shot 2022-08-16 at 2 37 20 PM" src="https://user-images.githubusercontent.com/106411094/184989722-3dc10200-c338-4c5f-9ac4-ed8e258ae054.png">

<img width="478" alt="Screen Shot 2022-08-16 at 2 37 42 PM" src="https://user-images.githubusercontent.com/106411094/184989775-cd3bea79-6dbe-4c04-a94f-2d73efa89c5c.png">


