%% implementation of the SGD(Stochastic Gradient Descent) Method function

function W = SGD_Method(W, X, D); % Weights, inputs, correct_output
    alpha = 0.9; %learning rate

    N=4; % repeat the process for the number of the training data points
    for k = 1:N
        x=X(k,:)';
        d=D(k);

        v=W*x; %neural network
        y=Sigmoid(v); %activation function 

        e=d-y; %Error 
        delta = y*(1-y)*e; 
        dW = alpha*delta*x; % delta rule , weight update

        W(1) = W(1) + dW(1);
        W(2) = W(2) + dW(2);
        W(3) = W(3) + dW(3);
    end
end


