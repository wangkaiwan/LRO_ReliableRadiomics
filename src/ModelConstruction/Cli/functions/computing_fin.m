function [fin_pareto, fin_pop]=computing_fin(pareto,pop,ref_num)
% selecting the final solution according to ER rule
[m,n]=size(pareto);
[POP,pa,RD]=CRD(pop,pareto);
max_idx=zeros(1,n+1);
min_idx=zeros(1,n+1);
for i=1:n
    max_idx(i)=max(pareto(:,i));
    min_idx(i)=min(pareto(:,i));
end
max_idx(n+1)=max(RD);
min_idx(n+1)=min(RD);
ref_point=zeros(n+1,ref_num);
for i=1:n
    for j=1:ref_num
        if j==ref_num
            ref_point(i,j)=max_idx(i);
        else
        ref_point(i,j)=min_idx(i)+(j-1)*(max_idx(i)-min_idx(i))/(ref_num-1);
        end
    end
end
for j=1:ref_num
    if j==ref_num
        ref_point(n+1,j)=min_idx(n+1);
    else
    ref_point(n+1,j)=max_idx(n+1)-(j-1)*(max_idx(n+1)-min_idx(n+1))/(ref_num-1);
    end
end
for i=1:m
    T=zeros(n+1,ref_num);
    for j=1:n
        for i0=1:ref_num-1
            if pareto(i,j)>=ref_point(j,i0) && pareto(i,j)<=ref_point(j,i0+1)
                T(j,i0)=(ref_point(j,i0+1)-pareto(i,j))/(ref_point(j,i0+1)-ref_point(j,i0));
                T(j,i0+1)=1-T(j,i0);
            end
        end
    end
    for i1=1:ref_num-1
        if RD(i)<=ref_point(n+1,i1) && RD(i)>=ref_point(n+1,i1+1)
            T(n+1,i1)=(ref_point(n+1,i1)-RD(i))/(ref_point(n+1,i1)-ref_point(n+1,i1+1));
            T(n+1,i1+1)=1-T(n+1,i1);
        end
    end
    beta{i}=T;
end
w=zeros(n+1,1);
for i=1:n+1
    w(i)=1/(n+1);
end
fin_beta=zeros(m,ref_num);
for i=1:m
    fin_beta(i,:)=Analytic_ER_rule(w,w,beta{i});
end
for i=1:ref_num
    weight(i,:)=(i-1)*(1/(ref_num-1));
end
fin_result=fin_beta*weight;
[C,I]=max(fin_result);
fin_pareto=pareto(I,:);
fin_pop=pop(I,:);


    





