function sample=excSMOTE(T,N,k,type,attribute,AttVector)
% exchange SMOTE by RF


% Implement SMOTE algorithm [1].
% This algorithm resamples the small class through taking each small
% class example and introducing synthetic examples along the line
% segments joining its small class nearest neighbors.
%
% Usage:
%   sample=SMOTE(T,N,k,type,attribute,AttVector)
%
%   sample: instance matrix. 
%                it does not contain original set but new synthetic samplesonly
%     T   : orginal minority class samples. No.Attribute * No.Instance
%     N  : number of new samples to generate
%     k   : k-NN used in the algorithm. default value is 5
%   type: 'nominal' or 'numeric'.the former using VDM to deal with nominal
%            attrinutes when calculate distance while the latter treats nominal 
%            attributes the same as numric ones, i.e. Eular distance is used. 
%            default value: 'numeric'
%  attribute: attribute structure vector carrying VDM information.
%                 Each entry has 3 fields
%                 FIELD kind - 'nominal' or 'numeric'
%                 FIELD values - values on the nominal attribute or [] for numeric attribute 
%                 FIELD VDM - VDM[i,j] denotes VDM distance between i-th value
%                                     and j-th value on the nominal attribute
%  AttVector: attribute vector,1 presents for the corresponding attribute
%                   is nominal and 0 for numeric.
%
% Refer [1]:
% N.V. Chawla, K.W. Bowyer, L.O. Hall, and W.P. Kegelmeyer, ¡°SMOTE:
% synthetic minority over-sampling technique,¡± Journal of Artificial Intelligence 
% Research, vol.16, pp.321¨C357, 2002
% if size(T,1)==33
% nominalInd = [1,3,4,7:10,12,14,30:33];
% numericInd = setdiff([1:33],nominalInd);
% end
% if size(T,1)==27
% nominalInd = [1,3,4,7:12,24:27];
% numericInd = setdiff([1:27],nominalInd);
% end
nominalInd = 1:16;
numericInd = setdiff([1:size(T,1)],nominalInd);

if(nargin<2)
    help smote
elseif(nargin<3)
    k=5;
    type='numeric';
    AttVector=zeros(1,size(T,1));
elseif(nargin<4)
    type='numeric';
    AttVector=zeros(1,size(T,1));
end
if(strcmp(type,'nominal') & nargin<6)
    help smote
end
    
AttVector(nominalInd)=1;


NT=size(T,2);
if(NT==0)
    error('check T.')
elseif(NT==1)%duplicate
    sample=repmat(T,1,N);
else
    % number of nearest neighbours can not be greater than NT-1
    if(k>NT-1)
        k=NT-1;
        warning('not so many instances in T.k is set to %d',k);
    end
    % number of new examples that each example in T should generate
    NumAtt=size(T,1);
    n=floor(N/NT);
    remainder=N-NT*n;
    id=randperm(NT);   
    No=ones(1,NT)*n;
    No(id(1:remainder))=No(id(1:remainder))+1;
    
    % generation
    sample=[];
    for i=find(No~=0)        
        % k-NN
        if(strcmp(type,'numeric'))
            d=dist(T(:,i)', T);
        elseif(strcmp(type,'nominal'))
            aid=find(AttVector==0);
            if(isempty(aid))%SMOTE-N
                d=dist_nominal(T(:,i),T,attribute,AttVector);
            else%SMOTE-NC
                Med=median(std(T(aid,:)'));   
                d=dist_smote(T(:,i),T,AttVector,Med);
            end
        else
            error('type err.\n')
        end
        d(i)=Inf;
        if(k<log(NT))
            min_id=[];
            for j=1:k
                [tmp,id]=min(d);
                d(id)=Inf;
                min_id=[min_id id];% sort>=O(n*logn),so we take min: O(n).total time:O(k*n)
            end
        else
            [tmp,id]=sort(d);
            min_id=id(1:k);
        end
        
        rn=floor(rand(1,No(i))*k)+1;  
        id=min_id(rn);
        weight=rand(NumAtt,No(i));
        D=repmat(T(:,i),1,No(i));      
        % for numeric attributes
        aid=find(AttVector==0);
        newchild = [];
        for c_i = 1:No(i)
            child1 = D(nominalInd,c_i);
            child2 = T(nominalInd,id(c_i));
            newchild(:,c_i) = fun_cross(child1,child2,randi([8,10])/10);
        end
        D(aid,:)=D(aid,:)+weight(aid,:).*(T(aid,id)-D(aid,:));
        D(nominalInd,:) = newchild;
        % for nominal attributes the new instances take the most frequent
        % value in the union of the seed and corresponding k-NN
%         aid=find(AttVector==1);
%         for i_aid=1:length(aid)
%             count=zeros(1,length(attribute(aid(i_aid)).values));
%             for i_v=1:length(attribute(aid(i_aid)).values)
%                 count(i_v)=length(find([T(aid(i_aid),id) D(aid(i_aid),1)]==attribute(aid(i_aid)).values(i_v)));
%             end
%             [tmp,most_id]=max(count);
%             most_nominal(i_aid)=attribute(aid(i_aid)).values(most_id);
%         end
%         D(aid,:)=repmat(most_nominal',1,No(i));
        
        sample=[sample D];        
    end
end
%end

%-------------------------------------------------------------------------

function z = dist_smote(w,p,AttVector,Med)

[R,Nw] = size(w);
[R2,Np] = size(p);
if (R ~= R2)
    error('Attribute numbers do not match.')
end

z = zeros(Nw,Np);
for ii=1:Nw
    id=find(AttVector==0);%numeric
    z(ii,:)= sum((repmat(w(id,ii),1,Np)-p(id,:)).^2);
    id=find(AttVector==1);
    z(ii,:)=z(ii,:)+sum(repmat(w(id,ii),1,Np)~=p(id,:),1)*(Med^2);           
end
z = sqrt(z);

