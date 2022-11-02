function w=cal_weight5(pareto,Epal,AUC,lamda)
%calculating relative weight for each model
w=zeros(1,size(pareto,1));
for j=1:size(pareto,1)
    w(j)=(pareto(j,2)*pareto(j,1))*exp(-(Epal(j,3)-1));
end