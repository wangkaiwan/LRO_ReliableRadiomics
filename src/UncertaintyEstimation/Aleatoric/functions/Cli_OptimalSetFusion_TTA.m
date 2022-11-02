function [SEN,SPE,ACC,AUC,P_fin] = Cli_OptimalSetFusion_TTA(FileName,wInd,lamda)
    load(FileName,'Epal','EPOP','E_AUC','E_model','min_model','class',...
        'E_f','E_label_ind','E_ind','E_p','cli_sam_val_data','PET_sam_val_data',...
        'CT_sam_val_data','PET_ind_val_data','cli_n','pet_n','ct_n',...
        'cli_sam_test_data','PET_sam_test_data','CT_sam_test_data','PET_ind_test_data');
%     min_model = 10;
    [SEN,SPE,ACC,AUC] = Cli_MyValdationAnalysis(wInd,Epal,EPOP,E_AUC,E_model,lamda,min_model,class,cli_sam_val_data,PET_sam_val_data,CT_sam_val_data,PET_ind_val_data,cli_n,pet_n,ct_n);
    
    pareto=Epal((find(Epal(:,end)==1)),(1:2));    
    fin_POP=EPOP((find(Epal(:,end)==1)),:);
    fin_f=E_f(:,(find(Epal(:,end)==1)));
    fin_AUC=E_AUC(:,(find(Epal(:,end)==1)));
    fin_label_ind=E_label_ind((find(Epal(:,end)==1)),:);
    fin_ind=E_ind((find(Epal(:,end)==1)),:);
    fin_p=E_p(:,(find(Epal(:,end)==1)));
    fin_model=E_model(:,(find(Epal(:,end)==1)));
    m=1;
    while size(pareto,1)<min_model
        m=m+1;
        pareto=[pareto;Epal((find(Epal(:,end)==m)),(1:2))];    
        fin_POP=[fin_POP;EPOP((find(Epal(:,end)==m)),:)];
        fin_f=[fin_f E_f(:,(find(Epal(:,end)==m)))];
        fin_AUC=[fin_AUC E_AUC(:,(find(Epal(:,end)==m)))];
        fin_label_ind=[fin_label_ind;E_label_ind((find(Epal(:,end)==m)),:)];
        fin_ind=[fin_ind; E_ind((find(Epal(:,end)==m)),:)];
        fin_p=[fin_p E_p(:,(find(Epal(:,end)==m)))];
        fin_model=[fin_model E_model(:,(find(Epal(:,end)==m)))];
    end

    %testing stage
    %calculating relative weight
    eval(['fuc =','@cal_weight',num2str(wInd),';']);
    wt=fuc(pareto,0,fin_AUC,lamda);
    % calculating the output probabilitys
    % IDX=knnsearch(sam_train_data,sam_test_data,'k',10);
    P_fin=zeros(length(PET_ind_test_data),class);
    for j=1:length(PET_ind_test_data)
        %calculating reliability for each test sample
%         r=cal_reliability(sam_train_data,ind_train_data,sam_test_data(j,:),10,fin_POP,fin_model);
        %calculating the single output probability
        temp_cli = cli_sam_test_data(j,:);
%         temp_pet = PET_sam_test_data(j,:)+0.025*randn(size(PET_sam_test_data(j,:)));
%         temp_ct = CT_sam_test_data(j,:)+0.025*randn(size(CT_sam_test_data(j,:)));
        temp_pet = PET_sam_test_data(j,:)+0.01*randn(size(PET_sam_test_data(j,:)));
        temp_ct = CT_sam_test_data(j,:)+0.01*randn(size(CT_sam_test_data(j,:)));
        p=Cli_cal_single_probability(temp_cli,temp_pet,temp_ct,fin_POP,fin_model,cli_n,pet_n,ct_n);
        P_fin(j,:)=Analytic_ER_rule(wt,wt,p);
    end
