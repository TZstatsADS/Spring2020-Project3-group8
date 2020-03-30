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


+ **Project summary**: In this project, our goal is to create an efficient classifier to classifity people's emotion on a given image. We pre-transformed the image to make all the faces verticle, standardized the length of the face based on a chosen reference, then transformed to make the nose center be the origin of the coordinates. Then we did feature choosing. We mainly chose the distance feature, angle feature, color feature to improve the accuracy and the feature has 129 dimensions without the color features and has 139 dimensions with the color feature. Finally we used GBM as baseline, improved it and used SVM and XGB model to train the model and get the prediction on the test sets. We compare between models based on the prediction accuracy and time complexity and decided that we would want to use SVM model with color features to be our final model. 

+ **Training data**: 2500 images of 230 people, each with corresponding 78 fiducial points. We split 80% of the people as training set and the remaining as the test set to do model selection.

+ **Test data**: another 2500 images of unknown number of people, which will be given 30 minutes prior to the class and we need to finish the prediction in 30 minutes. 


+ **Final result**

|       | test accuracy | model training time | all training time | test prediction time | all prediction time | 
| ------ | ------ | ------ | ------ | ------ | ------ | 
| gbm_baseline | 45.6% | 1960s | 1961s | 13.3s | 13.4s |
| gbm_improved | 46.2% | 42.9s | 67.2s | 0.03s | 5.92s | 
| gbm_colored | 48.1% | 45.2s | 188s | 0.04s | 38.6s |
| svm_improved | 57.1% | 2.39s | 26.7s | 0.20s | 6.09s |
| svm_colored | 60.5% | 2.38s | 146s | 0.20s | 38.8s |
| xgb_improved | 52.9% | 45.2s | 67.2s | 0.06s | 5.95s |
| xgb_colored | 55.4% | 31.7s | 175s | 0.06s | 38.6s |

  
	
**Contribution statement**: 
+ Jiancong Shen:
+ Vikki Sui:
+ Jinxu Xiang:
+ Ruiqi Xie:
+ Wenjie Xie: Extract detailed features by comparing differences between 220 facial expression category pairs

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
