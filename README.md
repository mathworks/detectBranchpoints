DESCRIPTION:
Branchpoint detection has long been facilitated by |bwmorph|. However, 
bwmorph yields false positives in many cases. Often, detecting true T-
and Y- branchpoints will provide a better result.

There are 12 candidates that represent all of the "T" or "Y" branchpoints
in a 3x3 matrix. This code uses a lookup table to detect them in
skeletonized binary images.

AUTHOR:
Brett Shoelson, PhD
bshoelso@mathworks.com
08/06/2020

COPYRIGHT:
Copyright 2020 The MathWorks, Inc.