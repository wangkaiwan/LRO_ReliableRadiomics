function  [NPOP,time]=Clonef(POP,pa,CS) 
% Authors: Maoguo Gong and Licheng Jiao
% April 7, 2006
% Copyright (C) 2005-2006 by Maoguo Gong (e-mail: gongmg@126.com)
%--------------------------------------------------------------------------
tic
NC=[];
[N,C]=size(POP);
[POP,pa,padis]=CDAf1(POP,pa);
aa=find(padis==inf);
bb=find(padis~=inf);
if length(bb)>0
    padis(aa)=2*max(max(padis(bb)));
    NC=ceil(CS*padis./sum(padis));
else
    NC=ceil(CS/length(aa))+zeros(1,N);
end
NPOP=[];
for i=1:N
    NiPOP=ones(NC(i),1)*POP(i,:);
    NPOP=[NPOP;NiPOP];
end
time=toc;