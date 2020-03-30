# Project: Can you recognize the emotion from an image of a face?

### Doc folder

**Average_images**: the Rmd and html file of Average_images contains the images that overlaid all the images under a same emotion. We observed the pairwise images of each two emotions and then compare between the images to try to figure out color difference between two emotions. 

**Average_points**: the Rmd and html file of Average_points contains the plot of average 78 fiducial points of each emotion. From the pairwise comparison plot, we can get to see which of the distance features we want to keep and which of the angle features we want to add to the feature function.

**Image_Rotation**: the Rmd and html file of Image_Rotation gives the procedure of rotating, zooming, and transforming the data we did before we extract the features.

**Inv Rotation**: this file gives the inverse function of image rotation. Since rotating all the image would take too much time, we would like to transform the 78 fiducial points, find the coordinates of the area we are interested in, use the inverse function to find the corresponding area on the nontransform image and get the color information.

**Main**: This is the main file where we did the modeling training, prediction, and the analysis.

**feature_visualization**: This is the file which help us see how features are different between different emotions. By looking at this file, we will get a basic idea of the relationship between fiducial points and prediction.
