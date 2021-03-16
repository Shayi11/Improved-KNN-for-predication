function [outputArg] = KNNWwpred(inputArg1,inputArg2,inputArg3,inputArg4,inputArg5,inputArg6)
%带有内外权重的KNN预测
%   输入yanzheng、sgsj、最优K值、待测对象参数（输入1是空间预测，输入2是时间预测）、内权重、外权重确定方法，输出预测结果与真实结果
Kyanzheng=inputArg1;
Kyanzheng(:,inputArg4+1)=[];%根据待测对象参数，去掉对应的列
Kshijian=inputArg2;
Kshijian(:,inputArg4+1)=[];
K=inputArg3;
w=inputArg5;
way=inputArg6;
itemindex=inputArg4-1;%根据待预测对象参数，决定使用基于概率外权重的计算方法（如果用这个方法的话）里概率函数的选择

%开始预测过程
jieguozu=Kyanzheng(:,[1,2,3]);%定义变量以收录所有预测结果
jieguozu(:,3)=0;
for i=1:11
    julizu=[0,0];
    %计算第i个待预测样本与所有建模样本的距离
    yanzhengs=Kyanzheng(i,:);
    for j=1:103
        shijians=Kshijian(j,:);%这里的shijian是“事件”
        juli=KNNwdist(yanzhengs,shijians,w);
        julizu=[julizu;juli];
    end
    julizu(1,:)=[];
    julizu=sortrows(julizu);%根据距离排序
    julizu=julizu(1:K,:);%只保留前K行
    yucezu=0;
    %找到第i个待测样本的最近K个建模样本，并以其“时间/长度”的外权重加权平均数作为预测结果
    for m=1:K
        row=find(Kshijian(:,1)==julizu(m,2));
        yuce=Kshijian(row,2);
        yucezu=[yucezu;yuce];
    end
    yucezu(1)=[];
    %生成外权重
    if way==0
        W=Wprob(yucezu,itemindex);
    else
        W=Wdist(abs(yucezu-yanzhengs(2)));
    end
    %根据权重加权平均
    jieguo=sum(W.*yucezu);
    jieguozu(i,3)=jieguo;
end

%输出结果
outputArg=jieguozu;

end

