% Extract the Texture Feature, Geometry Feature and Intensity feature from
% CT Images in TCIA-CHUM

%% load file path
clc, clear;
dataPath = 'YourDataPath';
folder = {'YourDataFolders'};
addpath(genpath('../FeatureExtractor'))

for index = 1:length(folder)
% load data preprocess record
load([dataPath,'\',folder{index},'\CT_Record_Post.mat']);
pre_record = information;
record = cell(size(information,1),3);

% record errors occured while feature extraction
checkFile = [folder{index},'_CT_Checkfile_Post.txt'];
fid = fopen(checkFile,'w+');

fileNum = size(information,1);
count = 1;
fin_fea = [];
for i = 1:fileNum
    record{i,1} = pre_record{i,1};
    record{i,2} = pre_record{i,6};
    if isempty(pre_record{i,6}) || pre_record{i,6} ==0
        record{i,3} = 0;
        fprintf(fid,['MatData has not been successfuly loaded for patinet ', fileNum,'\n']);
        continue;
    else
        fileName = record{i,1}
        % load CT and Contour data
%         load([dataPath,'\',folder{index},'\',fileName,'\CT\image\newImg.mat']);
        load([dataPath,'\',folder{index},'\',fileName,'\CT\image\oriImg_Post.mat']);
        load([dataPath,'\',folder{index},'\',fileName,'\CT\RTS\oriContour_Post.mat']);
        
        I = oriImg;
        label_img = oriContour;
        label_sum = zeros(size(label_img,1),size(label_img,2));
        for z = 1:size(label_img,3)
            label_img(:,:,z) = label_img(:,:,z)';
            label_sum = label_sum + label_img(:,:,z);
        end
        sliceNum = size(I,3);
        
             %extracting 3D ROI patch
             %extracting maximal and minial z axis value
             z_min=0;
             z_max=0;
             voxel_num=zeros(1,sliceNum);
             for i2=1:sliceNum
                 BW=label_img(:,:,i2);
                 voxel_num(i2)=sum(BW(:));
             end
             for i2=1:sliceNum
                 if voxel_num(i2)~=0
                     z_min=i2;
                     break;
                 end

             end
             for i2=sliceNum:-1:1
                 if voxel_num(i2)~=0
                     z_max=i2;
                     break;
                 end
             end

            if z_min==z_max && z_max==sliceNum
               z_min=z_min-1;
            end
            if z_min==z_max && z_min==1
                z_max=z_max+1;
            end

            if z_min==z_max && z_min>=1 && z_max<size(label_img,3)
                z_max=z_max+1;
            end
            
            x_sum = sum(label_sum');
            x_min = min(find(x_sum>0));
            x_max = max(find(x_sum>0));
            
            y_sum = sum(label_sum);
            y_min = min(find(y_sum>0));
            y_max = max(find(y_sum>0));
            
            [x_max0,y_max0,z_max0] = size(label_img);
            
            x_min2 = max(1,x_min-5);
            y_min2 = max(1,y_min-5);
            z_min2 = max(1,z_min-5);
            
            x_max2 = min(x_max0,x_max+5);
            y_max2 = min(y_max0,y_max+5);
            z_max2 = min(z_max0,z_max+5);
            
            label_img_2=label_img((x_min2:x_max2),(y_min2:y_max2),(z_min2:z_max2));
            I_2=I((x_min2:x_max2),(y_min2:y_max2),(z_min2:z_max2));
            
            oriRes = pre_record{i,2};
            oriResX = oriRes(1);
            oriResY = oriRes(2);
            oriResZ = oriRes(3);
            
            oriDim = size(label_img_2);
            oriDimX = oriDim(1);
            oriDimY = oriDim(2);
            oriDimZ = oriDim(3);
            
            Res = [1 1 1];   %intend resolution
            ResX = Res(1);
            ResY = Res(2);
            ResZ = Res(3);
            
            Dim = floor((oriDim .* oriRes) ./ Res);
            DimX = Dim(1);
            DimY = Dim(2);
            DimZ = Dim(3);     
            
            [X,Y,Z] = meshgrid(oriResY.*(-oriDimY/2+1:oriDimY/2),oriResX.*(-oriDimX/2+1:oriDimX/2),oriResZ*(-oriDimZ/2+1:oriDimZ/2));
            [XI,YI,ZI] = meshgrid(ResY.*(-DimY/2+1:DimY/2),ResX*(-DimX/2+1:DimX/2),ResZ*(-DimZ/2+1:DimZ/2));            
            
            ROI_label_img = interp3(X,Y,Z,label_img_2,XI,YI,ZI,'linear',0);
            ROI_I = interp3(X,Y,Z,I_2,XI,YI,ZI,'linear',0);
            
        try
             SUV_ROI=zeros(size(ROI_I)); 
             j1=1;
             SUV_VEC=[];
             for z=1:size(ROI_label_img,3)
                 for p=1:size(ROI_label_img,1)
                     for q=1:size(ROI_label_img,2)
                         if ROI_label_img(p,q,z)>0.5 
                             SUV_ROI(p,q,z)=ROI_I(p,q,z);
                             SUV_VEC(j1)=ROI_I(p,q,z);
                             j1=j1+1;
                         end
                     end
                 end

             end
             ALL_SUV_VEC=SUV_VEC;
             fin_SUV=ALL_SUV_VEC;
             fin_SUV=double(fin_SUV);
             
             %extract the SUV features
             SUV_max=max(fin_SUV);
             SUV_min=min(fin_SUV);
             SUV_mean=mean(fin_SUV);
             SUV_median=median(fin_SUV);
             SUV_std=std(fin_SUV);
             SUV_var=var(fin_SUV);
             SUV_sum=sum(fin_SUV);
             SUV_skewness=skewness(fin_SUV);
             SUV_kurtosis=kurtosis(fin_SUV);
             SUV_fea=[SUV_max SUV_min SUV_mean SUV_median SUV_std SUV_var SUV_sum SUV_skewness SUV_kurtosis];
             
             % extract the texture feature
             cube=SUV_ROI;   
%              Texture_feature=extracting_texture_feature_CT(cube);
             
            Texture_feature = [];
            voxel_size = [1,2,4];
            quantization = {'Uniform'};
            GrayLevel = [8,16,64,128];
            for vSize = 1:length(voxel_size)
                for gLevel = 1:length(GrayLevel)
                    for qMethod = 1:length(quantization)
                        [ROIonly,levels,ROIbox,maskBox] = prepareVolume(cube,ROI_label_img,'CTscan',1,1,1,voxel_size(vSize),'Matrix',quantization{qMethod},GrayLevel(gLevel));
                        ROIonly_new = ones(max(size(ROIonly,1),2),max(size(ROIonly,2),2),max(size(ROIonly,3),2));
                        ROIonly_new(1:size(ROIonly,1),1:size(ROIonly,2),1:size(ROIonly,3)) = ROIonly;
                        ROIonly = ROIonly_new;
                        glcm = getGLCM(ROIonly,levels);
                        glrlm = getGLRLM(ROIonly,levels);
                        glszm = getGLSZM(ROIonly,levels);
                        [ngtdm,countValid] = getNGTDM(ROIonly,levels);

                        [glcm_textures] = getGLCMtextures(glcm);
                        [glrlm_textures] = getGLRLMtextures(glrlm);
                        [glszm_textures] = getGLSZMtextures(glszm);
                        [ngtdm_textures] = getNGTDMtextures(ngtdm,countValid);

                        glcm_textures = cell2mat(struct2cell(glcm_textures));
                        glrlm_textures = cell2mat(struct2cell(glrlm_textures));
                        glszm_textures = cell2mat(struct2cell(glszm_textures));
                        ngtdm_textures = cell2mat(struct2cell(ngtdm_textures));

                        Texture_feature = [Texture_feature, glcm_textures', glrlm_textures', glszm_textures', ngtdm_textures'];
                        clear glcm glrlm glszm ngtdm
                    end
                end
            end
             
             %extract the geometry features
             volume=length(fin_SUV);
             all_area=zeros(1,size(ROI_label_img,3));
             for i0=1:size(ROI_label_img,3)
                BW=ROI_label_img(:,:,i0);
                all_area(i0)=sum(BW(:));
             end
             [M,I1]=max(all_area);

             B=ROI_label_img(:,:,I1);
             stats=regionprops(B,'MajorAxisLength','MinorAxisLength','Eccentricity','Orientation','BoundingBox','Perimeter');
             stats=stats(1,:);
             major_AL=stats.MajorAxisLength;
             minor_AL=stats.MinorAxisLength;
             Ecc=stats.Eccentricity;                             
             Ori=stats.Orientation;
             w_Bound=stats.BoundingBox(3);
             h_Bound=stats.BoundingBox(4);
             V_Bound=w_Bound*h_Bound*i0;
             Elongation=w_Bound/h_Bound;
             peri=stats.Perimeter;
             Geo_fea=[volume major_AL minor_AL Ecc Elongation Ori V_Bound peri];

             pname=fileName;
             pname=str2double(pname);
             fin_fea(count,:)=[SUV_fea Texture_feature Geo_fea];
             count=count+1;
             record{i,3} = 1;
             fprintf('done\n');
             clear B
        catch
             fprintf(fid, ['There are something wrong extracting feature for data: ', fileName,'\n']);
             record{i,3} = 0;
             continue;
        end
        
    end
end
fclose(fid);
save([dataPath,'\',folder{index},'\','CT_Feature_Record_Post.mat'],'record');
save([dataPath,'\',folder{index},'\','CT_Feature_Scaled_Post.mat'],'fin_fea');
end