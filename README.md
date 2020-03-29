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

+ Final result

|       | test accuracy | model training time | all training time | test prediction time | all prediction time | 
| ------ | ------ | ------ | ------ | ------ | ------ | 
| gbm_baseline | 45.6% | 1960s | 1961s | 13.3s | 13.4s |
| gbm_improved | 46.2% | 42.9s | 67.2s | 0.03s | 5.92s | 
| gbm_colored | 48.1% | 45.2s | 188s | 0.04s | 68.6s |
| svm_improved | 57.1% | 2.39s | 26.7s | 0.20s | 6.09s |
| svm_colored | 60.5% | 2.38s | 146s | 0.20s | 38.8s |
| xgb_improved | 52.9% | 45.2s | 67.2s | 0.06s | 5.95s |
| xgb_colored | 55.4% | 31.7s | 175s | 0.06s | 38.6s |

  

+ Project summary: In this project, we created a classification engine for facial emotion recognition. We first did the data cleaning process. By zooming, rotating and choosing the poinnts, we put all the faces in the images horizontal. Then we did feature choosing.
We mainly chose the distance feature, angle feature, color feature to improve the accuracy. Finally we used GBM as baseline, improved it and used SVM and XGB model to predict facial emotion. 
	
**Contribution statement**: ([default](doc/a_note_on_contributions.md)) All team members contributed equally in all stages of this project. All team members approve our work presented in this GitHub repository including this contributions statement. 

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
