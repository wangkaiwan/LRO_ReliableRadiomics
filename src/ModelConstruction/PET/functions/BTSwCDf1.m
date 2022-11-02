function [NPOP,time]=BTSwCDf1(EPOP,Epal)
% Authors: Maoguo Gong and Licheng Jiao
% April 7, 2006
% Copyright (C) 2005-2006 by Maoguo Gong (e-mail: gongmg@126.com)
%--------------------------------------------------------------------------
tic;
NPOP=[];Npal=[];
[N,C]=size(Epal);
fc=C-1;
for i=1:max(Epal(:,C))
    aaa=find(Epal(:,C)==i);
    tpa=Epal(aaa,1:fc);
    tPOP=EPOP(aaa,:);
    [ttPOP,ttpa,ttI]=CDAf1(tPOP,tpa);%calculate crowding-distancein Fi
%     [ttPOP,ttpa,ttI]=CRD(tPOP,tpa);
    EPOP(aaa,:)=ttPOP;
    Epal(aaa,1:fc)=ttpa;
    Epal(aaa,fc+1)=i+zeros(length(aaa),1);
    Epal(aaa,fc+2)=ttI;    
end
for i=1:N
    NPOP(i,:)=EPOP(i,:);
    Npal(i,:)=Epal(i,:);
    b1=ceil(rand*(N-0.5)+0.5);    
    if b1~=i
        if Epal(i,fc+1)>Epal(b1,fc+1)
            NPOP(i,:)=EPOP(b1,:);
            Npal(i,:)=Epal(b1,:);
        elseif (Epal(i,fc+1)==Epal(b1,fc+1))&(Epal(i,fc+2)>Epal(b1,fc+2))
            NPOP(i,:)=EPOP(b1,:);
            Npal(i,:)=Epal(b1,:);
        end
    end
end
time=toc;