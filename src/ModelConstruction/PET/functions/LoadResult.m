% load SEN SPE... from .mat file
filename = 'HN_Cli_CT_MR_5TrainTest_SMOTE2_it_10.mat';
test_record = zeros(5,5,5); 

for i_index = 10:10:50
    for j_index = 1:5
        matName = ['HN_Cli_CT_MR_',num2str(i_index),'_5TrainTest_SMOTE2_it_10_',num2str(j_index),'.mat'];
        load(matName);
        test_record(j_index,:,i_index/10) = GroupTestResult(10,:,j_index);
    end
end

save(filename,'test_record');