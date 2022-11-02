function [EPOP,Epal,E_f,E_AUC,E_label_ind,E_ind,E_p,E_pro,E_model,time]=UPPNSGAIIf(POP,pa,FL,NM,f,AUC,label_ind,ind,p,pro,model)
% Authors: Maoguo Gong and Licheng Jiao
% April 7, 2006
% Copyright (C) 2005-2006 by Maoguo Gong (e-mail: gongmg@126.com)
%--------------------------------------------------------------------------
tic;
pal=[pa,FL];
[N,fc]=size(pa);
Epal=[]; EPOP=[];
E_f=[];
E_AUC=[];E_label_ind=[];
E_ind=[];E_p=[];E_pro=[];E_model=[];
i=1;
while size(Epal,1)<NM
    Fisign=find(pal(:,fc+1)==i);
    if size(Epal,1)+size(Fisign,1)<=NM
        Epal=[Epal;pal(Fisign,:)];
        EPOP=[EPOP;POP(Fisign,:)];
        E_f=[E_f f(:,Fisign)];
        E_AUC=[E_AUC AUC(:,Fisign)];
        E_label_ind=[E_label_ind;label_ind(Fisign,:)];
        E_ind=[E_ind;ind(Fisign,:)];
        E_p=[E_p p(:,Fisign)];
        E_pro=[E_pro;pro(Fisign,:)];
        E_model=[E_model model(:,Fisign)];
        i=i+1;
    else
        Nneed=NM-size(Epal,1);
        topa=pa(Fisign,:);toPOP=POP(Fisign,:);
        to_f=f(:,Fisign);
        to_AUC=AUC(:,Fisign);
        to_label_ind=label_ind(Fisign,:);
        to_ind=ind(Fisign,:);
        to_p=p(:,Fisign);
        to_model=model(:,Fisign);
        to_pro=pro(Fisign,:);
        [ttPOP,ttpa,ttI,tt_f,tt_AUC,tt_label_ind,tt_ind,tt_p,tt_pro,tt_model]=CDAf(toPOP,topa,to_f,to_AUC,to_label_ind,to_ind,to_p,to_pro,to_model);%calculate crowding-distance in Fi
%         [ttPOP,ttpa,RD]=CRD(toPOP,topa);
        [aaa,bbb]=sort(-ttI);bb=bbb(1:Nneed)';
%         [aaa,bbb]=sort(RD);bb=bbb(1:Nneed)';
        detoPOP=ttPOP(bb,:);detopal=ttpa(bb,:);detopal(:,fc+1)=i;
        deto_f=tt_f(:,bb);
        deto_AUC=tt_AUC(:,bb);deto_label_ind=tt_label_ind(bb,:);
        deto_ind=tt_ind(bb,:);deto_p=tt_p(:,bb);deto_model=tt_model(:,bb);
        deto_pro=tt_pro(bb,:);
        Epal=[Epal;detopal];EPOP=[EPOP;detoPOP];
        E_f=[E_f deto_f];
        E_AUC=[E_AUC deto_AUC]; E_label_ind=[E_label_ind;deto_label_ind];
        E_ind=[E_ind;deto_ind]; E_p=[E_p deto_p];E_model=[E_model deto_model];
        E_pro=[E_pro;deto_pro];
        i=i+1;
    end
end
time=toc;