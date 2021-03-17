function [outputArg] = KNNbasepred(inputArg1,inputArg2,inputArg3,inputArg4)
%基础款KNN预测
%   输入待预测数组、训练数组、最优K值、待测对象参数（输入1是空间预测，输入2是时间预测），输出预测结果与真实结果
Kyanzheng=inputArg1;
Kyanzheng(:,inputArg4+1)=[];%根据待测对象参数，去掉对应的列
Kshijian=inputArg2;
Kshijian(:,inputArg4+1)=[];
K=inputArg3;

%开始预测过程
jieguozu=Kyanzheng(:,[1,2,3]);%定义变量以收录所有预测结果
jieguozu(:,3)=0;
for i=1:11
    julizu=[0,0];
    %计算第i个待预测样本与所有建模样本的距离
    yanzhengs=Kyanzheng(i,:);
    for j=1:103
        shijians=Kshijian(j,:);%这里的shijian是“事件”
        juli=KNNbasedist(yanzhengs,shijians);
        julizu=[julizu;juli];
    end
    julizu(1,:)=[];
    julizu=sortrows(julizu);%根据距离排序
    julizu=julizu(1:K,:);%只保留前K行
    yucezu=0;
    %找到第i个待测样本的最近K个建模样本，并以其“时间/长度”的平均数作为预测结果
    for m=1:K
        row=find(Kshijian(:,1)==julizu(m,2));
        yuce=Kshijian(row,2);
        yucezu=[yucezu;yuce];
    end
    yucezu(1)=[];
    jieguo=mean(yucezu);
    jieguozu(i,3)=jieguo;
end

%输出结果
outputArg=jieguozu;

end

