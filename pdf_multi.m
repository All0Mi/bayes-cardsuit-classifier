function pdf = pdf_multi(pts, para)
% Computes multivariate probability density function
% pts  - contains points for which pdf is computed (sample = row)
% para - structure containing parameters:
%	para.labels - class labels
%	para.mu - features' mean values (row per class)
%	para.sig - features' covariance matrices (LAYER per class)
% pdf - probability density matrix
%	row count = number of samples in pts
%	column count = number of classes

	% final result matrix
	pdf = zeros(rows(pts), rows(para.mu));
	
	% YOUR CODE GOES HERE
	
	% for each class
	for clid = 1:rows(para.labels)
		% nvnpdf is the pre-written function that calculates probability density of samples under 
		% multivariate normal (Gaussian) distribution.
		% call mvnpdf with proper parameters and store result
		% in one column of pdf
		pdf(:,clid) = mvnpdf(pts, para.mu(clid, :), para.sig(:, :, clid));
		
									%^ para.mu(clid,:) -> mean values of all features for clid			
									%^ para.sig(:, :, clid) -> covariance matrix of all features of clid
	end
end
