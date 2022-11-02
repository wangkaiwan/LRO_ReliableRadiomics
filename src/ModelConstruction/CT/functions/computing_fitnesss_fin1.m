function [f,obj_f,AUC_f,fin_label_ind,fin_ind,fin_p]=computing_fitnesss_fin1(NPOP1,NPOP2,NPOP3,w,train_data_sam1,train_data_sam2,train_data_sam3,train_ind, test_data_sam1,test_data_sam2,test_data_sam3,test_ind)
%computing fitness for optimization
% pop1=NPOP1;
% pop2=NPOP2;
% pop3=NPOP3;

[m1,n1]=size(NPOP1);
pop1=NPOP1(:,1:n1-2);
par1_pop1=NPOP1(:,n1-1);
par2_pop1=NPOP1(:,n1);

[m2,n2]=size(NPOP2);
pop2=NPOP2(:,1:n2-2);
par1_pop2=NPOP2(:,n2-1);
par2_pop2=NPOP2(:,n2);

[m3,n3]=size(NPOP3);
pop3=NPOP3(:,1:n3-2);
par1_pop3=NPOP3(:,n2-1);
par2_pop3=NPOP3(:,n2);

for i=1:size(NPOP1,1)
    %generating new training samples
    new_sam1=train_data_sam1(:,find(pop1(i,:)));
    data1=[train_data_sam1 train_ind];
    
    new_sam2=train_data_sam2(:,find(pop2(i,:)));
    data2=[train_data_sam2 train_ind];   
    
    new_sam3=train_data_sam3(:,find(pop3(i,:)));
    data3=[train_data_sam3 train_ind];  

    TP=0;
    FP=0;
    TN=0;
    FN=0;
    
    i_ind=[];
    i_label_ind=[];
    
    sam_train_data1=new_sam1;
    ind_train_data1=train_ind;
    sam_test_data1=test_data_sam1(:,find(pop1(i,:)));
    ind_test_data1=test_ind;
    par11=par1_pop1(i);
    par21=par2_pop1(i);
    
    sam_train_data2=new_sam2;
    ind_train_data2=train_ind;
    sam_test_data2=test_data_sam2(:,find(pop2(i,:)));
    ind_test_data2=test_ind;
    par12=par1_pop2(i);
    par22=par2_pop2(i);
    
    sam_train_data3=new_sam3;
    ind_train_data3=train_ind;
    sam_test_data3=test_data_sam3(:,find(pop3(i,:)));
    ind_test_data3=test_ind;
    par13=par1_pop3(i);
    par23=par2_pop3(i);

      
    j = 1;
        %% LR
%         model1=glmfit(sam_train_data1,ind_train_data1-1,'binomial', 'link', 'logit');
%         label_output1=glmval(model1,sam_test_data1,'logit');
%         for im=1:length(ind_test_data1)
%             tmp_pro_output1(im,1)=1-label_output1(im);
%             tmp_pro_output1(im,2)=label_output1(im);
%         end 
%         pro_output1=tmp_pro_output1;
%         
%         model2=glmfit(sam_train_data2,ind_train_data2-1,'binomial', 'link', 'logit');
%         label_output2=glmval(model2,sam_test_data2,'logit');
%         for im=1:length(ind_test_data2)
%             tmp_pro_output2(im,1)=1-label_output2(im);
%             tmp_pro_output2(im,2)=label_output2(im);
%         end 
%         pro_output2=tmp_pro_output2;
        
        model3=glmfit(sam_train_data3,ind_train_data3-1,'binomial', 'link', 'logit');
        label_output3=glmval(model3,sam_test_data3,'logit');
        for im=1:length(ind_test_data3)
            tmp_pro_output2(im,1)=1-label_output3(im);
            tmp_pro_output2(im,2)=label_output3(im);
        end 
        pro_output3=tmp_pro_output2;
        
        %% SVM
