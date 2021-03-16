function [outputArg] = KNNwdist(inputArg1,inputArg2,inputArg3)
%引入内权重计算两向量的距离
%   输入是两个样本和内权重（来自C45或AFW），输出是样本间加权欧氏距离和第二个输入的sgID
A=inputArg1;
B=inputArg2;
w=inputArg3;%内权重

%给两输入变量做归一化
A1=A(3:16);
A1=mapminmax(A1,0,1);
A(3:16)=A1;
B1=B(3:16);
B1=mapminmax(B1,0,1);
B(3:16)=B1;

%欧氏距离计算
dist=0;
for i=1:14
    temp=w(i)*(A(i)-B(i))^2;
    dist=dist+temp;
end
dist=sqrt(dist);
shuchu=[dist,B(1)];

%输出结果
outputArg=shuchu;

end

