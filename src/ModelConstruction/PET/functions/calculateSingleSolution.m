function [result] = calculateSingleSolution(model, POP, weight, test_data_sam1,test_data_sam2,test_data_sam3,test_ind,cli_n,pet_n,ct_n)
%% calculate the performance of each perto solution
result = zeros(size(model,2),6);
% POP = POP(:,1:size(POP,2)-2);
cli_POP = POP(:,1:cli_n);
PET_POP=POP(:,(cli_n+1:cli_n+pet_n));
CT_POP=POP(:,(cli_n+pet_n+1:cli_n+pet_n+ct_n));
w=POP(:,(size(POP,2)-8:size(POP,2)));

pop1 = cli_POP(:,1:cli_n-2);
pop2 = PET_POP(:,1:pet_n-2);
pop3 = CT_POP(:,1:ct_n-2);

for i = 1:size(model,2)
    TP = 0;
    TN = 0;
    FP = 0;
    FN = 0;
    i_ind=[];
    i_label_ind=[];
    
    sam_test_data1=test_data_sam1(:,find(pop1(i,:)));
    ind_test_data1=test_ind;
    
    sam_test_data2=test_data_sam2(:,find(pop2(i,:)));
    ind_test_data2=test_ind;
    
    sam_test_data3=test_data_sam3(:,find(pop3(i,:)));
    ind_test_data3=test_ind;
    
    j = 1;

    %% LR
%     label_output1=glmval(model{1,i},sam_test_data1,'logit');
%     for im=1:length(label_output1)
%         tmp_pro_output(im,1)=1-label_output1(im);
%         tmp_pro_output(im,2)=label_output1(im);
%     end 
%     pro_output1=tmp_pro_output;
%     
%     label_output2=glmval(model{2,i},sam_test_data2,'logit');
%     for im=1:length(label_output2)
%         tmp_pro_output(im,1)=1-label_output2(im);
%         tmp_pro_output(im,2)=label_output2(im);
%     end 
%     pro_output2=tmp_pro_output;
    
    label_output3=glmval(model{3,i},sam_test_data3,'logit');
    for im=1:length(label_output3)
        tmp_pro_output(im,1)=1-label_output3(im);
        tmp_pro_output(im,2)=label_output3(im);
    end 
    pro_output3=tmp_pro_output;
%     
    %% SVM
%     [~,~,pro] = svmpredict(ind_test_data1, sam_test_data1, model{4,i},'-b 1 -q');  
%     if model{4,i}.Label(1)==2
%        pro_output4(:,1)=pro(:,2);
%        pro_output4(:,2)=pro(:,1);
%     else
%        pro_output4=pro;
%     end
%     
%     [~,~,pro] = svmpredict(ind_test_data2, sam_test_data2, model{5,i},'-b 1 -q');  
%     if model{5,i}.Label(1)==2
%        pro_output5(:,1)=pro(:,2);
%        pro_output5(:,2)=pro(:,1);
%     else
%        pro_output5=pro;
%     end
%     
    [~,~,pro] = svmpredict(ind_test_data3, sam_test_data3, model{6,i},'-b 1 -q');  
    if model{6,i}.Label(1)==2
       pro_output6(:,1)=pro(:,2);
       pro_output6(:,2)=pro(:,1);
    else
       pro_output6=pro;
    end
%     
% %     %% Linear SVM
% %     [~,pro_output4]=predict(model{4,i},sam_test_data1);
% %     [~,pro_output5]=predict(model{5,i},sam_test_data2);
% %     [~,pro_output6]=predict(model{6,i},sam_test_data3);
%     
    %% LD
%     [~,pro_output7]=predict(model{7,i},sam_test_data1);
%     [~,pro_output8]=predict(model{8,i},sam_test_data2);
    [~,pro_output9]=predict(model{9,i},sam_test_data3);
%         
  
        %combining the probability output with reliability and weight
        Pro=[];
        fin_pro=[];
        label_output=[];
        for x=1:length(ind_test_data1)
%             Pro=[pro_output9(x,:)];
%                 %pro_output4(x,:);pro_output5(x,:);pro_output6(x,:);...
%             fin_pro(x,:)=Analytic_ER_rule(w(i,[9]),w(i,[9]),Pro);
            Pro=[pro_output3(x,:);pro_output6(x,:);pro_output9(x,:)];
                %pro_output4(x,:);pro_output5(x,:);pro_output6(x,:);...
            fin_pro(x,:)=Analytic_ER_rule(w(i,[3,6,9]),w(i,[3,6,9]),Pro);
            if fin_pro(x,1)>=0.5
                label_output(x)=1;
            else
                label_output(x)=2;
            end
        end
        fin_pro_output{j}=fin_pro;
        clear fin_pro
        
%         cross_acc_rate(j)=accuracy(1);
        tmp_output{j}=label_output;
        ind_output{j}=ind_test_data1;
        for m=1:length(ind_test_data1)
            if label_output(m)==ind_test_data1(m)&& label_output(m)==2
                TP=TP+1;
            end
            if label_output(m)==ind_test_data1(m)&& label_output(m)==1
                TN=TN+1;
            end
            if label_output(m)==2 && ind_test_data1(m)==1
                FP=FP+1;
            end
            if label_output(m)==1 && ind_test_data1(m)==2
                FN=FN+1;
            end
        end
        clear pro_output1 pro_output2
    i_label_ind=[i_label_ind;label_output'];
    i_ind=[i_ind;ind_test_data1];
%         cross_sen(j)=TP/(TP+FN);
%         cross_spe(j)=TN/(TN+FP);       
    AUC_pro=fin_pro_output{1}(:,1);
    AUC_ind=ind_output{1};
%     for m=2:cross_num
%         AUC_pro=[AUC_pro;fin_pro_output{m}(:,1)];
%         AUC_ind=[AUC_ind;ind_output{m}];
%     end
    [X,Y,T,AUC]=perfcurve(AUC_ind,AUC_pro,'1');
    [h,p]=ttest2(AUC_pro,AUC_ind);
    % computing correct rate
    sen=TP/(TP+FN);
    spe=TN/(TN+FP);
    ACC=(TP+TN)/length(test_ind);
    
    result(i,:) = [sen, spe, ACC, AUC, p, weight(i)];
end
end
 