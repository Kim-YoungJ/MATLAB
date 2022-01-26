% Layer           Remark                          Activation Function
% input           28x28 nodes                     -
% Convolution     20 convoluition filters(9x9)    ReLU
% Pooling         1 mean pooling(2x2)             -
% hidden          100 nodes                       ReLU
% Output          10 nodes                        Softmax

% 10,000images with the training data and verification data in an 8:2 ratio
% multiclass classfication 28x28 pixel image into one of the ten digit
% classes of 0-9

% using minibatch method and Momentum

function [W1 W5 Wo] = MnistConv(W1, W5, Wo, X, D)
    
    alpha = 0.01; %learning rate
    beta = 0.95;  %Momentum constant

    momentum1 = zeros(size(W1));
    momentum5 = zeros(size(W5));
    momentumo = zeros(size(Wo));

    N = length(D);

    bsize = 100; %batch size
    blist = 1:bsize:(N-bsize+1);

    % One epoch loop
    for batch = 1:length(blist)
        dW1 = zeros(size(W1));
        dW5 = zeros(size(W5));
        dWo = zeros(size(Wo));

        % Mini-Batch loop
        begin = blist(batch);
        for k = begin:begin+bsize-1;
            % Forward pass = Inference

            x = X(:,:,k); % input 28x28
            y1 = Conv(x,W1); % Convolution 20x20x20
            y2 = ReLU(y1);
            y3 = Pool(y2); % Pool, 10x10x10
            y4 = reshape(y3, [], 1);     % 2000
            v5 = W5*y4;     % ReLu,  360
            y5 = ReLU(v5);
            v = Wo*y5; % softmax  10
            y = Softmax(v);

            % One - hot encoding 
            d = zeros(10,1);
            d(sub2ind(size(d), D(k),1)) = 1;

            % Backpropagation 
            e = d - y;     % output layer
            delta = e;

            e5 = Wo'*delta; % Hidden(ReLU) layer
            delta5 = (y5 > 0).*e5;

            e4 = W5'*delta5; % Pooling layer

            e3 = reshape(e4, size(y3));

            e2 = zeros(size(y2));
            W3 = ones(size(y2)) / (2*2);
            for c = 1:20
                e2(:,:,c) = kron(e3(:,:,c), ones([2 2])).*W3(:,:,c);
            end

            delta2 = (y2 > 0).*e2; % ReLU layer

            delta1_x = zeros(size(W1));  % Convolutional layer
            for c = 1:20
                delta1_x(:,:,c) = conv2(x(:,:), rot90(delta2(:,:,c),2),'valid');
            end

            dW1 = dW1 + delta1_x;
            dW5 = dW5 + delta5*y4';
            dWo = dWo + delta*y5';
        end

        % Update Weights
        dW1 = dW1 / bsize;
        dW5 = dW5 / bsize;
        dWo = dWo / bsize;

        momentum1 = alpha*dW1 + beta*momentum1;
        W1 = W1 + momentum1;

        momentum5 = alpha*dW5 + beta*momentum5;
        W5 = W5 + momentum5;

        momentumo = alpha*dWo + beta*momentumo;
        Wo = Wo + momentumo;
    end
end



    