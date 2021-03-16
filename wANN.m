function [outputArg,outputArg1] = wANN(inputArg)
%使用ANN生成算法内权重，需要注意的是，由于现在没有流量数据，所以生成出来的权重会少一位，恰好就是流量的权重，所以可先默认流量的权重为0
%   算法的输入为sgsc或sgcd，输出为各影响变量的权重
sgscORcd=inputArg;
Y=sgscORcd(:,2);
X=sgscORcd(:,[3:end]);
X=X';
Y=Y';
trainFcn = 'trainlm';  % 使用内置的Levenberg-Marquardt算法作为梯度调整算法
hiddenLayerSize = 10;%设定隐藏层有10个节点
net = fitnet(hiddenLayerSize,trainFcn);%建立训练网络
%对数据集分割，分别是训练集、验证集和测试集
net.divideParam.trainRatio = 70/100;
net.divideParam.valRatio = 15/100;
net.divideParam.testRatio = 15/100;
%开始训练
E=inf;
netbest={0};
for i=1:1000%训练100次
    [net,tr] = train(net,X,Y);%net是训练好的网络；tr为训练记录包括训练的次数和性能
    %测试训练结果
    y=net(X);
    e=abs(mean(gsubtract(Y,y)));%计算误差，gsubtract是列相减函数
    if e>E
        netbest=netbest;
    else
        E=e;
        netbest=net;
        ItoH=netbest.IW{1,1};
    end
end

%使用绝对影响系数作为权重
%输入层到隐藏层权重
ItoH=netbest.IW{1,1};
%隐藏层到输出层权重
HtoO=netbest.LW{2,1};

%计算相关显著性指数
cosizu=0;%初始化所有影响变量的相关显著性组
for i=1:length(ItoH)
    temp1=ItoH(:,i);
    cosi=0;%初始化该变量的相关显著性
    for j=1:10
        cosiij=temp1(j)*(1-exp(-HtoO(j)))/(1+exp(-HtoO(j)));
        cosi=cosi+cosiij;
    end
    cosizu=[cosizu;cosi];
end
cosizu(1)=[];
%计算相关系数
coinzu=zeros(length(cosizu),1);%初始化相关系数组
for i=1:length(cosizu)
    coinzu(i)=abs((1-exp(-cosizu(i)))/(1+exp(-cosizu(i))));
end
%计算绝对影响系数，即权重
wann=coinzu/sum(coinzu);
outputArg=wann;
outputArg1=E;
end

