function p=CT_cal_single_probability(single_test_data1,single_test_data2,single_test_data3,POP,model,cli_n,pet_n,ct_n)
%calculating the output probability for each pareto model
cli_POP = POP(:,1:cli_n);
PET_POP=POP(:,(cli_n+1:cli_n+pet_n));
CT_POP=POP(:,(cli_n+pet_n+1:cli_n+pet_n+ct_n));
w=POP(:,(size(POP,2)-8:size(POP,2)));

cli_fea_POP = cli_POP(:,1:cli_n-2);
PET_fea_POP=PET_POP(:,1:pet_n-2);
CT_fea_POP=CT_POP(:,1:ct_n-2);

ind_test_data=1;
for i=1:size(POP,1)
    fea_single_test_data1=single_test_data1(:,(cli_fea_POP(i,:)==1));
    fea_single_test_data2=single_test_data2(:,(PET_fea_POP(i,:)==1));
    fea_single_test_data3=single_test_data3(:,(CT_fea_POP(i,:)==1));
    
    %% LR
%     label_output1=glmval(model{1,i},fea_single_test_data1,'logit');
%     for im=1:length(label_output1)
%         tmp_pro_output(im,1)=1-label_output1(im);
%         tmp_pro_output(im,2)=label_output1(im);
%     end 
%     pro_output1=tmp_pro_output;
%     
%     label_output2=glmval(model{2,i},fea_single_test_data2,'logit');
%     for im=1:length(label_output2)
%         tmp_pro_output(im,1)=1-label_output2(im);
%         tmp_pro_output(im,2)=label_output2(im);
%     end 
%     pro_output2=tmp_pro_output;
    
    label_output3=glmval(model{3,i},fea_single_test_data3,'logit');
    for im=1:length(label_output3)
        tmp_pro_output(im,1)=1-label_output3(im);
        tmp_pro_output(im,2)=label_output3(im);
    end 
    pro_output3=tmp_pro_output;
    
    %% SVM
%     [~,~,pro] = svmpredict(ind_test_data,fea_single_test_data1,model{4,i},' -b 1 -q');  
%     if model{4,i}.Label(1)==2
%        tmp_pro_output4(:,1)=pro(:,2);
%        tmp_pro_output4(:,2)=pro(:,1);
%        pro_output4=tmp_pro_output4;
%     else
%        pro_output4=pro;
%     end
%     
%     [~,~,pro] = svmpredict(ind_test_data,fea_single_test_data2,model{5,i},' -b 1 -q');  
%     if model{5,i}.Label(1)==2
%        tmp_pro_output5(:,1)=pro(:,2);
%        tmp_pro_output5(:,2)=pro(:,1);
%        pro_output5=tmp_pro_output5;
%     else
%        pro_output5=pro;
%     end
%     
    [~,~,pro] = svmpredict(ind_test_data,fea_single_test_data3,model{6,i},' -b 1 -q');  
    if model{6,i}.Label(1)==2
       tmp_pro_output6(:,1)=pro(:,2);
       tmp_pro_output6(:,2)=pro(:,1);
       pro_output6=tmp_pro_output6;
    else
       pro_output6=pro;
    end
%     
% %     %% Linear SVM
% %     [~,pro_output4]=predict(model{4,i},fea_single_test_data1);
% %     [~,pro_output5]=predict(model{5,i},fea_single_test_data2);
% %     [~,pro_output6]=predict(model{6,i},fea_single_test_data3);
%     
    %% LD
%     [~,pro_output7]=predict(model{7,i},fea_single_test_data1);
%     [~,pro_output8]=predict(model{8,i},fea_single_test_data2);
    [~,pro_output9]=predict(model{9,i},fea_single_test_data3);
    
%     Pro = [pro_output9];
%     pro_output = Analytic_ER_rule(w(i,9),w(i,9),Pro);
    Pro = [pro_output3;pro_output6;pro_output9];
    pro_output = Analytic_ER_rule(w(i,[3,6,9]),w(i,[3,6,9]),Pro);
    p(i,:)=pro_output;
end