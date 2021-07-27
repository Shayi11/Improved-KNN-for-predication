function [outputArg] = KNNWtrain(inputArg1,inputArg2,inputArg3,inputArg4)
%两向量距离的计算引入内权重，使用基于概率的方法计算外权重
%   输入sgcd或sgsc数组、K值、内权重、外权重确定方法参数（0为基于概率的，1为基于距离的），输出该K值时的误差
sgscORcd=inputArg1;
K=inputArg2;
w=inputArg3;
way=inputArg4;
shuliang=length(sgscORcd);%用于训练的数据数量

%归一化处理
for i=1:14
    temp=mapminmax(sgscORcd(:,i+2)',0,1)
    sgscORcd(:,i+2)=temp';
end

%判断输入的数据是时长还是长度，因为它们的密度函数不同
if mean(sgscORcd(:,2))<1000
    itemindex=1;%此时为时长
else
    itemindex=0;%此时为长度
end

%先将sgscORcd组划分为训练组和测试组
%随机选取30%条数据作为测试组，
hang=randperm(shuliang);
hang([floor(shuliang*0.1):end])=[];
Ktest=sgscORcd(hang,:);
Ktrain=sgscORcd;
Ktrain(hang,:)=[];

%计算该K值时候的误差
junchazu=0;%定义变量以收录各测试样本与其最近K个训练样本的“时长/空间范围”之均差
for i=1:(floor(shuliang*0.1)-1)
    tests=Ktest(i,:);
    %计算第i个测试样本与最近的K个训练样本的距离
    julizu=[0,0];%定义变量以收录第i个测试样本对应所有训练样本的距离
    for j=1:(shuliang+1-floor(shuliang*0.1))
        trains=Ktrain(j,:);
        juli=KNNwdist(tests,trains,w);%通过对该函数的修改，可设定不同的距离计算方式
        julizu=[julizu;juli];
    end
    julizu(1,:)=[];%去掉第一行，因为是0，0
    julizu=sortrows(julizu);%根据距离排序
    julizu=julizu(1:K,:);%只保留前K行
    %计算第i个测试样本与最近的K个训练样本的“时长/空间范围”之均差
    zuijinzu=0;%定义变量以收录第i个测试样本的最近K个训练样本
    for m=1:K
        row=find(Ktrain(:,1)==julizu(m,2));
        zuijin=Ktrain(row,2);
        zuijinzu=[zuijinzu;zuijin];
    end
    zuijinzu(1)=[];%去掉第一个数，因为是0
    %生成外权重
    if way==0%此时使用概率方法
        W=Wprob(zuijinzu,itemindex);
    else%此时使用距离方法
        W=Wdist(abs(zuijinzu-tests(2)));
    end
    juncha=W'*abs(zuijinzu-tests(2))%abs(sum(W.*zuijinzu)-tests(2));%得到第i个测试样本与最近的K个训练样本的“时长/空间范围”之带有外权重的差
    junchazu=[junchazu;juncha];
end

junchazu(1)=[];%去掉第一个数，因为是0

%输出结果
outputArg=mean(junchazu);

end
