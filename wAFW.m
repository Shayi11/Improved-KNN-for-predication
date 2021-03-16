function [outputArg] = wAFW(inputArg1,inputArg2)
%使用AFW算法确定内权重
%   算法的输入为sgsc或sgcd和AFW算法的h值（该h值是用于将时长或长度划分为合适宽度的h个组），输出为各影响变量的权重

sgscORcd=inputArg1;
h=inputArg2;
X=sgscORcd(:,[3:end]);
X=mapminmax(X,0,1);%归一化

%使用kmeans++进行聚类学习，寻找最优的聚类划分
SSE=0;%初始化各簇内各点与中心点的距离组
idxzu=zeros(103,1);%初始化各点的簇索引组
for i=1:100%训练100次以求得最优划分（即SSE最小的时候），因为最优划分才最能体现各变量对聚类的贡献程度
    [tempidx,C,sumd]=kmeans(X,h);
    tempSSE=sum(sumd);
    SSE=[SSE;tempSSE];
    idxzu=[idxzu,tempidx];
end
SSE(1)=[];%按惯例去除初始化产生的0值
idxzu(:,1)=[];
%寻找SSE最小的时候
[zuixiao,lie]=min(SSE);
idx=idxzu(:,lie);

%计算类内距离
leinei=zeros(1,14);%初始化类内距离
for i=1:h
    hang=find(idx==i);
    tempzu=X(hang,:);%找到划分好的第i组
    meantempzu=mean(tempzu);%返回该组在各变量的属性值
    M=size(tempzu);%找到该组内数据个数
    sileinei=zeros(1,14);%初始化单个类内距离
    for m=1:M(1)
        templeinei=((tempzu(m,:)-meantempzu).^2).^0.5;
        sileinei=sileinei+templeinei;
    end
    leinei=leinei+sileinei;
end
%剔除类内距离里的0值，以防贡献值计算出错
leinei(find(leinei==0))=1;

%计算类间距离
leijian=zeros(1,14);%初始化类间距离
meanX=mean(X);
for i=1:h
    hang=find(idx==i);
    tempzu=X(hang,:);
    meantempzu=mean(tempzu);
    templeijian=((meantempzu-meanX).^2).^0.5;
    leijian=leijian+templeijian;
end

%计算各变量贡献度
gongxian=leijian./leinei;

%计算权重
wafw=gongxian/sum(gongxian);

%输出结果
outputArg=wafw;

end

