function [J, grad] = linearRegCostFunction(X, y, theta, lambda)
%LINEARREGCOSTFUNCTION Compute cost and gradient for regularized linear 
%regression with multiple variables
%   [J, grad] = LINEARREGCOSTFUNCTION(X, y, theta, lambda) computes the 
%   cost of using theta as the parameter for linear regression to fit the 
%   data points in X and y. Returns the cost in J and the gradient in grad

% Initialize some useful values
m = length(y); % number of training examples
n = length(theta);
% You need to return the following variables correctly 
J = 0;
grad = zeros(size(theta));

% ====================== YOUR CODE HERE ======================
% Instructions: Compute the cost and gradient of regularized linear 
%               regression for a particular choice of theta.
%
%               You should set J to the cost and grad to the gradient.
%

HThetaX = X * theta; % (12 * 2) * (2 * 1) ==> (12 * 1)
SquaredError = sum((HThetaX - y) .* (HThetaX -y));
sumTheta = sum(theta([2:end],:) .* theta([2:end],:)) ;
J = (SquaredError / (2*m)) + ((lambda * sumTheta) / (2*m));

grad(1,:) = sum((HThetaX - y) .* X(:,1)) / m; 
for iter = 2:n,
 sumgrad = sum((HThetaX - y) .* X(:,iter));
 grad(iter,:) = (sumgrad / m) + ((lambda / m) * theta(iter,:)); 
endfor




% =========================================================================

grad = grad(:);

end
