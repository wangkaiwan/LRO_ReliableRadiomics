%% initialize
addpath('../')
result = zeros(6,5,5);
P = cell(5,4);
outputpath = '../../../data/PredictionWithRejectionResults/';


for CV = 1:5
    CliPath = '../../../data/Models/Cli/';
    CliName_ = ['Cli_Model_CV_',num2str(CV),'_Fold_'];

    PETPath = '../../../data/Models/PET/';
    PETName_ = ['PET_Model_CV_',num2str(CV),'_Fold_'];

    CTPath = '../../../data/Models/CT/';
    CTName_ = ['CT_Model_CV_',num2str(CV),'_Fold_'];
        

    crossNum = 5;
    class = 2;
    lamda = 0.50;

    for wInd = 4:4
        eval(['fuc =','@cal_weight',num2str(wInd),';']);

        final_P=[];
        final_Cli=[];   
        final_PET=[];
        final_CT=[];
        final_ind=[];

        %% fusion
        for i = 1:crossNum
            CliName = [CliPath CliName_ num2str(i) '.mat'];
            PETName = [PETPath PETName_ num2str(i) '.mat'];
            CTName = [CTPath CTName_ num2str(i) '.mat'];
            
            [SEN_Cli,SPE_Cli,ACC_Cli,AUC_Cli,P_Cli] = Cli_OptimalSetFusion(CliName,wInd,lamda);
            [SEN_PET,SPE_PET,ACC_PET,AUC_PET,P_PET] = PET_OptimalSetFusion(PETName,wInd,lamda);
            [SEN_CT,SPE_CT,ACC_CT,AUC_CT,P_CT] = CT_OptimalSetFusion(CTName,wInd,lamda);

            pareto = [SEN_Cli, SPE_Cli; SEN_PET, SPE_PET; SEN_CT, SPE_CT];
            AUCs = [AUC_Cli AUC_PET AUC_CT];

            load(PETName,'PET_ind_test_data'); % same label for all modalities

    %         wt=cal_weight(pareto,AUCs,lamda);
            wt=fuc(pareto,0,AUCs,lamda);%[0.33 0.33 0.33];%
            P_fin=zeros(length(PET_ind_test_data),class);
            for j=1:length(PET_ind_test_data)
                p = [P_Cli(j,:); P_PET(j,:); P_CT(j,:)];
                P_fin(j,:)=Analytic_ER_rule(wt,wt,p);
            end
            [SEN,SPE,ACC,AUC,p_value]=cal_evaluation(P_fin,PET_ind_test_data);
            fprintf('Sen = %.5f, Spe = %.5f, ACC = %.5f, AUC = %.5f, p_value = %.5f\n', SEN,SPE,ACC,AUC,p_value);
            final_P=[final_P; P_fin];
            final_Cli=[final_Cli;P_Cli];
            final_PET=[final_PET;P_PET];
            final_CT=[final_CT;P_CT];
            final_ind=[final_ind; PET_ind_test_data];
            result(i,:,CV) = [SEN,SPE,ACC,AUC,p_value];
        end
        [SEN,SPE,ACC,AUC,p_value]=cal_evaluation(final_P,final_ind);
        fprintf('Sen = %.5f, Spe = %.5f, ACC = %.5f, AUC = %.5f, p_value = %.5f\n', SEN,SPE,ACC,AUC,p_value);
        fprintf('_____________________________________\n')
        result(6,:,CV) = [SEN,SPE,ACC,AUC,p_value];
    end
    P{CV,1} = final_P;
    P{CV,2} = final_Cli;
    P{CV,3} = final_PET;
    P{CV,4} = final_CT;
end
save('FusedDeltaModelResults.mat','result','P');

result2 = zeros(5,5);
for i = 1:5
result2(i,:) = result(6,:,i);
end
mean(result2)
std(result2)
