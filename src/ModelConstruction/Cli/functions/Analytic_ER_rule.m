function P_fin=Analytic_ER_rule(r,w,p)
%Analytic ER rule without local ignorance
%input:r: reliability 1xM;w;weight 1xM 1;P:belief degree MxN 
%output: P_fin: final belief degree 1xN

[m,n]=size(p);
P_fin=zeros(1,n);
k1=0;
for i=1:n
    temp=1;
    for j=1:m
        temp=((w(j)*p(j,i)+1-r(j))/(1+w(j)-r(j)))*temp;
    end
    k1=k1+temp;
end
k2=1;
for i=1:m
    k2=((1-r(i))/(1+w(i)-r(i)))*k2;
end
k2=(n-1)*k2;
k=k1-k2;
k=1/k;

for i=1:n
    sec1=1;
    sec2=1;
    for j=1:m
        sec1=((w(j)*p(j,i)+1-r(j))/(1+w(j)-r(j)))*sec1;
        sec2=((1-r(j))/(1+w(j)-r(j)))*sec2;
    end
    numerator=k*(sec1-sec2);
    denominator=1-(k*sec2);
    P_fin(1,i)=numerator/denominator;
end
    
    
    
    
    
    
    
    
    
    


    