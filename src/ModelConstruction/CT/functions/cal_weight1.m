function w=cal_weight1(pareto,Epal,AUC,lamda)
%calculating relative weight for each model
w=zeros(1,size(pareto,1));
for j=1:size(pareto,1)
    if pareto(j,1)>=pareto(j,2)
        w(j)=pareto(j,2)/pareto(j,1);
    else
        w(j)=pareto(j,1)/pareto(j,2);
    end
    w(j)=lamda*w(j)+(AUC(j)/max(AUC))*(1-lamda);
end