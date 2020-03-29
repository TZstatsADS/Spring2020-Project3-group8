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
