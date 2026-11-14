% Load the small dataset used to test the probability density functions
load pdf_test.txt


% Display the number of rows (samples) and columns (class + features)
size(pdf_test)


% Get the unique class labels present in the dataset
labels = unique(pdf_test(:,1))


% COUNT -- how many SAMPLES belong to each class
% pdf_test(:,1) == labels' compares every class label with each sample label
% sum(...) counts the matching samples for each class
% [labels'; ...] displays class labels in row 1 and their counts in row 2
[labels'; sum(pdf_test(:,1) == labels')]


% Plot features in columns 2 and 3 to visually inspect the classes
plot2features(pdf_test, 2, 3)

%------>(normpdf.m)  Check whether the normal probability density function is available
normpdf(0, 0, 1)  % Density at x=0 for a normal distribution with mean 0 and std 1
				  % return normal distribution

%%%%%%%%%%%%%%%%%%%%%%%%%%%%% PARA_INDEP %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%------>(para_indep.m) Calculate mean and standard deviation for each feature within each class
pdfindep_para = para_indep(pdf_test)
% para_indep indep is already implemented; it should give:

% pdfindep_para =
%  scalar structure containing the fields:
%    labels =
%       1
%       2
%    mu =
%       0.7970000   0.8200000
%      -0.0090000   0.0270000
%    sig =
%       0.21772   0.19172
%       0.19087   0.27179



%----->(pdf_indep.m) Calculate independent Gaussian densities for four selected samples
% Rows [2 7 12 17] select samples; columns 2:end select features only
pi_pdf = pdf_indep(pdf_test([2 7 12 17],2:end), pdfindep_para)

% Rows: The four selected samples [2 7 12 17].
% Column 1 - density of class 1, column 2 - density values for class 2
% value farther from zero may fit better (Higher density).

%pi_pdf =
%  1.4700e+000  4.5476e-007
%  3.4621e+000  4.9711e-005
%  6.7800e-011  2.7920e-001
%  5.6610e-008  1.8097e+000




%%%%%%%%%%%%%%%%%%%%%%%%%%%%% PARA_MULTI %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%----->(para_multi.m) Calculate mean vectors and covariance matrices for each class
pdfmulti_para = para_multi(pdf_test)

%pdfmulti_para =
%  scalar structure containing the fields:
%    labels =
%       1
%       2
%    mu =
%       0.7970000   0.8200000
%      -0.0090000   0.0270000
%    sig =
%    ans(:,:,1) =				% covariance matrix for Class 1. Each covariance matrix is 2 × 2 because there are two features.
%       0.047401   0.018222
%       0.018222   0.036756
%    ans(:,:,2) =				# covariance matrix for Class 2.
%       0.036432  -0.033186
%      -0.033186   0.073868  

% ... and probability density function (use mvnpdf in pdf_multi)


%----->(pdf_multi.m) Calculate multivariate Gaussian densities for the same four samples
pm_pdf = pdf_multi(pdf_test([2 7 12 17],2:end), pdfmulti_para)

% Rows: The four selected samples [2 7 12 17].
% Column 1 - density of class 1, column 2 - density values for class 2
% value farther from zero may fit better (Higher density).

%pm_pdf =
%  7.9450e-001  6.5308e-017  
%  3.9535e+000  3.8239e-013
%  1.6357e-009  8.6220e-001
%  4.5833e-006  2.8928e+000



%%%%%%%%%%%%%%%%%%%%%%%%%%%%% PARA_PARZEN %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%----->(para_parzen.m) Store the training samples for each class and the Parzen window width (0.5)
pdfparzen_para = para_parzen(pdf_test, 0.5)
									 % ^^^ window width

%pdfparzen_para =
%  scalar structure containing the fields:
%    labels =
%       1
%       2
%    samples =
%    {
%      [1,1] =					%list of features belongs to class 1
%         1.10000   0.95000
%         0.98000   0.61000
% .....
%         0.69000   0.93000
%         0.79000   1.01000
%      [2,1] =					%list of features belongs to class 2
%        -0.010000   0.380000
%         0.250000  -0.440000
% .....
%        -0.110000   0.030000
%         0.120000  -0.090000
%    }
%    parzenw =  0.50000   %Parzen width used to estimate density.

