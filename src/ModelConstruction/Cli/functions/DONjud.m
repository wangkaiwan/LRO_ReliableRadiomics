function [DON2,time]=DONjud(pa)
% Authors: Maoguo Gong and Licheng Jiao
% April 7, 2006
% Copyright (C) 2005-2007 Maoguo Gong (e-mail: gongmg@126.com)
%--------------------------------------------------------------------------
tic;
[N,C]=size(pa);
DON2=ones(N,1);
for i=1:N
    temppa=pa;
    temppa(i,:)=[];
    LEsign=ones(N-1,1);
    for j=1:C
        LessEqual=find(temppa(:,j)<=pa(i,j));
        tepa=[];tepa=temppa(LessEqual,:);
        temppa=[];temppa=tepa;
    end
    if size(temppa,1)~=0
        k=1;
        while k<=C
            Lessthan=[];
            Lessthan=find(temppa(:,k)<pa(i,k));
            if size(Lessthan,1)~=0
                DON2(i)=0;k=C+1;
            else
                k=k+1;
            end
        end
    end    
end
time=toc;
