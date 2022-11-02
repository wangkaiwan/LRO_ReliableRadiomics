clear;
warning('off')

addpath(genpath('..\Toolboxes\Feature Selection Library'));
addpath(genpath('..\Toolboxes\libsvm'));
addpath('functions')

%% Initialization
min_model=20;
pop_num=100;
it_num=50;
cross_num=5;
NA=20;
CS=500;

fea_num_str = [1 1 1 1 1]*50;

lamda=0;
class = 2;
outputpath = '../../../data/Models/PET/';

%% load data

% clinic data

filePath = '../../../data/Features/';
fileName = 'Clinical_Feature';

i_Cli_Data = xlsread([filePath,fileName],'combine');

[m,n]=size(i_Cli_Data);
ind=i_Cli_Data(:,n);
Cli_data=i_Cli_Data(:,(2:n-1));
i_Cli_Data = [Cli_data ind];

% CT and PET data
PET_fileName = 'PET_Fea';
CT_fileName = 'CT_Fea';

i_PET_data_pre=xlsread([filePath,PET_fileName,'_Pre']);
[~,n]=size(i_PET_data_pre);
if (sum(ind-i_PET_data_pre(:,n))~=0)
    fprintf('ind of PET is not consistent with Cli!\n');
end
PET_data_pre=i_PET_data_pre(:,1:n-1);
PET_data_pre(isnan(PET_data_pre))=0;

i_PET_data_post=xlsread([filePath,PET_fileName,'_Post']);
[m,n]=size(i_PET_data_post);
if (sum(ind-i_PET_data_post(:,n))~=0)
    fprintf('ind of PET is not consistent with Cli!\n');
end
PET_data_post=i_PET_data_post(:,1:n-1);
PET_data_post(isnan(PET_data_post))=0;

PET_data = [PET_data_pre,PET_data_post];
i_PET_data = [PET_data,ind];

i_CT_data_pre=xlsread([filePath,CT_fileName,'_Pre']);
[~,n]=size(i_CT_data_pre);
if (sum(ind-i_CT_data_pre(:,n))~=0)
    fprintf('ind of CT is not consistent with Cli!\n');
end
CT_data_pre=i_CT_data_pre(:,1:n-1);
CT_data_pre(isnan(CT_data_pre))=0;

i_CT_data_post=xlsread([filePath,CT_fileName,'_Post']);
[m,n]=size(i_CT_data_post);
if (sum(ind-i_CT_data_post(:,n))~=0)
    fprintf('ind of CT is not consistent with Cli!\n');
end
CT_data_post=i_CT_data_post(:,1:n-1);
CT_data_post(isnan(CT_data_post))=0;

CT_data = [CT_data_pre,CT_data_post];
i_CT_data = [CT_data,ind];

load('indice_5_times');
%% 
test_record = zeros(6,5,5);
val_record = zeros(6,5,5);
scale = [1 1 1 1 1]*1.5;%2.0;
Epal_Record = cell(cross_num,it_num);

