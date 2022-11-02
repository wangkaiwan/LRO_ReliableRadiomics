%% load probability and label of augmented test sample
repeat = 100;
uncertainty = cell(5,5);
testAugPath = '../../../data/AleatoricUncertainty/TestAugmentation/';
scorePath = '../../../data/AleatoricUncertainty/';
for it = 1:repeat
    filename = [testAugPath, 'PrepareForRejectOption_test_',num2str(it),'.mat'];
    load(filename,'P','result','Ind');
    for i = 1:5 % repeat 5 time of 5-fold-cv
        for j = 1:5 % 5-fold-cv
            prob = P{i,j};
            entro = prob(:,1).*log(prob(:,1))+prob(:,2).*log(prob(:,2));
            entro = -entro;
            if it==1
                uncertainty{i,j}=entro;
            else
                uncertainty{i,j}=uncertainty{i,j}+entro;
            end
        end
    end
end
for i = 1:5 % repeat 5 time of 5-fold-cv
    for j = 1:5 % 5-fold-cv
        uncertainty{i,j}=uncertainty{i,j}/repeat;
    end
end
save([scorePath, 'AleatoricUncertainty_test.mat'],'uncertainty');

%% load probability and label of augmented validation sample
repeat = 100;
uncertainty_val = cell(5,5);
valAugPath = '../../../data/AleatoricUncertainty/ValAugmentation/';
scorePath = '../../../data/AleatoricUncertainty/';
for it = 1:repeat
    filename = [valAugPath, 'PrepareForRejectOption_val_',num2str(it),'.mat'];
    load(filename,'P_val','result','Ind_val');
    for i = 1:5 % repeat 5 time of 5-fold-cv
        for j = 1:5 % 5-fold-cv
            prob = P_val{i,j};
            entro = prob(:,1).*log(prob(:,1))+prob(:,2).*log(prob(:,2));
            entro = -entro;
            if it==1
                uncertainty_val{i,j}=entro;
            else
                uncertainty_val{i,j}=uncertainty_val{i,j}+entro;
            end
        end
    end
end
for i = 1:5 % repeat 5 time of 5-fold-cv
    for j = 1:5 % 5-fold-cv
        uncertainty_val{i,j}=uncertainty_val{i,j}/repeat;
    end
end
save([scorePath, 'AleatoricUncertainty_val.mat'],'uncertainty_val');