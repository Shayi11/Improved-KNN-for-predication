function [outputArg] = KNNbasetrain(inputArg1,inputArg2)
%基础款KNN的训练，寻找最优K用的
%   输入训练用数组和K值，输出该K值时的误差
sgscORcd=inputArg1;
K=inputArg2;

%先将sgscORcd组划分为训练组和测试组
%随机选取31条数据作为测试组，
hang=randperm(103);
hang([32:end])=[];
Ktest=sgscORcd(hang,:);
Ktrain=sgscORcd;
Ktrain(hang,:)=[];

%计算该K值时候的误差
junchazu=0;%定义变量以收录各测试样本与其最近K个训练样本的“时长/空间范围”之均差
for i=1:31
    tests=Ktest(i,:);
    %计算第i个测试样本与最近的K个训练样本的距离
    julizu=[0,0];%定义变量以收录第i个测试样本对应所有训练样本的距离
    for j=1:72
        trains=Ktrain(j,:);
        juli=KNNbasedist(tests,trains);%通过对该函数的修改，可设定不同的距离计算方式
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
    juncha=abs(mean(zuijinzu)-tests(2));%得到第i个测试样本与最近的K个训练样本的“时长/空间范围”之均差
    junchazu=[junchazu;juncha];
end
junchazu(1)=[];%去掉第一个数，因为是0

%输出结果
outputArg=mean(junchazu);

end

