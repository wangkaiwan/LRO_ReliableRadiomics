
% method = {'SUOD';'PCA';'IForest';'AE';'VAE';'LSCP';'SOS';'SOD'};
% 
method = {'AutoEncoder'};
outputpath = '../../../data/EpistemicUncertainty/';

for m = 1:length(method)
    AnomalyScore_Test = cell(5,5);
    AnomalyScore_Train = cell(5,5);
    for repeat = 1:5
        for CV = 1:5
            test_score_p_file_pet = ['AnomalyScore/',method{m},'_P_PET_Repeat_',num2str(repeat),'CV_',num2str(CV),'.npy'];
            train_score_p_file_pet = ['AnomalyScore/',method{m},'_P_PET_Train_Repeat_',num2str(repeat),'CV_',num2str(CV),'.npy'];
            test_score_n_file_pet = ['AnomalyScore/',method{m},'_N_PET_Repeat_',num2str(repeat),'CV_',num2str(CV),'.npy'];
            train_score_n_file_pet = ['AnomalyScore/',method{m},'_N_PET_Train_Repeat_',num2str(repeat),'CV_',num2str(CV),'.npy'];
            
            test_score_p_file_ct = ['AnomalyScore/',method{m},'_P_CT_Repeat_',num2str(repeat),'CV_',num2str(CV),'.npy'];
            train_score_p_file_ct = ['AnomalyScore/',method{m},'_P_CT_Train_Repeat_',num2str(repeat),'CV_',num2str(CV),'.npy'];
            test_score_n_file_ct = ['AnomalyScore/',method{m},'_N_CT_Repeat_',num2str(repeat),'CV_',num2str(CV),'.npy'];
            train_score_n_file_ct = ['AnomalyScore/',method{m},'_N_CT_Train_Repeat_',num2str(repeat),'CV_',num2str(CV),'.npy'];
            
            AnomalyScore_P_Test{repeat,CV}=readNPY(test_score_p_file_pet)+readNPY(test_score_p_file_ct);
            AnomalyScore_P_Train{repeat,CV}=readNPY(train_score_p_file_pet)+readNPY(train_score_p_file_ct);
            AnomalyScore_N_Test{repeat,CV}=readNPY(test_score_n_file_pet)+readNPY(test_score_n_file_ct);
            AnomalyScore_N_Train{repeat,CV}=readNPY(train_score_n_file_pet)+readNPY(train_score_n_file_ct);
        end
    end
    save([outputpath,'EpistemicUncertainty_',method{m},'.mat'],'AnomalyScore_P_Train','AnomalyScore_N_Train','AnomalyScore_P_Test','AnomalyScore_N_Test');
end