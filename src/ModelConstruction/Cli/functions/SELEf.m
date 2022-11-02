function [EPOP,Epa,time]=SELEf(POP,pa,pop_num)
%selection operator
tic;
[m,n]=size(pa);
if m<=pop_num
    EPOP=POP;
    Epa=pa;
end
RD=[];
if m>pop_num
   for i=1:m
       for j=1:n
        RD(i)=abs(pa(i,j)-RD(i));
       end
       RD(i)=RD(i)^2;
   end
   [B,In]=sort(RD);
    EPOP=[];
    Epa=[];
    for i=1:pop_num
        EPOP=[EPOP;POP(In(i),:)];
        Epa=[Epa;pa(In(i),:)];
    end
end

time=toc;

