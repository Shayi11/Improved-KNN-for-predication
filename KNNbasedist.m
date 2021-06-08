function [outputArg] = KNNbasedist(inputArg1,inputArg2)
%是基础款的两向量距离计算
%   输入是两个样本，输出是样本间欧氏距离和第二个输入的样本ID（为后续寻找K个变量做准备）
A=inputArg1;
B=inputArg2;

%给两输入变量做归一化
A1=A(3:16);
A1=mapminmax(A1,0,1);
A(3:16)=A1;
B1=B(3:16);
B1=mapminmax(B1,0,1);
B(3:16)=B1;

%欧氏距离计算
dist=0;
for i=1:14%这是因为其适用案例的数据有14个自变量
    temp=(A(i+2)-B(i+2))^2;
    dist=dist+temp;
end
dist=sqrt(dist);
shuchu=[dist,B(1)];

%输出结果
outputArg=shuchu;

end