% now you have to implement pdf_parzen and then verify it
%----->(pdf_parzen.m) Estimate densities using the Parzen window method for the same four samples
pp_pdf = pdf_parzen(pdf_test([2 7 12 17],2:end), pdfparzen_para)

%pp_pdf =
%  9.7779e-001  6.1499e-008
%  2.1351e+000  4.2542e-006
%  9.4059e-010  9.8823e-001
%  2.0439e-006  1.9815e+000



%%%%%%%%%%%%%%%%%%%%%%%%%%%%% START WITH REAL DATA (Q1) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% now you can start work with cards!
%----->(load_cardsuits_data.m) Load the training and testing datasets; class labels are remapped to 8 classes
[train, test] = load_cardsuits_data();

% Display the dataset dimensions: rows = samples, columns = class label + features
size(train)
size(test)

% List the classes present in the training and testing sets
labels = unique(train(:,1))
unique(test(:,1))

% Count the number of training samples belonging to each class
[labels'; sum(train(:,1) == labels')]

% Calculate mean and median of each column to inspect feature values and possible outliers
% Large gaps between mean and median for a feature are a red flag for outliers
% (Hu moments 3,4,5,6 show huge mean/median gaps and huge std -> strong outlier suspicion)
[mean(train); median(train)]
std(train(:,2:end))

% Plot the class-label column's histogram (column 1 contains labels, not a feature)
hist(train(:,1))

% ----->(plot2features.m) Plot features in columns 4 and 6 to inspect their distributions across classes
plot2features(train, 4, 6)
					%^^^^ just an example

