function w=cal_weight4(pareto,Epal,AUC,lamda)
%calculating relative weight for each model
w=zeros(1,size(pareto,1));
for j=1:size(pareto,1)
    vectorResult = [pareto(j,1:2),AUC(j)];
    vectorNorm = norm(vectorResult);
    lamdaV = [10,1,1];
	cosAngle = vectorResult*lamdaV'/(norm(lamdaV)*vectorNorm);
    w(j)=cosAngle*vectorNorm/sqrt(3);
end