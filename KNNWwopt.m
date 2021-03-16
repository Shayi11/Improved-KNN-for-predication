function [outputArg] = KNNWwopt(inputArg1,inputArg2,inputArg3)
%多次运行KNNWtrain函数，寻找最优K值
%   输入sgcd或sgsc数组、内权重值、外权重确定方法参数，输出各K值下的误差，默认K从1到30
sgscORcd=inputArg1;
w=inputArg2;
way=inputArg3;

%计算各K值会有的误差
wuchazu=0;
for i=1:30
    K=i;
    E=0;
    for j=1:100%对K等i时运行100次，寻找此时的平均误差
        e=KNNWtrain(sgscORcd,K,w,way);
        E=e+E;
    end
    wuchazu=[wuchazu;mean(E)];
end
wuchazu(1)=[];

%输出结果
outputArg=wuchazu;

end

