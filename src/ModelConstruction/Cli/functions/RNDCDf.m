function [EPOP,Epa,time]=RNDCDf(POP,pa,NM)
% Authors: Maoguo Gong and Licheng Jiao
% April 7, 2006
% Copyright (C) 2005-2006 by Maoguo Gong (e-mail: gongmg@126.com)
%--------------------------------------------------------------------------
tic;
[Ns,C]=size(pa);padis=[];
i=1;
while i<Ns %去掉重复的个体
    deltf=pa-ones(Ns,1)*pa(i,:);
    deltf(i,:)=inf;
    aa=find(sum(abs(deltf),2)==0);
    POP(aa,:)=[];pa(aa,:)=[];
    [Ns,C]=size(pa);i=i+1;
end
if Ns>NM
    for i=1:C
        [k,l]=sort(pa(:,i));
        N=[];M=[];N=pa(l,:);M=POP(l,:);
        pa=[];POP=[];pa=N;POP=M;
        pa(1,C+1)=Inf;pa(Ns,C+1)=Inf;
        pai1=[];pad1=[];pai1=pa(3:Ns,i);pad1=pa(1:(Ns-2),i);
        fimin=min(pa(:,i));fimax=max(pa(:,i));
        pa(2:(Ns-1),C+1)=pa(2:(Ns-1),C+1)+(pai1-pad1)/(0.0001+fimax-fimin);
    end
    padis=pa(:,C+1);pa=pa(:,1:C);POP=POP;
    [aa,ss]=sort(-padis);
    EPOP=POP(ss(1:NM),:);Epa=pa(ss(1:NM),:);
else
    EPOP=POP;Epa=pa;
end
time=toc;