%% 추정한 모터 전달함수 성능 확인

clear all; close all; clc;

freq=20;
ts=1/freq; 

Kp_id=10/50;
T=0.2024;
k=141.8790;

Gm=tf ([Kp_id*k], [T 1 0])
%Gm_d= c2d(Gm,ts,'zoh');
Gcl= feedback(Gm,1);

Gcl_d= c2d(Gcl,ts,'zoh');

figure(1); pzmap(Gcl), grid on
hold on,
figure(2); nyquist(Gcl), hold on, 


%% Compemsator

clc;

freq=20;
ts=1/freq;            %sampletime
r_cyc=4000*ts;        %Pulse Period
Ncyc=16*4;             %Number of Pulse
tfinal=r_cyc*Ncyc;    %total time
I=tfinal/ts;          %total sample
r=60;                 %Motor angle move range(+-30)
Kp_d=10;              %gain
n=32; 

zeta=0.707;
wn=8;

sigma=-(zeta*wn);
wcl=wn*sqrt(1-zeta^2);

p1=sigma+1j*wcl;
p2=sigma-1j*wcl;

Tc=-1/(p1+p2);
kc=(Tc/(k*Kp_id))*p1*p2;

Gc=tf([kc*T kc], [Tc 1])
Gc_cl=feedback(Gc*Gm,1)

figure(1); pzmap(Gcl), hold on, pzmap(Gc_cl),grid on

figure(2); nyquist(Gcl), hold on, nyquist(Gc_cl)

figure(3); step(Gcl), hold on, step(Gc_cl),grid on

stepinfo(Gcl)
stepinfo(Gc_cl)

%% data 뽑기

clc;

sim('compensation.slx');

out=simout;

csvwrite('compensator2.csv',out);

%% 노말라제이션 값

t=load('t.csv');
y=load('avgf.csv');
a=load('avg.csv');

plot(t(1:97),y/27.5),
hold on, plot(t(1:96),a);
title('PWM [step response test]');
xlabel('time [t]');ylabel('data'),
xlim([0 5]),ylim([0 2.2]), grid on


%% 실제 데이터 값
clear all; close all; clc;

t=load('t.csv');
y=load('compensator3.csv');
a=load('out.csv');

plot(t(1:1281),y),
hold on, plot(t(1:1281),a(1:1281));
title('PWM [step response test]');
xlabel('time [t]');ylabel('data'),
xlim([0 60]),ylim([-65 65]), grid on,
legend('W/C','Wo/C');

%% PID 설계

clc;

Kpid=10; %모터 돌려보면서 찾기
Tpid=10; %모터 돌려보면서 찾기

Ti=0.5*Tpid;
Td=0.125*Tpid;

kp=0.6*Kpid;
ki=kp/Ti;
kd=kp*Td;

Gpid=tf([kd kp ki],[1 0]);
Gpid_cl=feedback(Gpid*Gm,1);

%%

close all, clear all, clc;

freq=20;
ts=1/freq;            %sampletime
r_cyc=4000*ts;        %Pulse Period
Ncyc=4*4;             %Number of Pulse
tfinal=r_cyc*Ncyc;    %total time
I=tfinal/ts;          %total sample
r=60;                 %Motor angle move range(+-30)
Kp_d=31;              %gain
n=32; 


sim('blockdiagram5.slx');

out=simout;

csvwrite('TK_PID.csv',out);

%%
y=load('TK_PID.csv')
plot(y)


