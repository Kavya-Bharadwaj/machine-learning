function idx = findClosestCentroids(X, centroids)
%FINDCLOSESTCENTROIDS computes the centroid memberships for every example
%   idx = FINDCLOSESTCENTROIDS (X, centroids) returns the closest centroids
%   in idx for a dataset X where each row is a single example. idx = m x 1 
%   vector of centroid assignments (i.e. each entry in range [1..K])
%

% Set K
K = size(centroids, 1);

% You need to return the following variables correctly.
idx = zeros(size(X,1), 1);

% ====================== YOUR CODE HERE ======================
% Instructions: Go over every example, find its closest centroid, and store
%               the index inside idx at the appropriate location.
%               Concretely, idx(i) should contain the index of the centroid
%               closest to example i. Hence, it should be a value in the 
%               range 1..K
%
% Note: You can use a for-loop over the examples to compute this.
%

size(centroids)
iterations = size(X,1)

for iter = 1:iterations
  shortestdist = 99999999;
  cindex = 0;
  for j = 1:K
   
    point1 = X(iter,:);
    point2 = centroids(j,:);
    points = [point1;point2];
    currentdist = pdist(points);
    if (j == 1)
       shortestdist = currentdist;
       cindex = 1;
    end
    %fprintf("Distance from element %d to centroid %d is %d. Shortest %d\n",iter,j,currentdist,shortestdist);
    if currentdist < shortestdist,
    
          shortestdist = currentdist;
          cindex = j;  

    end
  endfor 
idx(iter,1) = cindex;
%fprintf("closest centroid to %d is %d\n", iter, cindex);
endfor

% =============================================================

end

