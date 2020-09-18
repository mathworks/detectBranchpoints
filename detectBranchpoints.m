function bw = detectBranchpoints(skel)
% BW = DETECTBRANCHPOINTS(SKEL)
%
% Detect "T- and Y-" branchpoints in images.
%
% Branchpoint detection has long been facilitated by |bwmorph|. However,
% bwmorph yields false positives in many cases. Often, detecting true T-
% and Y- branchpoints will provide a better result.
%
% There are 12 candidates that represent all of the "T" or "Y" branchpoints
% in a 3x3 matrix. This code uses a lookup table to detect them in
% skeletonized binary images.
%
% % EXAMPLE:
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
% Brett Shoelson, PhD
% bshoelso@mathworks.com
% 08/06/2020
%
% See also: bwmorph makelut

% Copyright 2020 The MathWorks, Inc.

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
bw = bwlookup(skel, lut);