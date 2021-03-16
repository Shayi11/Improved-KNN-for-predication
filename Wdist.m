function [outputArg] = Wdist(inputArg)
%基于距离的外权重计算
%   输入是中心数据与其最近K个数据的“时长/长度”之差的绝对值，输出外权重
chushi=inputArg;

%计算外权重
W=1./(chushi+1);%此处+1是为了避免分母0值的出现
W=W/sum(W);

%输出结果
outputArg=W;

end

