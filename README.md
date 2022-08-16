# font-classifier
Convolutional Neural Network to Classify Fonts

This model is deployed as a web app using Shiny: http://jakoblovato.shinyapps.io/findafont/

Data from: https://www.kaggle.com/datasets/nikbearbrown/tmnist-alphabet-94-characters

This dataset contains over over 281,000 images of individual letters and characters from over two thousand fonts pulled from [Google Fonts](https://fonts.google.com).

It is a common task of graphic designers to try and find the names of fonts seen in the real world (i.e. billboards, movie posters, other graphic designers' works, etc.), to use in their own works. This can be challanging, as unless one knows who made the design or has a very trained eye for fonts, typically asking around is the only way to discover what the font is.

This model uses a convolutional neural network using Keras to identify fonts or suggest similar fonts to the user's input which are freely available on Google Fonts. I chose a subset of 200 of the most popular fonts on Google Fonts due to limited computing power. Due to this, the point of the model is not to identify all fonts (there are hundreds of thousands? Millions?) but rather to suggest similar fonts to the one the user is trying to identify, since it is most likely that the text contained in user input isn't even from a font that is in the training data at all.

Because individual characters alone are not enough to train a CNN to identify fonts (each character is so vastly different on it's own, no patterns would be able to be picked up), I used the dataset to create a synthetic training set by creating 250 random combinations of upper & lower case letters, as well as the ten digits. Each training image was also given random kerning (the typographic term for the spacing between letters) so that the model wouldn't accidentally be trained to identify based on kerning.

Here are some sample training images:

<img width="481" alt="Screen Shot 2022-08-16 at 2 35 59 PM" src="https://user-images.githubusercontent.com/106411094/184989535-24782348-e020-406d-a64d-42d00f472725.png">

<img width="480" alt="Screen Shot 2022-08-16 at 2 36 14 PM" src="https://user-images.githubusercontent.com/106411094/184989574-55503d8d-52dd-4b5d-88a1-3618fab1dd21.png">

<img width="479" alt="Screen Shot 2022-08-16 at 2 36 37 PM" src="https://user-images.githubusercontent.com/106411094/184989614-183f5ebf-9d0e-4875-a1b3-efa91cdcb1f3.png">

<img width="479" alt="Screen Shot 2022-08-16 at 2 36 51 PM" src="https://user-images.githubusercontent.com/106411094/184989647-ed217c41-a406-43b4-84c3-435b2cb9f172.png">

<img width="479" alt="Screen Shot 2022-08-16 at 2 37 07 PM" src="https://user-images.githubusercontent.com/106411094/184989681-070615ca-5d15-479b-9524-43543fa0090d.png">

<img width="479" alt="Screen Shot 2022-08-16 at 2 37 20 PM" src="https://user-images.githubusercontent.com/106411094/184989722-3dc10200-c338-4c5f-9ac4-ed8e258ae054.png">

<img width="478" alt="Screen Shot 2022-08-16 at 2 37 42 PM" src="https://user-images.githubusercontent.com/106411094/184989775-cd3bea79-6dbe-4c04-a94f-2d73efa89c5c.png">

On a test set of data generated the same way as the training data, the model achieved about 89% accuracy of correctly classifying the font. However, this number really isn't very useful or meaningful as it is again using sterile synthetic data, and again, the point of the model is to take in images of text using fonts that aren't even in the trianing data, and to suggest the most similar matches.

Here are some examples of real world predictions. The first image is the uploaded image to be classified. The three images following it are screenshots from Google Fonts of each of the top 3 suggested fonts.

<img width="605" alt="Screen Shot 2022-08-16 at 2 47 10 PM" src="https://user-images.githubusercontent.com/106411094/184991074-a2116c0b-0eb2-4371-8176-cfb07b2820db.png">

The three suggested fonts are:

Source Serif Pro - Regular

<img width="233" alt="Screen Shot 2022-08-16 at 2 48 07 PM" src="https://user-images.githubusercontent.com/106411094/184991216-1ed50af1-eeaa-4ed1-b781-4ec7c1d1c016.png">

Cormorant Garamond - Bold

<img width="201" alt="Screen Shot 2022-08-16 at 2 48 36 PM" src="https://user-images.githubusercontent.com/106411094/184991299-a9d80bd6-2cf3-441b-b185-5c3a6c935c87.png">

Nanum Myeongjo - Bold

<img width="198" alt="Screen Shot 2022-08-16 at 2 49 04 PM" src="https://user-images.githubusercontent.com/106411094/184991351-acfd7022-4057-4a83-8c5f-136f926b7152.png">


Sometimes the results are more hit or miss:

<img width="592" alt="Screen Shot 2022-08-16 at 3 24 45 PM" src="https://user-images.githubusercontent.com/106411094/184995695-816832e4-2e67-4810-981e-4778804d693d.png">

The three suggested fonts are:

Sacramento - Regular

<img width="323" alt="Screen Shot 2022-08-16 at 3 26 11 PM" src="https://user-images.githubusercontent.com/106411094/184995839-6c3d532e-f48a-46be-b490-3cb642b84506.png">

Poiret One - Regular

<img width="334" alt="Screen Shot 2022-08-16 at 3 26 30 PM" src="https://user-images.githubusercontent.com/106411094/184995871-56510c44-0e1b-43d2-bc17-bbf2dce74a32.png">

Cinzel Decorative - Regular

<img width="441" alt="Screen Shot 2022-08-16 at 3 27 03 PM" src="https://user-images.githubusercontent.com/106411094/184995927-afb08893-9ec5-405c-9308-d7a6926bc823.png">

Here, the second suggestion is by far the most accurate. Sometimes with more edge cases (very thin fonts, very decorative fonts, etc.), the results vary like this case. But typically if the first font isn't a match, the second or third ones are pretty close. This could probably be improved with more training.
