function [AB,A,B] = find_classification_indices(ClassifiedCells,type)
%% type =1 for time cell and type = 2 for odor cell
    index= NaN(size(ClassifiedCells,1),1);
    for i = 1:size(ClassifiedCells,1)
        if ClassifiedCells{i,2}==type && ClassifiedCells {i,6}==type
            index(i,1)=1;
        elseif ClassifiedCells{i,2}==type && ClassifiedCells{i,6}==0
            index(i,1)=2;
        elseif ClassifiedCells{i,2}==0 && ClassifiedCells{i,6}==type
            index(i,1)=3;
        else
            index(i,1)=0;
        end
    end

    AB  =find(index(:,1)==1);
    A   =find(index(:,1)==2);
    B   =find(index(:,1)==3);
end