for repeat_index = 1:5
    Indices = index_record{repeat_index};
    fea_num = fea_num_str(repeat_index);
    
    %% initialize pop
    clinical_fea_pop=randi([0,1],pop_num,size(Cli_data,2)).*randi([0,1],pop_num,size(Cli_data,2));
    clinical_EPOP=clinical_fea_pop;
    clinical_EPOP(sum(clinical_EPOP,2)==0,:)=ones(sum(sum(clinical_EPOP,2)==0),size(Cli_data,2));
    clinical_EPOP = [clinical_EPOP;ones(1,size(Cli_data,2))];
    clinical_par1_pop=-10+randi(20,pop_num+1,1);
    clinical_par2_pop=1-randi(11,pop_num+1,1);
    clinical_EPOP = [clinical_EPOP clinical_par1_pop clinical_par2_pop];
    [cli_m,cli_n]=size(clinical_EPOP);

    PET_fea_pop=randi([0,1],pop_num,fea_num).*randi([0,1],pop_num,fea_num);
    PET_EPOP=PET_fea_pop;
    PET_EPOP(sum(PET_EPOP,2)==0,:)=ones(sum(sum(PET_EPOP,2)==0),fea_num);
    PET_EPOP = [PET_EPOP;ones(1,fea_num)];
    PET_par1_pop=-10+randi(20,pop_num+1,1);
    PET_par2_pop=1-randi(11,pop_num+1,1);
    PET_EPOP=[PET_EPOP PET_par1_pop PET_par2_pop];
    [pet_m,pet_n]=size(PET_EPOP);

    CT_fea_pop=randi([0,1],pop_num,fea_num).*randi([0,1],pop_num,fea_num);
    CT_EPOP=CT_fea_pop;
    CT_EPOP(sum(CT_EPOP,2)==0,:)=ones(sum(sum(CT_EPOP,2)==0),fea_num);
    CT_EPOP = [CT_EPOP;ones(1,fea_num)];
    CT_par1_pop=-10+randi(20,pop_num+1,1);
    CT_par2_pop=1-randi(11,pop_num+1,1);
    CT_EPOP=[CT_EPOP CT_par1_pop CT_par2_pop];
    [ct_m, ct_n]=size(CT_EPOP);

    w=rand(pop_num,9);
    w = [w;ones(1,9)./9];

    %% files for recording the performance during training

    final_P=[];
    final_ind=[];
    ParetoResults = cell(it_num,cross_num);% record each pareto performance on test set during iteration
    GroupTestResult = zeros(it_num,5,cross_num);% record group performance on training set
    SingleParetoValResult = cell(it_num,cross_num);% record each pareto performance during iteration
    GroupValResult = zeros(it_num,5,cross_num);% record group performance on validation set

    for c=1:5
        mut_rate0=0.9;  
        
        test = (Indices==c);
        val = (Indices==(mod(c,cross_num)+1));%|(Indices==(mod((mod(c,cross_num)+1),cross_num)+1));(~test);%
        train0=(~test&~val);%(~test);%
        test_num=sum(test);    
        train_num=sum(train0);
        
        [m,n] = size(i_CT_data);
        CT_train_all =  i_CT_data(find(test==0),:);
        CT_train_all_fea = CT_train_all(:,1:n-1);
        CT_train_all_ind = CT_train_all(:,n);
                
        fea = [CT_train_all_fea(:,1:(n-1)/2);CT_train_all_fea(:,(n-1)/2+1:(n-1))];
        fea_all = [i_CT_data(:,1:(n-1)/2);i_CT_data(:,(n-1)/2+1:(n-1))];
        [m1,~] = size(fea);
        [m2,~] = size(fea_all);
        for i=1:size(fea,2) 
            fea_all(:,i)=fea_all(:,i)-repmat(min(fea(:,i)),size(fea_all,1),1);
            fea(:,i)=fea(:,i)-repmat(min(fea(:,i)),size(fea,1),1);
            fea_all(:,i)=fea_all(:,i)./repmat(max(fea(:,i)),size(fea_all,1),1)*2-1;
            fea(:,i)=fea(:,i)./repmat(max(fea(:,i)),size(fea,1),1)*2-1;
        end
        CT_train_pre = fea(1:m1/2,:);
        CT_train_post = fea(m1/2+1:m1,:);
        CT_all_pre = fea_all(1:m2/2,:);
        CT_all_post = fea_all(m2/2+1:m2,:);
        
        CT_train_all_fea = [CT_train_pre,CT_train_post-CT_train_pre];
        CT_Delta_fea = [CT_all_pre,CT_all_post-CT_all_pre];
        
        fea = CT_train_all_fea;
        fea2 = CT_Delta_fea;
        for i=1:size(fea,2) 
            fea2(:,i)=fea2(:,i)-repmat(min(fea(:,i)),size(fea2,1),1);
            fea(:,i)=fea(:,i)-repmat(min(fea(:,i)),size(fea,1),1);
            fea2(:,i)=fea2(:,i)./repmat(max(fea(:,i)),size(fea2,1),1)*2-1;
            fea(:,i)=fea(:,i)./repmat(max(fea(:,i)),size(fea,1),1)*2-1;
        end
        CT_train_all_fea = fea;
        CT_Delta_fea = fea2;

        [ranking,~] = mRMR(CT_train_all_fea, CT_train_all_ind, fea_num);
        
        CT_new_data = [CT_Delta_fea(:,ranking) ind];
        
        CT_test_data=zeros(test_num, size(CT_new_data,2));
        i1=1;
        for i2=1:size(CT_new_data,1)
            if test(i2)==1
                CT_test_data(i1,:)=CT_new_data(i2,:);
                i1=i1+1;
            end
        end
        CT_sam_test_data=CT_test_data(:,(1:size(CT_new_data,2)-1));
        CT_ind_test_data=CT_test_data(:,size(CT_new_data,2));
        CT_ind_test_data=CT_ind_test_data+1;

        CT_train_data=zeros(train_num,size(CT_new_data,2));
        j1=1;
        for j2=1:size(CT_new_data,1)
            if train0(j2)==1
                CT_train_data(j1,:)=CT_new_data(j2,:);
                j1=j1+1;
            end
        end
        % getting training and testing dataset
        CT_train_size = size(CT_train_data,1);
        CT_sam_train_data=CT_train_data(1:CT_train_size,(1:size(CT_train_data,2)-1));
        CT_ind_train_data0=CT_train_data(1:CT_train_size,size(CT_new_data,2));

        CT_val_num = sum(val);
        CT_val_data=zeros(CT_val_num, size(CT_new_data,2));
        i1=1;
        for i2=1:size(CT_new_data,1)
            if val(i2)==1
                CT_val_data(i1,:)=CT_new_data(i2,:);
                i1=i1+1;
            end
        end

        CT_sam_val_data=CT_val_data(:,(1:size(CT_val_data,2)-1));
        CT_ind_val_data=CT_val_data(:,(size(CT_val_data,2)));
        CT_ind_val_data=CT_ind_val_data+1;
        CT_sam_train_data0 = CT_sam_train_data;        
        
        % PET
        [m,n] = size(i_PET_data);
        PET_train_all =  i_PET_data(find(test==0),:);
        PET_train_all_fea = PET_train_all(:,1:n-1);
        PET_train_all_ind = PET_train_all(:,n);
                
        fea = [PET_train_all_fea(:,1:(n-1)/2);PET_train_all_fea(:,(n-1)/2+1:(n-1))];
        fea_all = [i_PET_data(:,1:(n-1)/2);i_PET_data(:,(n-1)/2+1:(n-1))];
        [m1,~] = size(fea);
        [m2,~] = size(fea_all);
        for i=1:size(fea,2) 
            fea_all(:,i)=fea_all(:,i)-repmat(min(fea(:,i)),size(fea_all,1),1);
            fea(:,i)=fea(:,i)-repmat(min(fea(:,i)),size(fea,1),1);
            fea_all(:,i)=fea_all(:,i)./repmat(max(fea(:,i)),size(fea_all,1),1)*2-1;
            fea(:,i)=fea(:,i)./repmat(max(fea(:,i)),size(fea,1),1)*2-1;
        end
        PET_train_pre = fea(1:m1/2,:);
        PET_train_post = fea(m1/2+1:m1,:);
        PET_all_pre = fea_all(1:m2/2,:);
        PET_all_post = fea_all(m2/2+1:m2,:);
        

        PET_train_all_fea = [PET_train_pre,PET_train_post-PET_train_pre];
        PET_Delta_fea = [PET_all_pre,PET_all_post-PET_all_pre];
        
        fea = PET_train_all_fea;
        fea2 = PET_Delta_fea;
        for i=1:size(fea,2) 
            fea2(:,i)=fea2(:,i)-repmat(min(fea(:,i)),size(fea2,1),1);
            fea(:,i)=fea(:,i)-repmat(min(fea(:,i)),size(fea,1),1);
            fea2(:,i)=fea2(:,i)./repmat(max(fea(:,i)),size(fea2,1),1)*2-1;
            fea(:,i)=fea(:,i)./repmat(max(fea(:,i)),size(fea,1),1)*2-1;
        end
        PET_train_all_fea = fea;
        fea2 = PET_Delta_fea;
        
        [ranking,~] = mRMR(PET_train_all_fea, PET_train_all_ind, fea_num);
        PET_Delta_fea = fea2;
        
        PET_new_data = [PET_Delta_fea(:,ranking) ind];
        
        PET_test_data=zeros(test_num, size(PET_new_data,2));
        i1=1;
        for i2=1:size(PET_new_data,1)
            if test(i2)==1
                PET_test_data(i1,:)=PET_new_data(i2,:);
                i1=i1+1;
            end
        end
        PET_sam_test_data=PET_test_data(:,(1:size(PET_new_data,2)-1));
        PET_ind_test_data=PET_test_data(:,size(PET_new_data,2));
        PET_ind_test_data=PET_ind_test_data+1;

        PET_train_data=zeros(train_num,size(PET_new_data,2));
        j1=1;
        for j2=1:size(PET_new_data,1)
            if train0(j2)==1
                PET_train_data(j1,:)=PET_new_data(j2,:);
                j1=j1+1;
            end
        end
        % getting training and testing dataset
        PET_train_size = size(PET_train_data,1);
        PET_sam_train_data=PET_train_data(1:PET_train_size,(1:size(PET_train_data,2)-1));
        PET_ind_train_data0=PET_train_data(1:PET_train_size,size(PET_new_data,2));

        PET_val_num = sum(val);
        PET_val_data=zeros(PET_val_num, size(PET_new_data,2));
        i1=1;
        for i2=1:size(PET_new_data,1)
            if val(i2)==1
                PET_val_data(i1,:)=PET_new_data(i2,:);
                i1=i1+1;
            end
        end

        PET_sam_val_data=PET_val_data(:,(1:size(PET_val_data,2)-1));
        PET_ind_val_data=PET_val_data(:,(size(PET_val_data,2)));
        PET_ind_val_data=PET_ind_val_data+1;
        
        fea = PET_sam_train_data;
        sam_test_data = PET_sam_test_data;
        sam_val_data = PET_sam_val_data;
        for i=1:size(fea,2)
            sam_test_data(:,i)=sam_test_data(:,i)-repmat(min(fea(:,i)),size(sam_test_data,1),1);
            sam_val_data(:,i)=sam_val_data(:,i)-repmat(min(fea(:,i)),size(sam_val_data,1),1);      
            fea(:,i)=fea(:,i)-repmat(min(fea(:,i)),size(fea,1),1);
            sam_test_data(:,i)=sam_test_data(:,i)./repmat(max(fea(:,i)),size(sam_test_data,1),1)*2-1;
            sam_val_data(:,i)=sam_val_data(:,i)./repmat(max(fea(:,i)),size(sam_val_data,1),1)*2-1;
            fea(:,i)=fea(:,i)./repmat(max(fea(:,i)),size(fea,1),1)*2-1;
        end
        PET_sam_train_data0 = fea;
        PET_sam_test_data = sam_test_data;
        PET_sam_val_data = sam_val_data;
        
        %Cli
        cli_test_data=zeros(test_num, size(i_Cli_Data,2));
        i1=1;
        for i2=1:size(i_Cli_Data,1)
            if test(i2)==1
                cli_test_data(i1,:)=i_Cli_Data(i2,:);
                i1=i1+1;
            end
        end
        cli_sam_test_data=cli_test_data(:,(1:size(i_Cli_Data,2)-1));
        cli_ind_test_data=cli_test_data(:,size(i_Cli_Data,2));
        cli_ind_test_data=cli_ind_test_data+1;

        cli_train_data=zeros(train_num,size(i_Cli_Data,2));
        j1=1;
        for j2=1:size(i_Cli_Data,1)
            if train0(j2)==1
                cli_train_data(j1,:)=i_Cli_Data(j2,:);
                j1=j1+1;
            end
        end
        % getting training and testing dataset
        cli_train_size = size(cli_train_data,1);
        cli_sam_train_data=cli_train_data(1:cli_train_size,(1:size(i_Cli_Data,2)-1));
        cli_ind_train_data0=cli_train_data(1:cli_train_size,size(i_Cli_Data,2));

        cli_val_num = sum(val);
        cli_val_data=zeros(cli_val_num, size(i_Cli_Data,2));
        i1=1;
        for i2=1:size(i_Cli_Data,1)
            if val(i2)==1
                cli_val_data(i1,:)=i_Cli_Data(i2,:);
                i1=i1+1;
            end
        end

        cli_sam_val_data=cli_val_data(:,(1:size(cli_val_data,2)-1));
        cli_ind_val_data=cli_val_data(:,(size(cli_val_data,2)));
        cli_ind_val_data=cli_ind_val_data+1;
        
        fea = cli_sam_train_data;
        sam_test_data = cli_sam_test_data;
        sam_val_data = cli_sam_val_data;
        for i=1:size(fea,2)
            sam_test_data(:,i)=sam_test_data(:,i)-repmat(min(fea(:,i)),size(sam_test_data,1),1);
            sam_val_data(:,i)=sam_val_data(:,i)-repmat(min(fea(:,i)),size(sam_val_data,1),1);      
            fea(:,i)=fea(:,i)-repmat(min(fea(:,i)),size(fea,1),1);
            sam_test_data(:,i)=sam_test_data(:,i)./repmat(max(fea(:,i))+1e-6,size(sam_test_data,1),1)*2-1;
            sam_val_data(:,i)=sam_val_data(:,i)./repmat(max(fea(:,i))+1e-6,size(sam_val_data,1),1)*2-1;
            fea(:,i)=fea(:,i)./repmat(max(fea(:,i)),size(fea,1),1)*2-1;
        end
        fea(fea>1)=1;
        sam_test_data(sam_test_data>1)=1;
        sam_val_data(sam_val_data>1)=1;
        cli_sam_train_data0 = fea;
        cli_sam_test_data = sam_test_data;
        cli_sam_val_data = sam_val_data;
        
        %upsamle
        num_sam=length(CT_ind_train_data0)-sum(CT_ind_train_data0)-sum(CT_ind_train_data0);
        num_sam=floor(scale(repeat_index)*num_sam);
