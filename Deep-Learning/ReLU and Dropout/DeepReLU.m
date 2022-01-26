% trains the given deep neural network using the back-propagation algorithm

% W1,W2,W3,and W4 are weight matrices of input-hidden1, hidden1-hidden2
% hidden2-hidden3, hidden3-outputlayers, respectively

function [W1, W2, W3, W4] = DeepReLU(W1, W2, W3, W4, X, D)
    alpha = 0.01;

    N = 5;
    for k = 1:N
        x = reshape(X(:,:,k),25,1);
        d = D(k, :)';

        v1 = W1*x;
        y1 = ReLU(v1);
        v2 = W2*y1;
        y2 = ReLU(v2);
        v3 = W3*y2;
        y3 = ReLU(v3);
        v = W4*y3;
        y = Softmax(v);

        e = d - y;
        delta = e;

        e3 = W4'*delta;
        delta3 = (v3 > 0).*e3; % ReLU function derivative (express True or False)
        e2 = W3'*delta3;
        delta2 = (v2>0).*e2;
        e1 = W2'*delta2;
        delta1 = (v1>0).*e1;

        dW4 = alpha*delta*y3';
        W4 = W4 + dW4;
        dW3 = alpha*delta3*y2';
        W3 = W3 + dW3;
        dW2 = alpha*delta2*y1';
        W2 = W2 + dW2;
        dW1 = alpha*delta1*x';
        W1 = W1 + dW1;
    end
end
