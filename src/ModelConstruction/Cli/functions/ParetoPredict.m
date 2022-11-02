function [SingleParetoValResult, GroupValResult] = ParetoPredict(Epal, EPOP, E_AUC, E_model, lamda, min_model, class, test_data_sam1,test_data_sam2,test_data_sam3,test_ind,cli_n,pet_n,ct_n)

pareto=Epal((find(Epal(:,3)==1)),(1:2));    
fin_POP=EPOP((find(Epal(:,3)==1)),:);
fin_AUC=E_AUC(:,(find(Epal(:,3)==1)));
fin_model=E_model(:,(find(Epal(:,3)==1)));
m=1;
while size(pareto,1)<min_model
    m=m+1;
    pareto=[pareto;Epal((find(Epal(:,3)==m)),(1:2))];    
    fin_POP=[fin_POP;EPOP((find(Epal(:,3)==m)),:)];
    fin_AUC=[fin_AUC E_AUC(:,(find(Epal(:,3)==m)))];
    fin_model=[fin_model E_model(:,(find(Epal(:,3)==m)))];
end

%testing stage
%calculating relative weight
wt=cal_weight(pareto,fin_AUC,lamda);
% calculating the output probability
% IDX=knnsearch(sam_train_data,sam_test_data,'k',10);
P_fin=zeros(length(test_ind),class);
for j=1:length(test_ind)
    %calculating reliability for each test sample
%     r=cal_reliability(sam_train_data,ind_train_data,sam_test_data(j,:),10,fin_POP,fin_model);
    %calculating the single output probability
    p=cal_single_probability(test_data_sam1(j,:),test_data_sam2(j,:),test_data_sam3(j,:),fin_POP,fin_model,cli_n,pet_n,ct_n);
    P_fin(j,:)=Analytic_ER_rule(wt,wt,p);
end
%evalucating
[SEN,SPE,ACC,AUC,p_value] = cal_evaluation(P_fin,test_ind);
GroupValResult = [SEN,SPE,ACC,AUC,p_value];
SingleParetoValResult = calculateSingleSolution(fin_model, fin_POP, wt, test_data_sam1,test_data_sam2,test_data_sam3,test_ind,cli_n,pet_n,ct_n);
end