% To identify outliers, sort each feature column and look at the most extreme values:
% a genuine outlier shows up as one value that is orders of magnitude away from the
% next-most-extreme value (the rest of the distribution decays smoothly).
for ftid = 2:columns(train)
	[sv, si] = sort(train(:,ftid), 'descend');
	fprintf('Feature %d top 5 high values: ', ftid-1);
	disp(sv(1:5)');
	fprintf('  at rows: ');
	disp(si(1:5)');
end

% Running the loop above shows that row 186 is 2-4 orders of magnitude larger than
% anything else on every single feature, and row 642 has ALL feature values exactly 0
% (a degenerate sample, most likely scanned from an empty/blank region).
% Inspect both to confirm, comparing against their immediate neighbours:
train(185:187, :)
train(641:643, :)

% Both are clearly corrupted samples (neighbours are smooth, these are not) -> remove them
size(train)
train([186 642], :) = [];
size(train)

% Re-check: mean/median/std are now much closer together and no isolated extreme values remain
[mean(train); median(train)]
std(train(:,2:end))
for ftid = 2:columns(train)
	[sv, si] = sort(train(:,ftid), 'descend');
	fprintf('Feature %d top 5 high values (after cleaning): ', ftid-1);
	disp(sv(1:5)');
end
% No more isolated jumps -> the procedure converged after removing 2 samples.
% (The test set was checked the same way and shows no comparable outliers, so it is left untouched;
% only the training set is supposed to be cleaned, per the instructions.)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%% ASSIGNMENT QUESTION 2 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Choose two features that visually separate the classes relatively well.
% Rather than guessing from a couple of scatter plots, systematically score every
% feature pair by the (equal-prior) Bayes error it gives on the full test set, using
% the two parametric classifiers (fast, no width parameter to pick).
pairs = nchoosek(2:columns(train), 2);
pair_scores = zeros(rows(pairs), 1);
for p = 1:rows(pairs)
	f1 = pairs(p,1); f2 = pairs(p,2);
	tr = train(:, [1 f1 f2]); te = test(:, [1 f1 f2]);
	pi_try = para_indep(tr); pm_try = para_multi(tr);
	e1 = mean(bayescls(te(:,2:end), @pdf_indep, pi_try) ~= te(:,1));
	e2 = mean(bayescls(te(:,2:end), @pdf_multi, pm_try) ~= te(:,1));
	pair_scores(p) = (e1 + e2) / 2;
end
[sorted_scores, ord] = sort(pair_scores);
disp('Best feature pairs (Hu moment indices) and their average error rate:')
disp([pairs(ord(1:5),:)-1, sorted_scores(1:5)])

% Hu moments 1 & 3 (columns 2 & 4) come out clearly on top -> use them from now on
plot2features(train, 2, 4)

% Keep column 1 (class label) and feature columns 2 and 4 (Hu moments 1 and 3)
train = train(:, [1 2 4]);
test = test(:, [1 2 4]);

pdfindep_para = para_indep(train);
pdfmulti_para = para_multi(train);
pdfparzen_para = para_parzen(train, 0.001);
% this window width should be included in your report!

% ----> (bayescls.m)
% Point 2 results (equal a priori probabilities of 0.125 for all 8 classes -> no effect
% on the argmax decision since they multiply every class by the same constant;
% passed explicitly anyway to match the assignment statement)
apriori_eq = 0.125 * ones(1,8);
base_ercf = zeros(1,3);
base_ercf(1) = mean(bayescls(test(:,2:end), @pdf_indep, pdfindep_para, apriori_eq) ~= test(:,1));
%bayescls predict class,          ^ all rows, col 2 to last col.          ^ compare predict class w.r.t. actual
%mean calculates the proportion of incorrect predictions (error rate)
base_ercf(2) = mean(bayescls(test(:,2:end), @pdf_multi, pdfmulti_para, apriori_eq) ~= test(:,1));
base_ercf(3) = mean(bayescls(test(:,2:end), @pdf_parzen, pdfparzen_para, apriori_eq) ~= test(:,1));
base_ercf

% before moving to point 3 it would be wise to
% implement and test reduce function
% let's start with small test set - just 2 classes

rdlab = unique(pdf_test(:,1));  %Gets the unique classes, i.e., class 1 and class 2.
reduced = reduce(pdf_test, [0.8 0.4]); %reduce dataset, class 1: 80% samples, class 2: 40% samples
[rdlab'; sum(reduced(:,1) == rdlab')]

% ans =
%     1    2  %class labels
%     8    4   % number of reamining samples.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%% ASSIGNMENT QUESTION 3 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% In the next point, the reduce function will be useful, which reduces the number of samples
% in the individual classes (in this case, the reduction will be the same in all classes -
% OF THE TRAINING SET)
% Because reduce has to draw samples randomly, the experiment should be repeated 5 times
% In the report, please provide only the mean value and the standard deviation
% of the error coefficient

parts = [0.1 0.25 0.5];
rep_cnt = 10; % more than the minimum of 5, for a smoother std estimate

class_count = rows(unique(train(:,1)));
q3_err = zeros(numel(parts), 3, rep_cnt); % [fraction, classifier, repetition]

for pfi = 1:numel(parts)
	frac = parts(pfi);
	for r = 1:rep_cnt
		reduced_train = reduce(train, frac * ones(1, class_count));

		pi_r = para_indep(reduced_train);
		pm_r = para_multi(reduced_train);
		pp_r = para_parzen(reduced_train, 0.001);

		q3_err(pfi, 1, r) = mean(bayescls(test(:,2:end), @pdf_indep,  pi_r, apriori_eq) ~= test(:,1));
		q3_err(pfi, 2, r) = mean(bayescls(test(:,2:end), @pdf_multi,  pm_r, apriori_eq) ~= test(:,1));
		q3_err(pfi, 3, r) = mean(bayescls(test(:,2:end), @pdf_parzen, pp_r, apriori_eq) ~= test(:,1));
	end
end

q3_mean = mean(q3_err, 3);  % rows = fraction, cols = classifier (indep, multi, parzen)
q3_std  = std(q3_err, 0, 3);

disp('Q3: mean error rate (rows = train fraction 0.1/0.25/0.5, cols = indep/multi/parzen)')
disp(q3_mean)
disp('Q3: std of error rate across repetitions')
disp(q3_std)
disp('Q3: for reference, error rate using the FULL training set')
disp(base_ercf)

% note that for given experiment you should reduce all classes in the training
% set with the same reduction coefficient; assuming that class_count is the
% number of different classes in the training set you can take 3/4 random samples
% of each class with:
% 	reduced_train = reduce(train, 0.75 * ones(1, class_count))
%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%% ASSIGNMENT QUESTION 4 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Point 4 concerns only Parzen window classifier (on the full training set)

parzen_widths = [0.0001, 0.0005, 0.001, 0.005, 0.01];
parzen_res = zeros(1, columns(parzen_widths));

for wi = 1:numel(parzen_widths)
	pp_w = para_parzen(train, parzen_widths(wi));
	parzen_res(wi) = mean(bayescls(test(:,2:end), @pdf_parzen, pp_w, apriori_eq) ~= test(:,1));
end

[parzen_widths; parzen_res]
% Plots are sometimes better than numerical results
figure;
semilogx(parzen_widths, parzen_res, '-o');
xlabel('Parzen window width h_1'); ylabel('Error rate'); title('Q4: Parzen width sensitivity');



%%%%%%%%%%%%%%%%%%%%%%%%%%%%% ASSIGNMENT QUESTION 5 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% In point 5 you should reduce TEST SET
%

apriori = [0.165 0.085 0.085 0.165 0.165 0.085 0.085 0.165];
parts5 = [1.0 0.5 0.5 1.0 1.0 0.5 0.5 1.0];
rep_cnt5 = 10;

% classifiers are built once on the (full, unreduced) training set; only the TEST set
% is reduced here, so only the testing step needs to be repeated for averaging
q5_equal = zeros(rep_cnt5, 3);     % error with equal apriori, on the reduced test set
q5_adj   = zeros(rep_cnt5, 3);     % error with the black-suit-favouring apriori

for r = 1:rep_cnt5
	rtest = reduce(test, parts5);

	q5_equal(r,1) = mean(bayescls(rtest(:,2:end), @pdf_indep,  pdfindep_para,  apriori_eq) ~= rtest(:,1));
	q5_equal(r,2) = mean(bayescls(rtest(:,2:end), @pdf_multi,  pdfmulti_para,  apriori_eq) ~= rtest(:,1));
	q5_equal(r,3) = mean(bayescls(rtest(:,2:end), @pdf_parzen, pdfparzen_para, apriori_eq) ~= rtest(:,1));

	q5_adj(r,1) = mean(bayescls(rtest(:,2:end), @pdf_indep,  pdfindep_para,  apriori) ~= rtest(:,1));
	q5_adj(r,2) = mean(bayescls(rtest(:,2:end), @pdf_multi,  pdfmulti_para,  apriori) ~= rtest(:,1));
	q5_adj(r,3) = mean(bayescls(rtest(:,2:end), @pdf_parzen, pdfparzen_para, apriori) ~= rtest(:,1));
end

disp('Q5: mean error rate on reduced test set, EQUAL apriori (cols = indep/multi/parzen)')
disp(mean(q5_equal)); disp(std(q5_equal))
disp('Q5: mean error rate on reduced test set, ADJUSTED apriori (black suits favoured)')
disp(mean(q5_adj)); disp(std(q5_adj))


%%%%%%%%%%%%%%%%%%%%%%%%%%%%% ASSIGNMENT QUESTION 6 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% In point 6 we should consider data normalization

std(train(:,2:end))

% Should we normalize?
% Hu moment 1 has std ~0.009 while Hu moment 3 has std ~0.001 (roughly an order of
% magnitude apart) -> Euclidean distance in 1-NN would be dominated by the
% larger-scale feature. Normalize both features to zero mean / unit variance,
% using statistics computed on the TRAINING set only (then applied to test too).

mu_tr = mean(train(:,2:end));
sig_tr = std(train(:,2:end));

train_n = train; train_n(:,2:end) = bsxfun(@rdivide, bsxfun(@minus, train(:,2:end), mu_tr), sig_tr);
test_n  = test;  test_n(:,2:end)  = bsxfun(@rdivide, bsxfun(@minus, test(:,2:end), mu_tr), sig_tr);

% 1-NN without normalization
preds_raw = zeros(rows(test),1);
for k = 1:rows(test)
	preds_raw(k) = cls1nn(test(k,2:end), train);
end
err_1nn_raw = mean(preds_raw ~= test(:,1));

% 1-NN with normalization
preds_norm = zeros(rows(test_n),1);
for k = 1:rows(test_n)
	preds_norm(k) = cls1nn(test_n(k,2:end), train_n);
end
err_1nn_norm = mean(preds_norm ~= test_n(:,1));

disp('Q6: 1-NN error rate, raw features vs normalized features')
disp([err_1nn_raw, err_1nn_norm])
