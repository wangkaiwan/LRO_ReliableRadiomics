function [POP,pa,RD]=CRD(tPOP,tpa)
%calculating the relative distance
[m,n]=size(tpa);
% RD=[];
for i=1:m
    RD(i)=0;
   for j=1:n
      RD(i)=abs(tpa(i,j)-RD(i));
   end
   RD(i)=RD(i)^2;
end
POP=tPOP;
pa=tpa;