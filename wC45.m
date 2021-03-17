function [outputArg] = wC45(inputArg)
%使用C4.5算法计算内权重
%   算法的输入为训练数组，输出为各影响变量的权重

sgscORcd=inputArg;
Y=sgscORcd(:,2);

%先计算类别信息熵
[NY,edgesY,binY]=histcounts(Y,100)%histcounts方法是连续统计；NY为Y在均分100组下各组的频数，edgesY为Y划分组后各组的上下限，binY为Y中每个元素所对应的组号
NY=NY/103;%转化为频率
NY(find(NY==0))=1%将0值转化1，在取对数的时候就能够剔除掉
InfoY=-log2(NY)*NY';%初始化类别信息熵

%再求各影响变量的信息熵
for i=3:16
    X=sgscORcd(:,i);
    lableX=tabulate(X);%tabulate方法是离散统计；lableX的第一列为统计到的数值，第二列为该值的频数，第三列为百分比
    M=size(lableX);
    InfoX=0;
    if M(1)<20%如果直接对该变量归类发现小于20个，则可认为该变量离散，用离散的方法处理
        for j=1:M(1)
            shuzhi=lableX(j,1);
            hang=find(X==shuzhi);%找到该变量下各值所对应的行号
            if ~isempty(hang)
                binYtemp=binY(hang);
                lablebinYtemp=tabulate(binYtemp);%这两行是在该变量下的某值，对其对应的Y进行重新统计求频率
                temp1=lablebinYtemp(:,3)/100;
                temp1(find(temp1==0))=1;
                temp2=temp1'*log2(temp1);
                temp3=-temp2*lableX(j,3)/100;
                InfoX=InfoX+temp3;
            else
                InfoX=InfoX+0;
            end
        end
    else%该变量为连续变量
        [NX,edgesX,binX]=histcounts(X,20);%因为是连续变量，需要先划分好频率组，默认划分20组
        for j=1:20
            hang=find(binX==j);
            if ~isempty(hang)
                binYtemp=binY(hang);
                lablebinYtemp=tabulate(binYtemp);
                temp1=lablebinYtemp(:,3)/100;
                temp1(find(temp1==0))=1;
                temp2=temp1'*log2(temp1);
                temp3=-temp2*NX(j)/103;
                InfoX=InfoX+temp3;
            else
                InfoX=InfoX+0;
            end
        end
    end
    InfoY=[InfoY;InfoX];%注意此处将类别信息熵与各影响变量信息熵放在了一起
end

%计算信息增益
InfoY=InfoY(1)-InfoY;
Gain=InfoY;
Gain(1)=[];%由于第一个是类别信息熵，所以去掉

%计算各影响变量分裂信息度量
H=0;%初始化分别信息度量组H
for i=3:16
    X=sgscORcd(:,i);
    lableX=tabulate(X);%tabulate方法是离散统计；lableX的第一列为统计到的数值，第二列为该值的频数，第三列为百分比
    M=size(lableX);
    if M(1)<20
        temp1=lableX(:,3)/100;
        temp1(find(temp1==0))=1;
        HX=-temp1'*log2(temp1);
    else
        [NX,edgesX,binX]=histcounts(X,20);
        NX=NX/20;
        NX(find(NX==0))=1;
        HX=-log2(NX)*NX';
    end
    H=[H;HX];
end
H(1)=[];

%计算信息增益率
IGR=Gain./H;

%根据信息增益率分配权重
wc45=IGR/sum(IGR);

%输出结果
outputArg=wc45;

end

