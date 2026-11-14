function plot2features(tset, f1, f2)
% Plots tset samples on a 2-dimensional diagram
%	using features f1 and f2
% tset - training set; the first column contains class label
% f1 - index of the first feature (mapped to horizontal axis)
% f2 - index of the second feature (mapped to vertical axis)

	% plotting parameters for different classes
	%   restriction to 8 classes seems reasonable
	pattern(1,:) = 'ks';  %	Black square   - 1 is row (i.e., ks, : is all columns
	pattern(2,:) = 'rd';  % Red diamond
	pattern(3,:) = 'mv';  % Magenta upside-down triangle
	pattern(4,:) = 'b^';  % Blue upward triangle
	pattern(5,:) = 'kd';  % Black diamond
	pattern(6,:) = 'r^';  % Red upward triangle
	pattern(7,:) = 'mo';  % Magenta circle
	pattern(8,:) = 'bd';  % Blue diamond

	res = tset(:, [f1, f2]);  %res = result
	
	% extraction of all unique labels used in tset
	labels = unique(tset(:,1));
	if size(labels, 1) > 8
		labels = labels(1:8);
	end
	
	% create diagram and switch to content preserving mode
	figure;  %open a new plot
	hold on; % points to be plotted on same diagram
	for i=1:size(labels,1)
		idx = tset(:,1) == labels(i);
		plot(res(idx,1), res(idx,2), pattern(i,:));
	end
	hold off;
end
