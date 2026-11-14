function decv = bayescls(samples, pdfunc, pdparams, apriori)
% Bayes classifier
% samples - matrix of samples to be classified (sample is a row of the matrix; there's no labels column)
% pdfunc - handle to probability density function
% pdparams - a structure containing parameters for pdfunc
% apriori (optional) - row vector of a priori probabilities
% decv - column vector of labels (bayes classifiers' decision)

	% Calculate the density of each sample under each class.
    % pdfunc is the function passed to bayescls by the caller.
	pdfs = pdfunc(samples, pdparams);
	
	% a priori taken into account only if specified by caller
	% If 4 arguments were supplied, use the prior probabilities too.
	if nargin >= 4
		% Multiply each class density by its prior probability.
		pdfs = bsxfun(@times, pdfs, apriori);
	end
	
	% we don't need a posteriori probability value
	[~, mi] = max(pdfs, [], 2);  % ~ means ignore the first output, mi stores the column index.
	
	% class number -> label translation
	decv = pdparams.labels(mi);

end
