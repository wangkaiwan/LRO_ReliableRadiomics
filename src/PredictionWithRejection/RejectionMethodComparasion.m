clear,clc
addpath('../../data/PredictionWithRejectionResults')

load('CombinedRejection50P.mat')

P_comb50 = [];
I_comb50 = [];

for i = 1:5
    P_comb50 = [P_comb50; Combined_P{i}];
    I_comb50 = [I_comb50; Combined_I{i}];
end

load('CombinedRejection75P.mat')

P_comb = [];
I_comb = [];

for i = 1:5
    P_comb = [P_comb; Combined_P{i}];
    I_comb = [I_comb; Combined_I{i}];
end

load('AleatoricUncertainRejection75P.mat')

P_unc = [];
I_unc = [];

for i = 1:5
    P_unc = [P_unc; Uncertain_P{i}];
    I_unc = [I_unc; Uncertain_I{i}];
end

load('EpistemicUncertainRejection75P.mat')

P_ano = [];
I_ano = [];

for i = 1:5
    P_ano = [P_ano; Anomaly_P{i}];
    I_ano = [I_ano; Anomaly_I{i}];
end

load('FusedDeltaModelResults.mat','P','Ind')
P_ori = [];
I_ori = [];

for i = 1:5
    for j = 1:5
        P_ori = [P_ori; P{i,j}];
        I_ori = [I_ori; Ind{i,j}];
    end
end

load(['AllPreModelResults.mat'],'P');
Pre = cell(1,4);
for m = 1:4
    for i = 1:5
        temp = P{i,m};
        Pre{m} = [Pre{m};temp];
    end
end

load(['AllPostModelResults.mat'],'P');
Post = cell(1,4);
for m = 1:4
    for i = 1:5
        temp = P{i,m};
        Post{m} = [Post{m};temp];
    end
end

load('label_pre_post.mat')
Ind_Pre_post = [final_ind;final_ind;final_ind;final_ind;final_ind];

Pre = Pre{1}; % there are four colums: Cli+PET+CT,Cli, PET, CT. We use the 1st here.
Post = Post{1};


% plot ROC curve
[X_pre,Y_pre,T,auc_pre]=perfcurve(Ind_Pre_post,Pre(:,2),'2');
[X_post,Y_post,T,auc_post]=perfcurve(Ind_Pre_post,Post(:,2),'2');
[X_ori,Y_ori,T,AUC_ori] = perfcurve(I_ori,P_ori(:,2),2);
[X_ano,Y_ano,T,AUC_ano] = perfcurve(I_ano,P_ano(:,2),1);
[X_unc,Y_unc,T,AUC_unc] = perfcurve(I_unc,P_unc(:,2),1);
[X_comb,Y_comb,T,AUC_comb] = perfcurve(I_comb,P_comb(:,2),1);
[X_comb50,Y_comb50,T,AUC_comb50] = perfcurve(I_comb50,P_comb50(:,2),1);
figure, plot(X_ori,Y_ori,'linewidth',2)
hold on, plot(X_ano,Y_ano,'linewidth',2)
hold on, plot(X_unc,Y_unc,'linewidth',2)
hold on, plot(X_comb,Y_comb,'linewidth',2)
hold on, plot(X_comb50,Y_comb50,'linewidth',2)

legend({'No Rejection','Epistemic 25% Rejection','Aleatoric 23% Rejection','Combined 25% Rejection','Combined 49% Rejection'}, 'FontSize',10,'FontWeight','bold')
xlabel('False Positive Rate','FontWeight','bold')
ylabel('True Positive Rate','FontWeight','bold')
grid on

figure, plot(X_pre,Y_pre,'linewidth',2)
hold on, plot(X_post,Y_post,'linewidth',2)
hold on, plot(X_ori,Y_ori,'linewidth',2)

legend({'Pre-treatment Model','Post-treatment Model','Delta-radiomics Model'}, 'FontSize',10,'FontWeight','bold')
xlabel('False Positive Rate','FontWeight','bold')
ylabel('True Positive Rate','FontWeight','bold')
grid on

