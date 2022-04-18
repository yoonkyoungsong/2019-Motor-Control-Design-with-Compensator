%% compensator 실제 모터와 전달함수의 비교

clear all; close all; clc;

n=5;
t=load('t.csv');

c1=load('compensator1.csv');
c2=load('compensator2.csv');
c3=load('compensator3.csv');

c4=zeros([96,16]);
c5=zeros([96,16]);
c6=zeros([96,16]);

for i=1:n
    
%     if (i==1||i==2||i==3||i==4||i==5||i==8||i==9)
%       continue;
%     end

c4(1:end,2*i-1)=t(1:96,1);    %초는 처음부터 하려고
c4(1:end,2*i)=c1((5+200*i):(100+200*i),1);
plot(c4(:,2*i-1),c4(:,2*i));hold on;

c5(1:end,2*i-1)=t(1:96,1);    %초는 처음부터 하려고
c5(1:end,2*i)=c2((5+200*i):(100+200*i),1);
plot(c5(:,2*i-1),c5(:,2*i));hold on;

c6(1:end,2*i-1)=t(1:96,1);    %초는 처음부터 하려고
c6(1:end,2*i)=c3((5+200*i):(100+200*i),1);
plot(c6(:,2*i-1),c6(:,2*i));hold on;



title('1st step [step response test]');
xlabel('time [t]');ylabel('data'),ylim([-5 65]), grid on
end

%% step 3 Average Data

clc;close all;

n=15;               %number of pulse
sum1=zeros([96,16]);
sum2=zeros([96,16]);
sum3=zeros([96,16]);

avg1=zeros([96,2]);
avg2=zeros([96,2]);
avg3=zeros([96,2]);

avgf=zeros([96,2]);

for i=1:5
%        if (i==1||i==2||i==3||i==4||i==5||i==8||i==16)
%       continue;
%        end 

sum1(1:end,2) = sum1(1:end,2) + c4(1:end,2*i);
sum2(1:end,2) = sum2(1:end,2) + c5(1:end,2*i);
sum3(1:end,2) = sum3(1:end,2) + c6(1:end,2*i);

end
% sum(1:end,2) = pt2(1:end,2)+pt2(1:end,6)+pt2(1:end,8)+pt2(1:end,10)...
%     +pt2(1:end,12)+pt2(1:end,14)+pt2(1:end,16)+pt2(1:end,18)...
%     +pt2(1:end,20)+pt2(1:end,22)+pt2(1:end,24)+pt2(1:end,26)+pt2(1:end,28);


avg1(1:end,2)= sum1(1:end,2)./5; %i=14에서 continue한 횟수 빼기.
avg2(1:end,2)= sum2(1:end,2)./5;
avg3(1:end,2)= sum3(1:end,2)./5;

avgf(1:end,2)= (avg1(1:end,2)+avg2(1:end,2)+avg3(1:end,2))./3;

plot(avgf(1:end,2))
title('average step (DATA based) [step response test]');
xlabel('time [t]');ylabel('average value');
ylim([0 30]), grid on, legend('average value')

%%
csvwrite('avgf.csv',avgf);

%%

close all; clc;

avg=load('avgf.csv');

plot(avg(1:end,2))
title('average step (DATA based) [step response test]');
xlabel('time [t]');ylabel('average value');
ylim([0 32]), grid on, legend('average value')


