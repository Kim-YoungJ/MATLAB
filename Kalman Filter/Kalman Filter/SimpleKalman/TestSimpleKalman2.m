clear all 
clc 
close all

dt = 0.2;
t = 0:dt:10;

Nsamples = length(t);

Xsaved = zeros(Nsamples,3);
Zsaved = zeros(Nsamples,1);

for k =1:Nsamples 
    z = GetVolt();
    [volt, Cov, Kg] = SimpleKalman2(z);
    
    Xsaved(k,:) = [volt, Cov, Kg];
    Zsaved(k) = z;
end

figure(1)
plot(t,Xsaved(:,1),'o-')
hold on 
plot(t,Zsaved,'r:*')
xlabel('Time[sec]')
ylabel('Voltage[V]')
legend('Kalman','Measurement')

figure(2) 
plot(t,Xsaved(:,2),'o-')
xlabel('Time[esc]')
ylabel('P')

figure(3)

plot(t,Xsaved(:,3),'o-')
xlabel('Time[esc]')
ylabel('K')