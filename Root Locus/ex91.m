% ex91.m

% Open-loop system
num = 1;
den = conv([1 1], conv([1 2],[1 10]));
sys = tf(num, den)

pause

% root-locus
figure(1)
clf;
rlocus(sys)
sgrid(0.174, 0);
shg
pause
K = rlocfind(sys)

pause
% closed-loop system with P-control

T = feedback(K*sys, 1)
damp(T)

% steady-state error to step input

e_infty = 1/(1+dcgain(K*sys))
pause

% PI-control
% we add a zero at -0.1

num_con = [1 0.1];
den_con = [1 0];
sys_con = tf(num_con, den_con)
sys_PI  = sys_con * sys
pause

% root-locus
figure(2)
clf;
rlocus(sys_PI)
sgrid(0.174, 0);
shg
pause
K_PI = rlocfind(sys)

pause
% closed-loop system with P-control

T_PI = feedback(K_PI*sys_PI, 1)
damp(T_PI)

% steady-state error to step input

e_infty_PI = 1/(1+dcgain(K_PI*sys_PI))
pause

% Step-response comparision
figure(3);clf
step(T)
hold on
step(T_PI,'r-')
title('Red: with PI-controller, Blue: with P-controller')
grid
shg









