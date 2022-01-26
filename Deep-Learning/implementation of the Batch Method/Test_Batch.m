clear all

X = [ 0 0 1;
      0 1 1;
      1 0 1;
      1 1 1;
    ];

D = [ 0
      0
      1
      1];

W = 2*rand(1,3) -1; % initialize weight 

for epoch = 1:40000
    W = Batch_Method(W,X,D); % train
end

N=4; %inference 
for k =1:N
    x=X(k,:)';
    v=W*x;
    y=Sigmoid(v)
end
