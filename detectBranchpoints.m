function [bw, inds, inds2, lut] = detectBranchpoints(skel, includeCrossings)
% [BW, INDS, INDS2, LUT] = DETECTBRANCHPOINTS(SKEL, INCLUDECROSSINGS)
%
% Detect "T" and "Y" branchpoints in images. Optionally, includeCrossings
% ("X"  and "+" branchpoints).
%
% Branchpoint detection has long been facilitated by |bwmorph|. However,
% bwmorph yields false positives in many cases. Often, detecting true "T"
% and "Y" branchpoints will provide a better result.
%
% There are 12 candidates that represent all of the "T" or "Y" branchpoints
% in a 3x3 matrix. This code uses a lookup table to detect them in
% skeletonized binary images.
%
% Additionally, there are 2 candidates that represent all of the "X" and
% "+" branchpoints in a 3x3 matrix. These are included if includeCrossings
% is true.
%
% INPUTS:
% skel      Skeletonized, or infinitely thinned, binary image.
%
% includeCrossings   {true/false} Optionally, include "crossings", or "+-"
%                    branchpoints. Default: false.
%
% OUTPUTS:
% bw        Binary image of detected branchpoints.
%
% inds      Indices of all branchpoints.
%
% inds2     Indices of X and + branchpoints. (Note: indices of T and Y
%           branchpoints are given by setdiff(inds, inds2) if crossings
%           were included.
% 
% lut       The lookup table.
%
% % EXAMPLE 1:
% img = imread('threads.png');
% bw = ~imbinarize(img);
% bw = bwmorph(bw, 'Skel', Inf);
% bw = bwmorph(bw, 'spur', 21);
% imshow(bw)
% % 1: bwmorph:
% branches1 = bwmorph(bw, 'branchpoints');
% [r, c] = find(branches1);
% hold on
% plot(c, r, 'mo', 'MarkerSize', 14)
% branches2 = detectBranchpoints(bw);
% [r, c] = find(branches2);
% hold on
% plot(c, r, 'g.', 'MarkerSize', 24)
% title(sprintf('Magenta Circles: Using bwmorph;\nGreen Dots: Using detectBranchpoints'));
%
% % EXAMPLE 2:
% bw = false(100);
% bw(10:80, 25) = true;
% bw(20:80, 60) = true;
% bw(35, 25:80) = true;
% bw(65, 10:70) = true;
% inds = [1072:100-1:7518, 1519:100+1:5973];
% bw(inds) = true;
% imshow(bw)
% [~, inds1, inds2] = detectBranchpoints(bw, true);
% hold on
% [r, c] = ind2sub(size(bw), setdiff(inds1, inds2));
% plot(c, r, 'r.', 'MarkerSize', 32)
% [r, c] = ind2sub(size(bw), inds2);
% plot(c, r, 'b.', 'MarkerSize', 32)
% title(sprintf('red: T, Y Branchpoints\nblue: X, + Branchpoints'))
% xlim([14 68]);
% ylim([17 71])
%
% Brett Shoelson, PhD
% bshoelso@mathworks.com
% 08/06/2020
%
% See also: bwmorph makelut

% Copyright 2020 The MathWorks, Inc.

if nargin < 2
    includeCrossings = false;
end
lut = makelut(@(x) sum(x(:)) == 4 & ...
    x(5) == 1 & ...
    (all(x([1, 7, 9])) | ...
    all(x([1, 3, 9])) | ...
    all(x([1, 3, 7])) | ...
    all(x([3, 7, 9])) | ...
    all(x([4, 6, 8])) | ...
    all(x([4, 4, 8])) | ...
    all(x([2, 6, 8])) | ...
    all(x([2, 6, 7])) | ...
    all(x([1, 6, 8])) | ...
    all(x([2, 4, 9])) | ...
    all(x([3, 4, 8])) | ...
    all(x([2, 4, 6]))), 3);
if includeCrossings
    lut2 = makelut(@(x) sum(x(:)) == 5 & ...
        x(5) == 1 & ...
        (all(x([2, 4, 6, 8])) | ...
        all(x([1, 3, 7, 9]))), 3);
    lut = lut | lut2;
else
    lut2 = [];
end
bw = bwlookup(skel, lut);
if nargout > 1
    inds = find(bw);
end
if nargout > 2 && includeCrossings
    inds2 = find(bwlookup(skel, lut2));
else
    inds2 = [];
end
    