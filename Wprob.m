function [outputArg] = Wprob(inputArg1,inputArg2)
%基于概率的外权重值计算
%   输入是中心数据与其最近K个数据的“时长/长度”、是时长还是长度的判断参数，输出外权重
chushi= inputArg1;
itemindex= inputArg2;

%计算外权重
W=chushi;%定义变量以收录计算好的外权重
if itemindex==1%此时输入的是时长
    for i=1:length(chushi)
        if chushi(i)<35.48
            W(i)=0.75*(chushi(i)/32.33-0.097)^0.5;
        else
            W(i)=0.75*(chushi(i)/32.33-0.097)^-(2.5);
        end
    end
else%此时输入的是长度
    W=0.03*exp(-(chushi./1.81+1.02).^0.24);
end

%对外权重百分比化处理
outputArg=W/sum(W);

end

