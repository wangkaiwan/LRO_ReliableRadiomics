function newchild = fun_cross(child1,child2,rate);
feaNum = length(child1);

missInd1 = find(child1<0);
mustCross = missInd1(find(child2(missInd1)>0));

diff = child1-child2;
diffInd = find(diff~=0);

missInd2 = find(child2<0); % <0 means missing value item
diffInd = setdiff(diffInd,missInd2);

diffNum = length(diffInd);
if diffNum>0
    rp = randperm(diffNum);
    crossNum = ceil(rate*diffNum);
    crossInd = diffInd(rp(1:crossNum));
    crossInd = union(crossInd,mustCross);
    
    newchild = child1;
    newchild(crossInd) = child2(crossInd);
else
    newchild = child2;
end