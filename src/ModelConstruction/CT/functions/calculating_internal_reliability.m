function R=calculating_internal_reliability(P,val_P)
% calculating the reliability based on the M nearest neighbor in validation
% set using DICE coefficient
% input: P: 1 x N; val_P: M x N; N the class number;
[m,n]=size(val_P);
[max_P,I_P]=max(P);
[max_val,I_val]=max(val_P,[],2);
corr_L=0;
for i=1:m
    if I_val(i)==I_P
        corr_L=corr_L+1;
    end
end
single_R=zeros(1,m);
de_P=0;
for i=1:n
    de_P=de_P+P(i)^2;
end
for i=1:m
    de_1=0;de_2=0;
    mo_1=0;mo_2=0;
    for j=1:n
        de_1=de_1+(P(j)-val_P(i,j))^2;
        de_2=de_2+(1-val_P(i,I_P))^2;
        mo_1=mo_1+val_P(i,j)^2;
    end
    de_1=de_1*de_2;
    mo_1=mo_1+de_P;
    mo_1=mo_1+de_2;
    mo_2=de_2;
    single_R(i)=1-((de_1+de_2)/(mo_1+mo_2));
end
R=(corr_L/m)*(sum(single_R)/m);
       
