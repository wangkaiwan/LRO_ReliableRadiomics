function [sen,spe,acc,auc,p]=cal_evaluation(P,ind)
%evaluating the predictive results
TP=0;FP=0;TN=0;FN=0;
label=zeros(length(ind),1);
for i=1:length(ind)
    [M,I]=max(P(i,:));
    label(i)=I;
end
for m=1:length(ind)
    if label(m)==ind(m) && label(m)==2
        TP=TP+1;
    end
    if label(m)==ind(m)&& label(m)==1
        TN=TN+1;
    end
    if label(m)==2 && ind(m)==1
        FP=FP+1;
    end
    if label(m)==1 && ind(m)==2
        FN=FN+1;
    end
end
AUC_pro=P(:,1);
[X,Y,T,auc]=perfcurve(ind,AUC_pro,'1');
plot(X,Y);
[h,p]=ttest2(AUC_pro,ind);
sen=TP/(TP+FN);
spe=TN/(TN+FP);
acc=(TP+TN)/length(ind);
