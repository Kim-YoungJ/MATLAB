% ex88.m
clear;clc
echo on

% Specification
pOS = 1.52;  % Percent overshoot requirement (%)

pause

zeta = -log(pOS/100)/sqrt(pi^2+(log(pOS/100))^2)

pause
% Open-Loop system
pause
num = [1 1.5];
den = conv(conv([1 0],[1 1]), [1 10])
sys = tf(num, den)

% Root locus
pause

figure(1)
rlocus(sys)
sgrid(zeta, 0)
%sgrid
shg

pause
% We determine several gains satisfying %OS or zeta specification 
% approximately.

pause

[K1, cp1]= rlocfind(sys)

pause

[K2, cp2]= rlocfind(sys)

pause

[K3, cp3]= rlocfind(sys)

pause

% Calculate the corresponding zeta, wn, Ts, Tp, Kv

osc_case_1 = find(imag(cp1) ~= 0);
osc_case_2 = find(imag(cp2) ~= 0);
osc_case_3 = find(imag(cp3) ~= 0);

zeta1 = cos(pi-angle(cp1(osc_case_1(1))));
zeta2 = cos(pi-angle(cp2(osc_case_2(1))));
zeta3 = cos(pi-angle(cp3(osc_case_3(1))));

wn1 = abs(cp1(osc_case_1(1)));
wn2 = abs(cp2(osc_case_2(1)));
wn3 = abs(cp3(osc_case_3(1)));

Ts1 = 4/(zeta1 * wn1);
Ts2 = 4/(zeta2 * wn2);
Ts3 = 4/(zeta3 * wn3);

Tp1 = pi/(wn1 * sqrt(1-zeta1^2));
Tp2 = pi/(wn2 * sqrt(1-zeta2^2));
Tp3 = pi/(wn3 * sqrt(1-zeta3^2));

Kv1 = dcgain(K1 * tf([1 0],1) * sys);
Kv2 = dcgain(K2 * tf([1 0],1) * sys);
Kv3 = dcgain(K3 * tf([1 0],1) * sys);

pause

ans_matrix = [ cp1(osc_case_1(1))  K1   Ts1  Tp1 Kv1 
               cp2(osc_case_2(1))  K2   Ts2  Tp2 Kv2 
               cp3(osc_case_3(1))  K3   Ts3  Tp3 Kv3  ];

%'-----------------------------------------------------------------------------------------')
%' Closed-loop poles  Gain                    Ts              Tp                 Kv        ')
%'-----------------------------------------------------------------------------------------')
ans_matrix
%'-----------------------------------------------------------------------------------------')

pause

% Now we check if the chosen gains satisfy the specification.

pause

% Closed-loop transfer functions
T1 = feedback(K1 *sys,1);
T2 = feedback(K2 *sys,1);
T3 = feedback(K3 *sys,1);

pause

%'-----------------------')
%' Simulation: step resp ')
%'-----------------------')

pause

tspan = 0:0.01:10;

y1 = step(T1, tspan);
y2 = step(T2, tspan);
y3 = step(T3, tspan);

pause 

figure(2)
plot(tspan, y1, tspan, y2, tspan, y3);
legend('Case 1', 'Case 2', 'Case 3')
xlabel('Time (sec)')
ylabel('Output y(t)')
grid
shg

pause

% Calcuation of %OS based on time response
pause

max_y1 = max(y1); POS_1 = abs((max_y1 - 1))*100;
max_y2 = max(y2); POS_2 = abs((max_y2 - 1))*100;
max_y3 = max(y3); POS_3 = abs((max_y3 - 1))*100;

Tp1_index = find(y1 == max_y1); Tp1_time = tspan(Tp1_index);
Tp2_index = find(y2 == max_y2); Tp2_time = tspan(Tp2_index);
Tp3_index = find(y3 == max_y3); Tp3_time = tspan(Tp3_index);

ans_matrix1 = [ 1    POS_1 Tp1_time
                2    POS_2 Tp2_time
                3    POS_3 Tp3_time ];

%'---------------------------')
%' Case      %OS    Tp       ')
%'---------------------------')
ans_matrix1
%'---------------------------')
pause


%  You may use the tool for Response analysis GUI (LTI Viewer): ltiview
pause
ltiview

%'---------------------------')
%          Re-design         ')
%'---------------------------')
pause

figure(1)
hold on
[K4, cp4]= rlocfind(sys)
T4 = feedback(K4 *sys,1);
y4 = step(T4, tspan);
max_y4 = max(y4); POS_4 = abs((max_y4 - 1))*100;




