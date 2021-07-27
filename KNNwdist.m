function [outputArg] = KNNwdist(inputArg1,inputArg2,inputArg3)
%引入内权重计算两向量的距离
%   输入是两个样本和内权重（来自C45或AFW），输出是样本间加权欧氏距离和第二个输入的sgID
A=inputArg1;
B=inputArg2;
w=inputArg3;%内权重

%欧氏距离计算
dist=0;
for i=1:14
    temp=w(i)*(A(i+2)-B(i+2))^2;
    dist=dist+temp;
end
dist=sqrt(dist);
shuchu=[dist,B(1)];

%输出结果
outputArg=shuchu;

end
