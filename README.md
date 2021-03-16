# Improved-KNN-for-predication
使用MATLAB进行基本KNN的建模以及改进KNN的建模

转载使用请注明出处(●'◡'●)，还请多多star~

部分代码里的空间预测/时间预测是适用于某项目，可自行决定是否使用该变量

基本KNN
KNNbasedist是基础款KNN的两向量距离计算
KNNbasetrain是基础KNN在K值下的训练误差的计算
KNNbaseopt是基础款KNN最优K值的探索
KNNbasepred是基础KNN预测

内权重算法两个:
wC45是C4.5算法计算内权重值
hdeter是AFW分类算法h值的输入(附属于wAFW)
wAFW是AFW分类算法计算内权重值

外权重算法两个:
Wprobe是基于概率的外权重值计算
Wdist是基于距离的外权重值计算

改进KNN
KNNwdist是具有内权重的两向量距离计算
KNNWtrain是具有内外权重的KNN在K值下的训练误差的计算
KNNWwopt是具有内外权重的KNN最优K值的探索
KNNWwpred是具有内外权重的KNN预测

内权重ω：Distance=‖ω∙(x_PRE-x_OLD )‖
外权重W：〖Y〗_PRE=∑_1^(K_optimal)▒〖W_Y∙〖Y〗_OLD 〗
外权重就是KNN模型中，决定中心点的K个点的权重值（下图中的箭头点）；内权重就是KNN模型中计算距离时各自变量的权重
![image](https://user-images.githubusercontent.com/55230503/111304230-73bb4f00-8690-11eb-83f5-e4ef55360c78.png)
