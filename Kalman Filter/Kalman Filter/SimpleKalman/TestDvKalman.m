clear
clc
close all

dt = 0.1;
t = 0:dt:10;

Nsamples = length(t);

Xsaved = zeros(Nsamples,2);
Zsaved = zeros(Nsamples,1);

for k=1:Nsamples
    z=GetPos();
    [pos,vel] = DvKalman(z);
    
    Xsaved(k,:) = [pos,vel];
    Zsaved(k) = z;
end

figure(1)
hold on 
plot(t,Zsaved,'r-o')
plot(t,Xsaved(:,1),'b')
legend('Measurement','Kalman')
xlabel('Time[sec]')
ylabel('Postion[m]')

figure(2)
plot(t,Xsaved(:,2))
xlabel('Time[sec]')
ylabel('Velocity[m]')
