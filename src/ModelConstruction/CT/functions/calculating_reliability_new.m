function R=calculating_reliability_new(P)
%calculating the reliability for each classifier
%input: P: probability output MxN
%output: R: reliability 1xM

[m,n]=size(P);
R=zeros(1,m);
for i=1:m
    part1=1;
    num=0;
%     part2=0;
    if P(i,1)>=0.5
        for j=1:m
            if j~=i 
                part1=P(j,2)*part1;
                if P(j,1)>=0.5
                    num=num+1;
                end
            end
        end
    end
    if P(i,1)<0.5
        for j=1:m
            if j~=i
                part1=P(j,1)*part1;
                if P(j,1)<0.5
                    num=num+1;
                end
            end
        end
    end
%     for x=1:m
%         for y=1:m
%             if x~=y && x~=i && y~=i
%                 part2=part2+P(x,1)*P(y,2);
%             end
%         end
%     end
    R(i)=(num/(m-1))*(1-part1);
end
    
    
    
    
    
    
    
    
    