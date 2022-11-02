clear,clc, close all

addpath('../../data/PredictionWithRejectionResults')
addpath('functions')

repeat = 5;
cross = 5;
patient_num = 224;
method = 'AutoEncoder';

PercentProRecord = {};
PercentIndRecord = {};
PercentPerRecord = {};
PercentAvePerRecord = [];
PercentStdPerRecord = [];
PercentPosNegRecord = zeros(2,5,1);
k = 1;
TrueRatio = [];

load('FusedDelta_TestResults.mat'); % testing data p and label
load('FusedDelta_ValdiationResults.mat'); % validation data p and label

load(['EpistemicUncertainty_',method,'.mat']) %Anomaly Score Val and Test

load('AleatoricUncertainty_test.mat'); %uncertainty
load('AleatoricUncertainty_val.mat'); %uncertainty_val

for percent = 0:5:30
    TrueRatio = [TrueRatio;0];
    SelectP = cell(1,5);
    SelectInd = cell(1,5);

    select_test_record = zeros(6,4,5);
    for i = 1:repeat
        SelectP_temp = [];
        SelectInd_temp = [];
        for j = 1:cross
            
            P_fin = P{i,j};
            PET_ind_test_data = Ind{i,j};
%             [~,PET_pred_test_data] = max(P_fin');
%             PET_pred_test_data = PET_pred_test_data';
            PET_pred_test_data = (P_fin(:,2)>0.65)+1;
%             PET_pred_test_data = PET_ind_test_data;
            
            P_fin_PP = P_fin(PET_pred_test_data==2,:); % predicted as positive
            PET_ind_test_data_PP = PET_ind_test_data(PET_pred_test_data==2);
            P_fin_PN = P_fin(PET_pred_test_data==1,:); % predicted as negative
            PET_ind_test_data_PN = PET_ind_test_data(PET_pred_test_data==1);
            
            index_ori_P = find(PET_pred_test_data==2);
            index_ori_N = find(PET_pred_test_data==1);
            
            Anomaly_PScore = AnomalyScore_P_Test{i,j};
            Anomaly_PScore = Anomaly_PScore(PET_pred_test_data==2,:);
            Anomaly_PScore = Anomaly_PScore(:,2);
            Anomaly_NScore = AnomalyScore_N_Test{i,j};
            Anomaly_NScore = Anomaly_NScore(PET_pred_test_data==1,:);
            Anomaly_NScore = Anomaly_NScore(:,2);
            
            Anomaly_PScore_val = AnomalyScore_P_Train{i,j};
            Anomaly_PScore_val = Anomaly_PScore_val(:,2);
            Anomaly_NScore_val = AnomalyScore_N_Train{i,j};
            Anomaly_NScore_val = Anomaly_NScore_val(:,2);
            
            dataNum_P = size(Anomaly_PScore_val,1);
            selNum_P = ceil(dataNum_P*(100-percent)/100);
            dataNum_N = size(Anomaly_NScore_val,1);
            selNum_N = ceil(dataNum_N*(100-percent)/100);
            
            [Anomaly_PScore_val_Sorted,~] = sort(Anomaly_PScore_val,'ascend');
            Anomaly_P_thresh = Anomaly_PScore_val_Sorted(selNum_P);
            selIndex_P = find(Anomaly_PScore<Anomaly_P_thresh);
            
            [Anomaly_NScore_val_Sorted,~] = sort(Anomaly_NScore_val,'ascend');
            Anomaly_N_thresh = Anomaly_NScore_val_Sorted(selNum_N);
            selIndex_N = find(Anomaly_NScore<Anomaly_N_thresh);
           
            index_ano_P = index_ori_P(selIndex_P);
            index_ano_N = index_ori_N(selIndex_N);
            
            
            P_fin = P_fin([index_ano_P;index_ano_N],:);
            PET_ind_test_data = PET_ind_test_data([index_ano_P;index_ano_N]);
            
            P_val_fin = P_val{i,j};
            PET_ind_val_data = Ind_val{i,j};
            
            dataNum = size(P_val_fin,1);
            selNum = ceil(dataNum*(100-0)/100);

            Uncertainty_val = uncertainty_val{i,j};
            [Uncertainty_val_Sorted,~] = sort(Uncertainty_val,'ascend');
            
            Uncertainty_thresh = Uncertainty_val_Sorted(selNum);
            
            Uncertainty_test = uncertainty{i,j};
            Uncertainty_test = Uncertainty_test([index_ano_P;index_ano_N]);
%             selIndex = find(Uncertainty_test<Uncertainty_thresh);
            selIndex = find(Uncertainty_test<1);
            
            SelPro = P_fin(selIndex,:);
            SelInd = PET_ind_test_data(selIndex);

            [SEN,SPE,ACC,AUC,p_value] = cal_evaluation(SelPro,SelInd);
            select_test_record(j,:,i) = [SEN,SPE,ACC,AUC]; 
            SelectP_temp = [SelectP_temp;SelPro];
            SelectInd_temp = [SelectInd_temp;SelInd];
            fprintf('Using reject option Sen = %.5f, Spe = %.5f, ACC = %.5f, AUC = %.5f, p_value = %.5f\n', SEN,SPE,ACC,AUC,p_value);
        end
        [SEN,SPE,ACC,AUC,p_value] = cal_evaluation(SelectP_temp,SelectInd_temp);
        select_test_record(6,:,i) = [SEN,SPE,ACC,AUC]; 
        SelectP{i} = SelectP_temp;
        SelectInd{i} = SelectInd_temp-1;
        PercentPosNegRecord(:,i,k) = [sum(SelectInd_temp-1),length(SelectInd_temp)];
        fprintf('For all the sample Sen = %.5f, Spe = %.5f, ACC = %.5f, AUC = %.5f, p_value = %.5f\n\n', SEN,SPE,ACC,AUC,p_value);
        TrueRatio(k) = TrueRatio(k)+length(SelectP_temp);
    end
    PercentPerRecord{k} = select_test_record;
    PercentProRecord{k} = SelectP;
    PercentIndRecord{k} = SelectInd;
    result = zeros(5,4);
    for i = 1:5
        result(i,:) = select_test_record(6,:,i);
    end
    tempMean = mean(result);
    tempStd = std(result);
    PercentAvePerRecord(k,:) = tempMean;
    PercentStdPerRecord(k,:) = tempStd;
    TrueRatio(k) = TrueRatio(k)/repeat/patient_num;
    k = k+1;
end

x = 1-TrueRatio;
% x = repmat(x,1,4);
% figure,plot(x,PercentAvePerRecord,'linewidth',2)
figure,plot(x,PercentAvePerRecord(:,1),'linewidth',2)
hold on,plot(x,PercentAvePerRecord(:,2),'--','linewidth',2)
hold on,plot(x,PercentAvePerRecord(:,3),'-*','linewidth',2)
hold on,plot(x,PercentAvePerRecord(:,4),'-o','linewidth',2)
hold off
grid on
legend({'Sensitivity','Specificity','Accuracy','AUC'},'FontWeight','bold', 'FontSize',10)
% set(gca,'XDir','reverse')
% set(gca,'XTickLabel',name);
xlabel('Sample Rejection Ratio','FontWeight','bold')
ylabel('Value of Evaluation Criterion','FontWeight','bold')
% title([method,' Model Performance with Different Probability Threshold'])
% 
[m,n,k] = size(PercentPosNegRecord);
sel_ratio = zeros(1,k);
for i = 1:k
    temp = sum(PercentPosNegRecord(:,:,i),2);
    sel_ratio(i) = temp(1)/temp(2);
end
% x = (1:-0.05:0.6)';
x = 1-TrueRatio;
% name_x = [num2str((0.7:0.05:1)'*100),['%';'%';'%';'%';'%';'%';'%']];
name_y = [num2str((0:0.2:1)'*100),['%';'%';'%';'%';'%';'%']];
% name_y = [num2str((0:0.1:1)'*100),['%';'%';'%';'%';'%';'%';'%';'%';'%';'%';'%']];
figure,plot(x,sel_ratio,'linewidth',2)
ylim([0,1]);
set(gca,'XDir','reverse')
% set(gca,'XTickLabel',name_x);
set(gca,'YTickLabel',name_y);
xlabel('Ratio of Sample Selection','FontWeight','bold')
ylabel('Ratio of True Postive Sample','FontWeight','bold')
hold on,plot(x,repmat(sel_ratio(1),length(TrueRatio),1))
grid on
legend({'Test','Ideal'},'FontWeight','bold', 'FontSize',10)
% title('P/N with different probability threshold')
