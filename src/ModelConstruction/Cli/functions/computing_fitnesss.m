function [f,obj_f]=computing_fitnesss(NPOP,train_data_sam,ind,cross_num)
%computing fitness for optimization
[m,n]=size(NPOP);
pop=NPOP(:,1:n-2);
par1_pop=NPOP(:,n-1);
par2_pop=NPOP(:,n);
for i=1:size(pop,1)
    %generating new training samples
    new_sam=train_data_sam(:,find(pop(i,:)));
    data=[new_sam ind];
    TP=0;
    FP=0;
    TN=0;
    FN=0;
    %cross-validation 
    all_res=zeros(cross_num,length(ind));
    all_ind=zeros(cross_num,length(ind));
    Indices = crossvalind('Kfold', size(new_sam,1), cross_num);   %交叉验证的样本分配
    for j=1:cross_num
        test=(Indices==j);
        train0=~test;
        test_num=sum(test);
        test_data=zeros(test_num, size(data,2));
        i1=1;
        for i2=1:size(data,1)
            if test(i2)==1
                test_data(i1,:)=data(i2,:);
                i1=i1+1;
            end
        end
        train_num=sum(train0);
        train_data=zeros(train_num,size(data,2));
        j1=1;
        for j2=1:size(data,1)
            if train0(j2)==1
                train_data(j1,:)=data(j2,:);
                j1=j1+1;
            end
        end
        sam_train_data=train_data(:,(1:size(data,2)-1));
        ind_train_data=train_data(:,size(data,2));
        num_sam=length(ind_train_data)-sum(ind_train_data)-sum(ind_train_data);
        if num_sam>0
            sample=sam_train_data(find(ind_train_data),:)';    
            new_min_sam=SMOTE(sample, num_sam);
            new_min_ind=ones(num_sam,1);
            sam_train_data=[sam_train_data;new_min_sam'];
            ind_train_data=[ind_train_data;new_min_ind];
        end
        ind_train_data=ind_train_data+1;
        sam_test_data=test_data(:,(1:size(data,2)-1));
        ind_test_data=test_data(:,size(data,2));
        ind_test_data=ind_test_data+1;
        par1=par1_pop(i);
        par2=par2_pop(i);
        
%         [par_c,par_g]=computing_par(sam_train_data,ind_train_data,cross_num);
        a=['-c 2^par1 -g 2^par2 -b 1 -w2 3'];
%         a=['-c 2^par_c -g 2^par_g'];
%         a=['-c' num2str(2^(par1)), '-g' num2str(2^(par2))];
        model=svmtrain(ind_train_data,sam_train_data,a);
        [label_output,accuracy,pro] = svmpredict(ind_test_data, sam_test_data, model,'-b 1');  
        if model.Label(1)==2
           tmp_pro_output(:,1)=pro(:,2);
           tmp_pro_output(:,2)=pro(:,1);
           pro_output{j}=tmp_pro_output;
        else
           pro_output{j}=pro;
        end 
%         all_res(j,(1:length(ind_test_data)))=predicted_label';
%         all_ind(j,(1:length(ind_test_data)))=ind_test_data;  
        cross_acc_rate(j)=accuracy(1);
        tmp_output{j}=label_output;
        ind_output{j}=ind_test_data;
        for m=1:length(ind_test_data)
            if label_output(m)==ind_test_data(m)&& label_output(m)==2
                TP=TP+1;
            end
            if label_output(m)==ind_test_data(m)&& label_output(m)==1
                TN=TN+1;
            end
            if label_output(m)==2 && ind_test_data(m)==1
                FP=FP+1;
            end
            if label_output(m)==1 && ind_test_data(m)==2
                FN=FN+1;
            end
        end
        clear tmp_pro_output
%         cross_sen(j)=TP/(TP+FN);
%         cross_spe(j)=TN/(TN+FP);       
    end
    AUC_pro=pro_output{1}(:,1);
    AUC_ind=ind_output{1};
    for m=2:cross_num
        AUC_pro=[AUC_pro;pro_output{m}(:,1)];
        AUC_ind=[AUC_ind;ind_output{m}];
    end
    [X,Y,T,AUC]=perfcurve(AUC_ind,AUC_pro,'1');
    % computing correct rate
%     res_lab=all_res(:);
%     ind_lab=all_ind(:);
%     corr_rate=computing_corr_rate(res_lab,ind_lab);
      corr_rate=sum(cross_acc_rate)/cross_num;
    % computing the number of correlation feature
%     relation_val=computing_relation_val(corr_coe,corr_thr, pop(i,:));
%     f(i)=lamda*corr_rate+(1-lamda)*relation_val;
%     f(i)=corr_rate;
    sen=TP/(TP+FN);
    spe=TN/(TN+FP);
    f(i,:)=[sen spe];
    obj_f(i)=(TP+TN)/length(ind);
%     obj_f(i)=0.6*f(i)/100+0.1*sen(i)+0.3*spe(i);
%     fin_output{i}=tmp_output;
%     fin_ind_output{i}=ind_output;
%     fin_pro_output{i}=pro_output;
    clear new_sam data rea_lab ind_lab cross_acc_rate pro_output tmp_output ind_output
end