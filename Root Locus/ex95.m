% ex95.m: PID controller design
clear;clc
echo on

% =========================================
% step 1: Evaluate the uncompensated system
% =========================================

% Open-loop system definition
num = [1 8];
den = conv([1 3], conv([1 6],[1 10]));
sys_u = tf(num,den)
POS_spec = 20;
zeta_spec = -log(POS_spec/100)/sqrt(pi^2+(log(POS_spec/100))^2)

pause

figure(1)
rlocus(sys_u)
sgrid(zeta_spec,0)
shg

pause
[Kp1, poles] = rlocfind(sys_u)

%Kp1   = 121.5;
T_u = feedback(Kp1*sys_u, 1)

pause

[wn, zeta] = damp(T_u);
POS_u = exp(-zeta(2)*pi/sqrt(1-zeta(2)^2))*100;
% 2nd and 3rd poles are dominant poles
Ts_u  = 4/(zeta(2)*wn(2));
Tp_u  = pi/(wn(2)*sqrt(1-zeta(2)^2));
e_infty_u = 1/(1+ dcgain(Kp1*sys_u));

damp(T_u)
POS_u
Ts_u
Tp_u
e_infty_u

pause
% =========================================
% step 2: Design PD-controller
% =========================================
% desired peak time (from the specification)
Tp_desired = (2/3)*Tp_u

pause

% desired damped natural frequency(2nd ord approximation)
% (This is the imaginary of the desired dominant poles.)
w_d = pi/Tp_desired

% Angle between the real axis and the 20% OS line (deg)
phi = acos(zeta(2))*180/pi

% Real part of the desired dominant pole
sigma_d = - w_d/tan(phi*pi/180)

pause
% From the PPT, we determined the location of the zero for PD control is
%zc = 55.92;
zc = input('Enter the location of the new zero for PD-control')


% PD controller
con_PD = tf([1 -zc],1)

% system with PD controller
sys_PD = con_PD * sys_u

pause
% Draw root-locus to determine Kp for this PD
figure(2);clf
rlocus(sys_PD)
sgrid(zeta_spec,0)
pause
[Kp2, poles_2] = rlocfind(sys_PD)

pause
T_PD = feedback(Kp2*sys_PD, 1)

pause

[wn_PD, zeta_PD] = damp(T_PD);
POS_PD = exp(-zeta_PD(2)*pi/sqrt(1-zeta_PD(2)^2))*100;
% 2nd and 3rd poles are dominant poles
Ts_PD  = 4/(zeta_PD(2)*wn_PD(2));
Tp_PD  = pi/(wn_PD(2)*sqrt(1-zeta_PD(2)^2));
e_infty_PD = 1/(1+ dcgain(Kp2*sys_PD));

damp(T_PD)
POS_PD
Ts_PD
Tp_PD
e_infty_PD

pause

% =========================================
% step 3 & 4: Simulation check and Redesign
% =========================================
figure(3);clf
step( T_u, T_PD)
grid
legend('Uncompensated(P-control)','PD-control')
shg

pause
% =========================================
% step 5: Design PI-controller
% =========================================
% PI controller we selected
con_PI = tf([1 0.5],[1 0])
sys_PI = con_PI * sys_PD

pause
% We draw root-locus to determine Kp3
figure(4);clf
rlocus(sys_PI)
sgrid(zeta_spec,0)

pause
[Kp3, poles_3] = rlocfind(sys_PI)

pause
T_PI = feedback(Kp3*sys_PI, 1)

pause

[wn_PI, zeta_PI] = damp(T_PI);
POS_PI = exp(-zeta_PI(3)*pi/sqrt(1-zeta_PI(3)^2))*100;
% 3rd and 4th poles are dominant poles
Ts_PI  = 4/(zeta_PD(3)*wn_PI(3));
Tp_PI  = pi/(wn_PI(3)*sqrt(1-zeta_PI(3)^2));
e_infty_PI = 1/(1+ dcgain(Kp3*sys_PI));

damp(T_PI)
POS_PI
Ts_PI
Tp_PI
e_infty_PI

pause

% =========================================
% step 6: Determne controller
% =========================================
con_PID = Kp3 * con_PI * con_PD

pause
% =========================================
% step 7, 8: Simulation check & Redesign
% =========================================
figure(5);clf
step(T_u, T_PD, T_PI, [0:0.005:2])
legend('P-control','PD-control','PID-control')
grid
shg






