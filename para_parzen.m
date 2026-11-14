%Parzen: A statistical method for estimating a probability density from data, 
%		without assuming a Gaussian distribution.

function para = para_parzen(ts, width)
	if nargin < 2
		width = 0.0001;
	end
% Computes parameters for pdf_parzen
% ts training set (sample = row; the first column contains labels)
% width - Parzen window width
% para - structure containing parameters:
%	para.labels - class labels
%	para.samples - cell array containing class samples
%	para.parzenw - Parzen window width
				% A smaller width gives a narrower window; 
				% a larger width gives a smoother, broader estimate.

	labels = unique(ts(:,1));
	para.labels = labels;
	para.samples = cell(rows(labels),1);
	para.parzenw = width;

	for clid=1:rows(labels)
		para.samples{clid} = ts(ts(:,1) == labels(clid), 2:end);
				  % ^    ^ note cell array indexing
	end
end
