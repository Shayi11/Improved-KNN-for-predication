function [outputArg] = KNNbasedist(inputArg1,inputArg2)
%是基础款的两向量距离计算
%   输入是两个样本，输出是样本间欧氏距离和第二个输入的sgID（为后续寻找K个变量做准备）
A=inputArg1;
B=inputArg2;

%欧氏距离计算
dist=0;
for i=1:14
    temp=(A(i+2)-B(i+2))^2;
    dist=dist+temp;
end
dist=sqrt(dist);
shuchu=[dist,B(1)];

%输出结果
outputArg=shuchu;

end
