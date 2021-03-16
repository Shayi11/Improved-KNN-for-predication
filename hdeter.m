function [outputArg] = hdeter(inputArg)
%确定kmeans++的最优h值
%   算法的输入为sgsc或sgcd，输出为各的h值区分度指标

sgscORcd=inputArg;
X=sgscORcd(:,[3:end]);
X=mapminmax(X,0,1);%归一化
Y=sgscORcd(:,2);

%寻找最优h值
Diffindex=0;%初始化区分度指标
for j=5:10%寻找h值为5~10
    %使用kmeans++进行聚类学习，寻找最优的聚类划分
    SSE=0;%初始化各簇内各点与中心点的距离组
    idxzu=zeros(103,1);%初始化各点的簇索引组
    for i=1:100%训练100次以求得最优划分（即SSE最小的时候），因为最优划分才最能体现各变量对聚类的贡献程度
        [tempidx,C,sumd]=kmeans(X,j);
        tempSSE=sum(sumd);
        SSE=[SSE;tempSSE];
        idxzu=[idxzu,tempidx];
    end
    SSE(1)=[];%按惯例去除初始化产生的0值
    idxzu(:,1)=[];
    %寻找SSE最小的时候
    [zuixiao,lie]=min(SSE);
    idx=idxzu(:,lie);
    
    %计算h值为j时的区分度指标
    MeanY=0;%初始化距离
    for i=1:j
        hang=find(idx==i);
        tempY=Y(hang);
        meanY=mean(tempY);%寻找各簇的时间/长度均值
        MeanY=[MeanY;meanY];
    end
    MeanY(1)=[];
    MeanY=sort(MeanY);%各簇的时间/长度均值从小到大排序
%     plot(MeanY);
%     hold on
    
    %寻找相邻各簇间的差值的最小值
    chazhi=inf;%初始化差值组
    for i=1:j-1
        temp=MeanY(i+1)-MeanY(i);
        if temp<chazhi
            chazhi=temp;
        else
            chazhi=chazhi;
        end
    end
    
    %以相邻各簇间差值的最小值为区分度指标（差值的最小值代表了最小的区分能力）
    Diffindex=[Diffindex;chazhi];
end

Diffindex(1)=[];

%输出区分度指标
outputArg=Diffindex;

end

