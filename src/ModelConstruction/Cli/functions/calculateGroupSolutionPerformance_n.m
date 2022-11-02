%% test the 
% Kai 10/18/2018
clear
%% pareto selection
% P_final2 = [];
% ind_final2 = [];

% threshold

for his_data = 1:5
    % path = ['Cervical',num2str(his_data)];
    path = ['M_Radiomics_',num2str(his_data)];
    fid = fopen([path,'\Group_performance_test_pop100_20_n_2.txt'],'w');

    for wInd = 1:8
        final_P2 = [];
        final_ind2 = [];
        for ind_fold = 1:5
            % load presaved data
            filename = [path,'\HN_MR_',num2str(his_data*10),'_Distant_5TrainTest_it_10_', num2str(ind_fold), '.mat'];
            load(filename);

            % reset some parameter
            lamda = 0.5;
            min_model = 20;%

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
            eval(['fuc =','@cal_weight_n',num2str(wInd),';']);
    %         fucName = ['cal_weight',num2str(wInd)];
    %         fuc = @fucName;
            w=fuc(pareto,Epal,fin_AUC,lamda);
            % calculating the output probability
            % IDX=knnsearch(sam_train_data,sam_test_data,'k',10);
            P_fin=zeros(length(PET_ind_test_data),class);
            for j=1:length(PET_ind_test_data)
                %calculating reliability for each test sample
            %     r=cal_reliability(sam_train_data,ind_train_data,sam_test_data(j,:),10,fin_POP,fin_model);
                %calculating the single output probability
                p=cal_single_probability(cli_sam_test_data(j,:),PET_sam_test_data(j,:),CT_sam_test_data(j,:),fin_POP,fin_model,cli_n,pet_n,ct_n);
                P_fin(j,:)=Analytic_ER_rule(w,w,p);
            end
            %evalucating
            [SEN,SPE,ACC,AUC,p_value] = cal_evaluation(P_fin,PET_ind_test_data);
        %     GroupValResult = [SEN,SPE,ACC,AUC,p_value];
        %     SingleParetoValResult = calculateSingleSolution(fin_model, fin_POP, w, sam_test_data, PET_ind_test_data);
            fprintf(fid, 'Sen = %.5f, Spe = %.5f, ACC = %.5f, AUC = %.5f, p_value = %.5f\n', SEN,SPE,ACC,AUC,p_value);
            final_P2=[final_P2; P_fin];
            final_ind2=[final_ind2; PET_ind_test_data];

        end
        [SEN,SPE,ACC,AUC,p_value]=cal_evaluation(final_P2,final_ind2);
        fprintf(fid,'Sen = %.5f, Spe = %.5f, ACC = %.5f, AUC = %.5f, p_value = %.5f\n', SEN,SPE,ACC,AUC,p_value);
        fprintf(fid,'\n');
    end
    fclose(fid);
    fclose('all');
end