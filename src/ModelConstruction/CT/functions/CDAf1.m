function [POP,pa,padis]=CDAf1(tPOP,tpa) 
% Authors: Maoguo Gong and Licheng Jiao
% April 7, 2006
% Copyright (C) 2005-2006 by Maoguo Gong (e-mail: gongmg@126.com)
%--------------------------------------------------------------------------
[Ns,C]=size(tpa);padis=[];
for i=1:C
    [k,l]=sort(tpa(:,i));
    N=[];M=[];N=tpa(l,:);M=tPOP(l,:);
    tpa=[];tPOP=[];tpa=N;tPOP=M;
    tpa(1,C+1)=Inf;tpa(Ns,C+1)=Inf;
    tpai1=[];tpad1=[];tpai1=tpa(3:Ns,i);tpad1=tpa(1:(Ns-2),i);
    fimin=min(tpa(:,i));fimax=max(tpa(:,i));
    tpa(2:(Ns-1),C+1)=tpa(2:(Ns-1),C+1)+(abs(tpai1-tpad1))/(0.0001+fimax-fimin);
end
pa=tpa(:,1:C);POP=tPOP;padis=tpa(:,C+1);   