%         num_sam=length(CT_ind_train_data0)-sum(CT_ind_train_data0);

        combined_sam = [cli_sam_train_data0, PET_sam_train_data0, CT_sam_train_data0];
        if num_sam>0
            sample=combined_sam(find(CT_ind_train_data0),:)';    
            new_min_sam=SMOTE(sample, num_sam);
%             new_min_sam = sample(:,randi(size(sample,2),1,num_sam));
            new_min_ind=ones(num_sam,1);
            cli_sam_train_data = [cli_sam_train_data0;new_min_sam(1:cli_n-2,:)'];
            PET_sam_train_data = [PET_sam_train_data0;new_min_sam(cli_n-2+1:cli_n-2+fea_num,:)'];
            CT_sam_train_data = [CT_sam_train_data0;new_min_sam(cli_n-2+fea_num+1:end,:)'];
            cli_ind_train_data = [cli_ind_train_data0;new_min_ind];
            PET_ind_train_data=[PET_ind_train_data0;new_min_ind];
            CT_ind_train_data=[CT_ind_train_data0;new_min_ind];
        end

        cli_ind_train_data=cli_ind_train_data+1;
        PET_ind_train_data=PET_ind_train_data+1;
        CT_ind_train_data=CT_ind_train_data+1;

        %training stage
        [pa,f_obj,AUC_f,f_label_ind,f_ind,f_p]=computing_fitnesss_fin1(clinical_EPOP,...
            PET_EPOP,CT_EPOP,w,cli_sam_train_data,PET_sam_train_data,CT_sam_train_data,...
            PET_ind_train_data,cli_sam_val_data,PET_sam_val_data,CT_sam_val_data,...
            PET_ind_val_data);

        [pa,FL,FNDSt]=FNDSf(pa);%fast non dominated sort

        EPOP=[clinical_EPOP PET_EPOP CT_EPOP w];
        ClonePOP=EPOP;
        Clonepa=pa;
        Epal=[pa FL];
        % [ClonePOP,Clonepa,RNDCDt]=RNDCDf(MEPOP,MEpa,pop_num);%ClonePOP
        for i=1:it_num
            mut_rate=mut_rate0;  
            cloneover=[];
            [ClonePOP,time]=BTSwCDf1(EPOP,Epal);
            [cloneover,Clonet]=Clonef(ClonePOP,Clonepa,CS);%cloning
            [cloneover,PNmt]=PNmutation(cloneover,mut_rate,cli_n,pet_n,ct_n);
            NPOP=[EPOP;cloneover];

            cli_NPOP = NPOP(:,(1:cli_n));
            PET_NPOP=NPOP(:,(cli_n+1:cli_n+pet_n));
            CT_NPOP=NPOP(:,(cli_n+pet_n+1:cli_n+pet_n+ct_n)); 
            w_NPOP=NPOP(:,(size(NPOP,2)-8:size(NPOP,2)));

            [Npa,f_obj,AUC_f,f_label_ind,f_ind,f_p,f_pro,f_model,NPOP]=computing_fitnesss_fin(cli_NPOP,...
                PET_NPOP,CT_NPOP,w_NPOP,cli_sam_train_data,PET_sam_train_data,CT_sam_train_data,...
                PET_ind_train_data,cli_sam_val_data,PET_sam_val_data,CT_sam_val_data,PET_ind_val_data);

            while size(NPOP,1)<pop_num
                [cloneover,Clonet]=Clonef(ClonePOP,Clonepa,CS);%cloning
                [cloneover,PNmt]=PNmutation(cloneover,mut_rate,cli_n,pet_n,ct_n);

                cli_clonal = cloneover(:,(1:cli_n));
                PET_clonal=cloneover(:,(cli_n+1:cli_n+pet_n));
                CT_clonal=cloneover(:,(cli_n+pet_n+1:cli_n+pet_n+ct_n));  
                w_clonal=cloneover(:,size(cloneover,2)-8:size(cloneover,2));

                [Npa1,f_obj1,AUC_f1,f_label_ind1,f_ind1,f_p1,f_pro1,f_model1,NPOP1]=computing_fitnesss_fin(cli_clonal,...
                    PET_clonal,CT_clonal,w_clonal,cli_sam_train_data,PET_sam_train_data,CT_sam_train_data,...
                    PET_ind_train_data,cli_sam_val_data,PET_sam_val_data,CT_sam_val_data,PET_ind_val_data);

                Npa=[Npa;Npa1];f_obj=[f_obj f_obj1]; AUC_f=[AUC_f AUC_f1];f_label_ind=[f_label_ind;f_label_ind1];f_model=[f_model f_model1];
                f_ind=[f_ind;f_ind1];f_p=[f_p f_p1];f_pro=[f_pro;f_pro1];NPOP=[NPOP;NPOP1]; 

                temp = [Npa,AUC_f'];
                [temp,ia,ic]=unique(temp,'rows');
                Npa = Npa(ia,:);
                f_obj=f_obj(ia);
                AUC_f=AUC_f(ia);
                f_label_ind=f_label_ind(ia,:);
                f_ind=f_ind(ia,:);
                f_p=f_p(ia);
                f_pro = f_pro(ia,:);
                f_model=f_model(:,ia);
                NPOP=NPOP(ia,:);

                temp = Npa;%[Npa,(round(AUC_f'*10))./10];%
                [temp,ia,ic]=unique(temp,'rows','last');
                Npa = Npa(ia,:);
                f_obj=f_obj(ia);
                AUC_f=AUC_f(ia);
                f_label_ind=f_label_ind(ia,:);
                f_ind=f_ind(ia,:);
                f_p=f_p(ia);
                f_pro = f_pro(ia,:);
                f_model=f_model(:,ia);
                NPOP=NPOP(ia,:);
            end
            [Npa,FL,FNDSt]=FNDSf(Npa);%fast non dominated sort

            %update the parent population
            [EPOP,Epal,E_f,E_AUC,E_label_ind,E_ind,E_p,E_pro,E_model,UPPNSGAIIt]=UPPNSGAIIf(NPOP,Npa,FL,pop_num,f_obj,AUC_f,f_label_ind,f_ind,f_p,f_pro,f_model);    
            Clonepa=Epal(:,(1:size(Npa,2)));
%             fprintf('Training: ');
            [SingleParetoValResult{i,c}, GroupValResult(i,:,c)] = ParetoPredict(Epal, EPOP, E_AUC, E_model, lamda, min_model, class, cli_sam_val_data, PET_sam_val_data,CT_sam_val_data,PET_ind_val_data,cli_n,pet_n,ct_n);
%             fprintf('Testing: ');
            [ParetoResults{i,c}, GroupTestResult(i,:,c)] = ParetoPredict(Epal, EPOP, E_AUC, E_model, lamda, min_model, class,cli_sam_test_data, PET_sam_test_data,CT_sam_test_data,PET_ind_test_data,cli_n,pet_n,ct_n);
            
            if repeat_index==1
                Epal_Record{c,i} = Epal;
            end
        end
        %extracting pareto-optimal solution set 

        pareto=Epal((find(Epal(:,end)==1)),(1:2));    
        fin_POP=EPOP((find(Epal(:,end)==1)),:);
        fin_f=E_f(:,(find(Epal(:,end)==1)));
        fin_AUC=E_AUC(:,(find(Epal(:,end)==1)));
        fin_label_ind=E_label_ind((find(Epal(:,end)==1)),:);
        fin_ind=E_ind((find(Epal(:,end)==1)),:);
        fin_p=E_p(:,(find(Epal(:,end)==1)));
        fin_model=E_model(:,(find(Epal(:,end)==1)));
        m=1;
        while size(pareto,1)<min_model
            m=m+1;
            pareto=[pareto;Epal((find(Epal(:,end)==m)),(1:2))];    
            fin_POP=[fin_POP;EPOP((find(Epal(:,end)==m)),:)];
            fin_f=[fin_f E_f(:,(find(Epal(:,end)==m)))];
            fin_AUC=[fin_AUC E_AUC(:,(find(Epal(:,end)==m)))];
            fin_label_ind=[fin_label_ind;E_label_ind((find(Epal(:,end)==m)),:)];
            fin_ind=[fin_ind; E_ind((find(Epal(:,end)==m)),:)];
            fin_p=[fin_p E_p(:,(find(Epal(:,end)==m)))];
            fin_model=[fin_model E_model(:,(find(Epal(:,end)==m)))];
        end

        %testing stage
        %calculating relative weight
        wt=cal_weight(pareto,fin_AUC,lamda);
        % calculating the output probabilitys
        % IDX=knnsearch(sam_train_data,sam_test_data,'k',10);
        P_fin=zeros(length(PET_ind_test_data),class);
        for j=1:length(PET_ind_test_data)
            %calculating reliability for each test sample
            p=cal_single_probability(cli_sam_test_data(j,:),PET_sam_test_data(j,:),CT_sam_test_data(j,:),fin_POP,fin_model,cli_n,pet_n,ct_n);
            P_fin(j,:)=Analytic_ER_rule(wt,wt,p);
        end
        [SEN,SPE,ACC,AUC,p_value]=cal_evaluation(P_fin,PET_ind_test_data);
        fprintf('For testing sample Sen = %.5f, Spe = %.5f, ACC = %.5f, AUC = %.5f, p_value = %.5f\n', SEN,SPE,ACC,AUC,p_value);
        
        test_record(c,:,repeat_index) = [SEN,SPE,ACC,AUC,p_value];     
        val_record(c,:,repeat_index) = GroupValResult(it_num,:,c);
        final_P=[final_P; P_fin];
        final_ind=[final_ind; PET_ind_test_data];
        save([outputpath, 'PET_Model_CV_',num2str(repeat_index),'_Fold_',num2str(c),'.mat']); 

        clear cli_sam_train_data PET_sam_train_data CT_sam_train_data 
    end
    %%evalucating


    [SEN,SPE,ACC,AUC,p_value]=cal_evaluation(final_P,final_ind);
    fprintf('For all the data Sen = %.5f, Spe = %.5f, ACC = %.5f, AUC = %.5f, p_value = %.5f\n', SEN,SPE,ACC,AUC,p_value);
    fprintf('_________________________________\n\n');
    test_record(6,:,repeat_index) = [SEN,SPE,ACC,AUC,p_value];
    val_record(6,:,repeat_index) = mean(val_record(1:5,:,repeat_index));
    save([outputpath, 'PET_Model_CV_',num2str(repeat_index),'.mat'],'test_record');
end