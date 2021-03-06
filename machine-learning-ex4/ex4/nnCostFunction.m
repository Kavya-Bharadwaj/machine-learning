function [J grad] = nnCostFunction(nn_params, ...
                                   input_layer_size, ...
                                   hidden_layer_size, ...
                                   num_labels, ...
                                   X, y, lambda)
%NNCOSTFUNCTION Implements the neural network cost function for a two layer
%neural network which performs classification
%   [J grad] = NNCOSTFUNCTON(nn_params, hidden_layer_size, num_labels, ...
%   X, y, lambda) computes the cost and gradient of the neural network. The
%   parameters for the neural network are "unrolled" into the vector
%   nn_params and need to be converted back into the weight matrices. 
% 
%   The returned parameter grad should be a "unrolled" vector of the
%   partial derivatives of the neural network.
%

% Reshape nn_params back into the parameters Theta1 and Theta2, the weight matrices
% for our 2 layer neural network
Theta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));

Theta2 = reshape(nn_params((1 + (hidden_layer_size * (input_layer_size + 1))):end), ...
                 num_labels, (hidden_layer_size + 1));

% Setup some useful variables
m = size(X, 1);
         
% You need to return the following variables correctly 
J = 0;
Theta1_grad = zeros(size(Theta1));
Theta2_grad = zeros(size(Theta2));

% ====================== YOUR CODE HERE ======================
% Instructions: You should complete the code by working through the
%               following parts.
%
% Part 1: Feedforward the neural network and return the cost in the
%         variable J. After implementing Part 1, you can verify that your
%         cost function computation is correct by verifying the cost
%         computed in ex4.m
%
% Part 2: Implement the backpropagation algorithm to compute the gradients
%         Theta1_grad and Theta2_grad. You should return the partial derivatives of
%         the cost function with respect to Theta1 and Theta2 in Theta1_grad and
%         Theta2_grad, respectively. After implementing Part 2, you can check
%         that your implementation is correct by running checkNNGradients
%
%         Note: The vector y passed into the function is a vector of labels
%               containing values from 1..K. You need to map this vector into a 
%               binary vector of 1's and 0's to be used with the neural network
%               cost function.
%
%         Hint: We recommend implementing backpropagation using a for-loop
%               over the training examples if you are implementing it for the 
%               first time.
%
% Part 3: Implement regularization with the cost function and gradients.
%
%         Hint: You can implement this around the code for
%               backpropagation. That is, you can compute the gradients for
%               the regularization separately and then add them to Theta1_grad
%               and Theta2_grad from Part 2.
%

% X = m * n == 5000 * 400
% Theta1 = 25 * 401
% Theta2 = 10 * 26
% y = 5000 * 1

% Append m x 1 vector of ones to X
X = [ones(m,1) X]; %X = 5000 * 401

Y = zeros(m,num_labels);
%size(y)
for iter = 1:m;
  Y(iter,y(iter)) = 1;
endfor



% calculate a2
z2 = Theta1 * X'; % (25 * 401) * (401 * 5000) => (25*5000) 
a2 = sigmoid(z2); % (25 * 5000)
a2 = a2'; % (5000 * 25)
a2 = [ones(m,1) a2]; % (5000 * 26)
% size(ActivationLayer2)
z3 = Theta2 * a2'; % (10 * 26) * (26 * 5000) ==> (10 * 5000)
a3 = sigmoid(z3); % (10 * 5000)
% a3 is y
a3 = a3'; % (5000 * 10)
HThetaofX = a3;

J = (sum(sum((-Y .* log(HThetaofX)) .- ((1-Y).* log(1-HThetaofX)))))/m;

Theta1_noBias = Theta1(:,[2:end]);
Theta2_noBias = Theta2(:,[2:end]);
Theta1_sum = (sum(sum(Theta1_noBias .* Theta1_noBias)));
Theta2_sum = (sum(sum(Theta2_noBias .* Theta2_noBias)));


RegularizationTerm = (lambda * (Theta1_sum + Theta2_sum)) / (2*m);
%RegularizationTerm
J = J + RegularizationTerm;

Y = zeros(m,num_labels);
for iter = 1:m;
  Y(iter,y(iter)) = 1;
endfor


a1 = zeros(1,nn_params);
DELTA1 = zeros(size(Theta1));
DELTA2 = zeros(size(Theta2));


for iter = 1:m,
  yiter = Y(iter,:); % (1 * 10)
  a1 = X(iter,:); % (1 * 401)
  z2 = Theta1 * a1'; % (25 * 401) * (401*1) = (25 * 1)  
  a2 = sigmoid(z2); % (25 * 1)
  a2 = [1;a2]; % (26 * 1)
  z3 = Theta2 * a2; % (10 * 26) * (26 * 1) = (10 * 1)
  a3 = sigmoid(z3); %(10 * 1)
  delta3 = a3 - yiter'; % (10 * 1) - (10 * 1) = (10 * 1)
  gz2 = sigmoidGradient(z2);
  gz2 = [1;gz2];
  delta2 = (Theta2' * delta3) .* gz2; %((26 * 10) * (10* 1)) .* (26 * 1) = (26 * 1) .* (26 * 1) = (26 * 1) 
  DELTA1 = DELTA1 + (delta2(2:end) * a1); % DELTA1 + ((25 * 1) * (1 * 401))  = DELTA1 + (25 * 401)
  DELTA2 = DELTA2 + (delta3 * a2'); % DELTA2 + ((10 * 1) * (1 * 26)) = DELTA2 + (10 * 26)
endfor

Theta1_reg = (lambda / m) .* Theta1; % (25 * 401)
Theta2_reg = (lambda / m) .* Theta2; % (10 * 26)

DELTA1 = DELTA1 / m; % (25 * 401)
DELTA2 = DELTA2 / m; % (10 * 26)

DELTA1(:,2:end) = DELTA1(:,2:end) + Theta1_reg(:,2:end); % (25 * 400) + (25 * 400)
DELTA2(:,2:end) = DELTA2(:,2:end) + Theta2_reg(:,2:end); % (10 * 25) + (10 * 25)

Theta1_grad = DELTA1;
Theta2_grad = DELTA2;

%Theta1_grad = DELTA1 / m; % (25 * 401)
%Theta2_grad = DELTA2 / m; % (10 * 26)










% -------------------------------------------------------------

% =========================================================================

% Unroll gradients
grad = [Theta1_grad(:) ; Theta2_grad(:)];


end
