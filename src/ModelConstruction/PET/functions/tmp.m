clc;
clear;
pareto=xlsread('test record');
pop=pareto;
[fin_pareto, fin_pop]=computing_fin(pareto,pop,5);
x=pop(:,1);
y=pop(:,2);
for i=1:length(x)
    if x(i)==fin_pareto(1) && y(i)==fin_pareto(2)
        plot(x(i),y(i),'ro');
    else
        plot(x(i),y(i),'bo');
    end
    hold on
end
hold off