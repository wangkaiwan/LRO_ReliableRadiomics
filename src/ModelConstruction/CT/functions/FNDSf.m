function [pa,FL,time]=FNDSf(pa)
% Authors: Maoguo Gong and Licheng Jiao
% April 7, 2006
% Copyright (C) 2005-2006 by Maoguo Gong (e-mail: gongmg@126.com)
%--------------------------------------------------------------------------
tic;
[N,C]=size(pa);
F=zeros(N,N);Fpa=zeros(N,C+2);Fpa(:,1:C)=pa;S=zeros(N,N);
for p=1:N
    P=pa(p,:);Sp=[];
    for q=1:N
        Q=pa(q,:);
        if DONtwo(P,Q)==1
            Sp=[Sp,q];
        elseif DONtwo(Q,P)==1
            Fpa(p,C+1)=Fpa(p,C+1)+1;
        end
        S(p,1:size(Sp,2))=Sp;
    end
    if Fpa(p,C+1)==0
        Fpa(p,C+2)=1;
    end
end
i=1;
isign=find(Fpa(:,C+2)==i);
while size(isign,1)~=0
    for p=1:size(isign,1)
        zzz=S(isign(p),:);aaa=find(zzz==0);
        zzz(aaa)=[];
        for q=1:size(zzz,2)
            Fpa(zzz(q),C+1)=Fpa(zzz(q),C+1)-1;
            if Fpa(zzz(q),C+1)==0
                Fpa(zzz(q),C+2)=i+1;
            end
        end        
    end
    i=i+1;
    isign=[];
    isign=find(Fpa(:,C+2)==i);
end
pa=Fpa(:,1:C);FL=Fpa(:,C+2);
time=toc;