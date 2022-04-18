%% data read from Arduino UNO
clc;clear all;close all;
csvwrite('t.csv',out.tout);
csvwrite('out.csv',out.output);
%% step 1 Original Data

clc;close all;clear all;

freq=20;
ts=1/freq;            %sampletime
r_cyc=4000*ts;        %Pulse Period
Ncyc=8*4;             %Number of Pulse
tfinal=r_cyc*Ncyc;    %total time
I=tfinal/ts;          %total sample
r=60;                 %Motor angle move range(+-30)
Kp_id=10;              %gain
n=32;                 %number of pulse

t=xlsread('t.csv');
output=xlsread('out.csv');
pt1=zeros([96,16]);
plot(t,output(1:3001,1))

%%
n=15;
for i=1:n 
    if (i==1||i==2||i==3||i==4||i==5||i==8||i==9)
      continue;
    end
pt1(1:end,2*i-1)=t(1:96,1);    %초는 처음부터 하려고
pt1(1:end,2*i)=output((5+200*i):(100+200*i),1);

plot(pt1(:,2*i-1),pt1(:,2*i));hold on;
title('1st step [step response test]');
xlabel('time [t]');ylabel('data'),ylim([-5 65]), grid on
end

%%

plot(t,output(1:3001,:));
xlabel('time [t]');ylabel('Motor output'),ylim([-60 62]), grid on
title('Motor PWM Output');

%% step 2 Normalization
clc;close all;
n=15;               %number of pulse
pt2=zeros([96,16]);
pt12=zeros([96,16]);
for i=1:n
    if (i==1||i==2||i==3||i==4||i==5||i==8||i==9)
      continue;
    end
pt2(1:end,2*i-1)=t(1:96,1);                     %초는 처음부터 하려고
pt12(1:end,2*i)=pt1(1:end,2*i)-pt1(1,2*i);      %시작값 0으로 만들어줌
pt2(1:end,2*i)=pt12(1:end,2*i)/pt12(end,2*i);   %A 

figure(1)
plot(pt2(:,2*i-1),pt2(:,2*i));hold on,grid on   %A
title('normalized step [step response test]');
xlabel('time [t]'), ylabel('normalized data')

figure(2);
plot(pt2(:,2*i-1),pt12(:,2*i));hold on         %B
title('step [step response test]');
xlabel('time [t]');ylabel('normalized data'),grid on

end

%% step 3 Average Data
clc;close all;
n=16;               %number of pulse
sum=zeros([96,16]);
avg=zeros([96,2]);
for i=1:14
       if (i==1||i==2||i==3||i==4||i==5||i==8||i==16)
      continue;
       end 
sum(1:end,2) = sum(1:end,2) + pt2(1:end,2*i);

end
% sum(1:end,2) = pt2(1:end,2)+pt2(1:end,6)+pt2(1:end,8)+pt2(1:end,10)...
%     +pt2(1:end,12)+pt2(1:end,14)+pt2(1:end,16)+pt2(1:end,18)...
%     +pt2(1:end,20)+pt2(1:end,22)+pt2(1:end,24)+pt2(1:end,26)+pt2(1:end,28);


avg(1:end,2)= sum(1:end,2)./(14-7); %i=14에서 continue한 횟수 빼기.
plot(pt2(:,11),avg(1:end,2))
title('average step (DATA based) [step response test]');
xlabel('time [t]');ylabel('average value');
ylim([0 2.1]), grid on, legend('average value')

%%
csvwrite('avg.csv',avg);

%% step 4 최적화

clc;close all;clear all;

freq=20;
ts=1/freq;            %sampletime
r_cyc=4000*ts;        %Pulse Period
Ncyc=8*4;             %Number of Pulse
tfinal=r_cyc*Ncyc;    %total time
I=tfinal/ts;          %total sample
r=60;                 %Motor angle move range(+-30)
Kp_d=10;              %gain
n=32; 


t=load('t.csv');
avg=load('avg.csv');
avg=avg(:,2);

% 나도 값 다 일일이 대충 이쯤이면 좋다,,, 이렇게 넣어봄 / 진짜 러프한 친구 / 값은 그냥 내꺼 주자
T0= 0.5;
k0= 100;
p0=[T0,k0]; 


Tk = fminsearch(@(p)Gnorm(p(1),p(2),ts,Kp_d/50,avg), p0)

Gm=tf ([Kp_d*Tk(2)], [Tk(1) 1 0])
Gm_d= c2d(Gm,ts,'zoh');
Gcl= feedback(Gm_d/50,1);

Gcl_s=step(Gcl);

plot(t(1:96,1),Gcl_s(1:96)),
hold on, 
plot(t(1:96,1),avg,'r'), grid on,
 ylim([0 2.2]), legend ('Optimization TF', 'Original Motor')
title('Step Response');
xlabel('Time[s]');ylabel('Amplitude');
 
 stepinfo(Gcl)

 %%

 e=(Gcl_s(1:96)-avg)/avg*100;
 plot(e), grid on, 
 title('Error about stepresponse and normalization data');
xlabel('Number of sampling time(ts)');ylabel('Error'),
legend('error')

a=mean(e)

 