%         a4=['-t 0 ' ' -w1 6 ' ' -b 1 -q'];
% %         a4=['-t 1 -c ' num2str(2^(par11)) ' -g ' num2str(2^(par21)) ' -w1 6 ' ' -b 1 -q'];
%         model4=svmtrain(ind_train_data1,sam_train_data1,a4);
%         [~,~,pro] = svmpredict(ind_test_data1, sam_test_data1, model4,'-b 1 -q');  
%         if model4.Label(1)==2
%            pro_output4(:,1)=pro(:,2);
%            pro_output4(:,2)=pro(:,1);
%         else
%            pro_output4=pro;
%         end
%         
%         a5=['-t 0 ' ' -w1 6 ' ' -b 1 -q'];
% %         a5=['-t 1 -c ' num2str(2^(par11)) ' -g ' num2str(2^(par21)) ' -w1 6 ' ' -b 1 -q'];
%         model5=svmtrain(ind_train_data2,sam_train_data2,a5);
%         [~,~,pro] = svmpredict(ind_test_data2, sam_test_data2, model5,'-b 1 -q');  
%         if model5.Label(1)==2
%            pro_output5(:,1)=pro(:,2);
%            pro_output5(:,2)=pro(:,1);
%         else
%            pro_output5=pro;
%         end
%         
        a6=['-t 0 -w1 6 ' ' -b 1 -q'];
%         a6=['-t 1 -c ' num2str(2^(par13)) ' -g ' num2str(2^(par23)) ' -w1 6 ' ' -b 1 -q'];
        model6=svmtrain(ind_train_data3,sam_train_data3,a6);
        [~,~,pro] = svmpredict(ind_test_data3, sam_test_data3, model6,'-b 1 -q');  
        if model6.Label(1)==2
           pro_output6(:,1)=pro(:,2);
           pro_output6(:,2)=pro(:,1);
        else
           pro_output6=pro;
        end
% %         %% Linear SVM
% %         model4 = fitcsvm(...
% %                 sam_train_data1, ...
% %                 ind_train_data1, ...
% %                 'KernelFunction', 'linear', ...
% %                 'PolynomialOrder', [], ...
% %                 'KernelScale', 'auto', ...
% %                 'BoxConstraint', 1, ...
% %                 'Standardize', true, ...
% %                 'ClassNames', [1; 2]);
% %         [~,pro_output4]=predict(model4,sam_test_data1); 
% %         
% %         model5 = fitcsvm(...
% %                 sam_train_data2, ...
% %                 ind_train_data2, ...
% %                 'KernelFunction', 'linear', ...
% %                 'PolynomialOrder', [], ...
% %                 'KernelScale', 'auto', ...
% %                 'BoxConstraint', 1, ...
% %                 'Standardize', true, ...
% %                 'ClassNames', [1; 2]);
% %         [~,pro_output5]=predict(model5,sam_test_data2); 
% %         
% %         model6 = fitcsvm(...
% %                 sam_train_data3, ...
% %                 ind_train_data3, ...
% %                 'KernelFunction', 'linear', ...
% %                 'PolynomialOrder', [], ...
% %                 'KernelScale', 'auto', ...
% %                 'BoxConstraint', 1, ...
% %                 'Standardize', true, ...
% %                 'ClassNames', [1; 2]);
% %         [~,pro_output6]=predict(model6,sam_test_data3); 
%         
        %% Linear Discriminanter
%         model7 = fitcdiscr(...
%             sam_train_data1, ...
%             ind_train_data1, ...
%             'DiscrimType', 'linear', ...
%             'Gamma', 0, ...
%             'FillCoeffs', 'off', ...
%             'ClassNames', [1; 2]);
%         [~,pro_output7]=predict(model7,sam_test_data1);
%         
%         model8 = fitcdiscr(...
%             sam_train_data2, ...
%             ind_train_data2, ...
%             'DiscrimType', 'linear', ...
%             'Gamma', 0, ...
%             'FillCoeffs', 'off', ...
%             'ClassNames', [1; 2]);
%         [~,pro_output8]=predict(model8,sam_test_data2);
%         
         model9 = fitcdiscr(...
            sam_train_data3, ...
            ind_train_data3, ...
            'DiscrimType', 'linear', ...
            'Gamma', 0, ...
            'FillCoeffs', 'off', ...
            'ClassNames', [1; 2]);
        [~,pro_output9]=predict(model9,sam_test_data3);
  
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
    f(i,:)=[sen spe 1.0/sum(pop3(i,:))];
    obj_f(i)=(TP+TN)/length(ind_test_data1);
    AUC_f(i)=AUC;
    fin_label_ind(i,:)=i_label_ind';
    fin_ind(i,:)=i_ind';
    fin_p(i)=p;

    clear new_sam data rea_lab ind_lab cross_acc_rate fin_pro_output tmp_output ind_output
end




