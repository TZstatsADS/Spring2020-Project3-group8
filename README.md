# Project: Can you recognize the emotion from an image of a face? 
<img src="figs/CE.jpg" alt="Compound Emotions" width="500"/>
(Image source: https://www.pnas.org/content/111/15/E1454)

### [Full Project Description](doc/project3_desc.md)

Term: Spring 2020

+ Team ##8
+ Team members
	+ Jiancong Shen
	+ Vikki Sui
	+ Jinxu Xiang
	+ Ruiqi Xie
	+ Wenjie Xie


+ **Project summary**: In this project, our goal is to create an efficient classifier to classifity people's emotion on a given image. We pre-transformed the image to make all the faces verticle, standardized the length of the face based on a chosen reference, then translated to make the nose center be the origin of the coordinates. Then we did feature choosing. We mainly chose the distance feature, angle feature, color feature to improve the accuracy and the feature has 129 dimensions without the color features and has 139 dimensions with the color feature. Finally we used GBM as baseline, improved it and used SVM and XGB model to train the model and get the prediction on the test sets. We compare between models based on the prediction accuracy and time complexity and decided that we would want to use SVM model with color features to be our final model. 

+ The link to the full presentation is [here](https://drive.google.com/open?id=1Etw7MyvmSV-0R2BUFPqC3wIcLoSIDRlK)

+ **Training data**: 2500 images of 230 people, each with corresponding 78 fiducial points. We split 80% of the people as training set and the remaining as the test set to do model selection. In this case, the number of training data is around 2000 and test data is the rest. For in-class test, we use all 2500 images with corresponding points as training set.

+ **Test data**: Another 2500 images of unknown number of people, which will be given 30 minutes prior to the class and we need to finish the prediction in 30 minutes. We predict that the calculation will be completed within 5 minutes and reach 58% accuracy.

+ **Final result**:
The training time is time for training about 2000 data and the test time is time for predicting about 500 data.

|       | test accuracy | model training time | total training time | test prediction time | total prediction time | 
| ------ | ------ | ------ | ------ | ------ | ------ | 
| gbm_baseline | 45.6% | 1960s | 1961s | 13.3s | 13.4s |
| gbm_improved | 46.2% | 42.9s | 67.2s | 0.03s | 5.92s | 
| gbm_colored | 48.1% | 45.2s | 188s | 0.04s | 38.6s |
| svm_improved | 57.1% | 2.39s | 26.7s | 0.20s | 6.09s |
| svm_colored | 60.5% | 2.38s | 146s | 0.20s | 38.8s |
| xgb_improved | 52.9% | 45.2s | 69.5s | 0.06s | 5.95s |
| xgb_colored | 55.4% | 31.7s | 175s | 0.06s | 38.6s |

  
	
**Contribution statement**: 

Jinxu Xiang did the data pre-processing part which contains change_image function and its inverse function. These functions rotate, zoom, and translate the points and image to standardize them. He also created the average points and worked with Ruiqi Xie on ploting the average images, which help us visualized the difference between each pair of emotions. Everyone worked together on providing ideas of feature extraction and considering possible models. Wenjie Xie and Jiancong Shen compared the difference between 220 facial ecpression category pairs and added some improved features into the feature function. Vikki Sui constructed the base feature model and did the color feature for the nasolabials folds. Ruiqi Xie did the color feature for the wrinkle between eyebrows. Jinxu Xiang improved algorithm speed of feature function and did the model training functions, test functions and the in class predicting file. Jinxu Xiang and Vikki Sui constructed the main.Rmd file including the feature extraction, model training, predicting, and diagnosis. 

For the presentation, Jinxu Xiang and Vikki Sui worked on the presentation materials together but Jinxu Xiang did the powerpoint and the video shooting. 

All team members approve our work presented in our GitHub repository including this contribution statement.

Following [suggestions](http://nicercode.github.io/blog/2013-04-05-projects/) by [RICH FITZJOHN](http://nicercode.github.io/about/#Team) (@richfitz). This folder is orgarnized as follows.

```
proj/
├── lib/
├── data/
├── doc/
├── figs/
└── output/
```

Please see each subfolder for a README file.
