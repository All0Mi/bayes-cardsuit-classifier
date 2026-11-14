%The function changes labels for specific groups of samples so 
% that the two populations use separate class labels (1–4 and 5–8), 
% rather than sharing the same labels.

function [train, test] = load_cardsuits_data()
% Loads the training and testing sets containing card suits data
% Labels are remapped from 1-4 to 1-8 to take into account different printing
% Data files should be in the current working directory

	load train.txt
	load test.txt

	% because our data contains really samples from two populations
	% we replace "client" labels with labels more suitable for classification
	% Start at row 77, then repeat every 152 rows, until row 1824.
	for i=77:152:1824
		train(i:i+75,1) = train(i:i+75,1) + 4; % , 1 means first column for class labels.
		test(i:i+75,1) = test(i:i+75,1) + 4;   % shift the class label, i.e., label 2 becomes 6
	end
end



% i:i+75 selects 76 consecutive rows. For example, when i = 77, it selects rows 77–152.
% train(...) and test(...) apply this change separately to the training and testing datasets.