function [clone0ver,time]=PNmutation(POP,mut_rate,cli_n,pet_n,ct_n)
%static mutation operator
tic;
[m,n]=size(POP);
fea_pop1=POP(:,1:cli_n-2);
par1_pop1=POP(:,cli_n-1);
par2_pop1=POP(:,cli_n);
for m2=1:size(fea_pop1,1)
    for n2=1:size(fea_pop1,2)
        mut_real_rate=rand(1);
        if mut_real_rate>mut_rate
           fea_pop1(m2,n2)=~fea_pop1(m2,n2);
        end
    end
end
fea_pop1(sum(fea_pop1,2)==0,:)=ones(sum(sum(fea_pop1,2)==0),cli_n-2);
for m2=1:length(par1_pop1)
    mut_par1_rate=rand(1);
    if mut_par1_rate>mut_rate
       par1_pop1(m2)=-10+randi(20);
    end
end
for m2=1:length(par2_pop1)
    mut_par2_rate=rand(1);
    if mut_par2_rate>mut_rate
       par2_pop1(m2)=-randi(11)+1;
    end
end

fea_pop2=POP(:,cli_n+1:pet_n+cli_n-2);
par1_pop2=POP(:,pet_n+cli_n-1);
par2_pop2=POP(:,pet_n+cli_n);
for m2=1:size(fea_pop2,1)
    for n2=1:size(fea_pop2,2)
        mut_real_rate=rand(1);
        if mut_real_rate>mut_rate
           fea_pop2(m2,n2)=~fea_pop2(m2,n2);
        end
    end
end
fea_pop2(sum(fea_pop2,2)==0,:)=ones(sum(sum(fea_pop2,2)==0),pet_n-2);
for m2=1:length(par1_pop1)
    mut_par1_rate=rand(1);
    if mut_par1_rate>mut_rate
       par1_pop2(m2)=-10+randi(20);
    end
end
for m2=1:length(par2_pop1)
    mut_par2_rate=rand(1);
    if mut_par2_rate>mut_rate
       par2_pop2(m2)=-randi(11)+1;
    end
end


fea_pop3=POP(:,cli_n+pet_n+1:pet_n+cli_n+ct_n-2);
par1_pop3=POP(:,pet_n+cli_n+ct_n-1);
par2_pop3=POP(:,pet_n+cli_n+ct_n);
for m2=1:size(fea_pop3,1)
    for n2=1:size(fea_pop3,2)
        mut_real_rate=rand(1);
        if mut_real_rate>mut_rate
           fea_pop3(m2,n2)=~fea_pop3(m2,n2);
        end
    end
end
fea_pop3(sum(fea_pop3,2)==0,:)=ones(sum(sum(fea_pop3,2)==0),ct_n-2);
for m2=1:length(par1_pop3)
    mut_par1_rate=rand(1);
    if mut_par1_rate>mut_rate
       par1_pop3(m2)=-10+randi(20);
    end
end
for m2=1:length(par2_pop3)
    mut_par2_rate=rand(1);
    if mut_par2_rate>mut_rate
       par2_pop3(m2)=-randi(11)+1;
    end
end


w_pop=POP(:,(size(POP,2)-8:size(POP,2)));
for m2=1:size(w_pop,1)
    for n2 = 1:size(w_pop,2)
        mut_par2_rate=rand(1);
        if mut_par2_rate>mut_rate
           w_pop(m2,n2)=rand(1);
        end
    end
end

clone0ver=[fea_pop1 par1_pop1 par2_pop1 fea_pop2 par1_pop2 par2_pop2 fea_pop3 par1_pop3 par2_pop3 w_pop];
time=toc;