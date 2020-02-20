clear all
clc
close all
global Port
disp('Starting session...');
    aux = instrfind;
        for i=1:length(aux)
            fclose(aux(i));
            delete(aux(i));
        end
    clear aux
Port = struct;
Port.serialPort = ['COM6'];          % define COM port #
Port.offsetang1 = 512;               % offset for the first joint
Port.offsetang2 = 512;               % offset for the second joint
Port.offsetang3 = 512;               % offset for the third joint
Port.PWM_offset = 1000;              % the offset for the PWM control
Port.s = serial(Port.serialPort);
set(Port.s,'BaudRate',1000000);
fopen(Port.s);
gotoConfig = hex2dec({'AA','03','FF','FE','06','F6'});
Port.s.RecordMode = 'index';
Port.s.RecordDetail = 'verbose';
Port.s.RecordName = 'serialLog.txt';
record(Port.s)
fwrite(Port.s,gotoConfig);
data = dec2hex(fread(Port.s,18));
% fwrite(Port.s,hex2dec({'aa','03','1','fe','1','F9'}));
% ping=fread(Port.s,6);
Port.writePWM = uint8(0);
Port.writePWM(1:17) = Port.writePWM;
Port.writePWM(1:16) = [170 14 255 254 131 16 2 1 0 0 2 0 0 3 0 0]; % dont change this
Port.CycleRead = uint8(0);
Port.CycleRead(1:6) = Port.CycleRead;
Port.CycleRead(1:6) = [ 170 3 255 254 7 245];

State=[0;0;0;0;0;0];
tau=[0;0;0];
data2=zeros(3,1);
load('m3.mat')
u(:,1)=0;
ui(1:3,1:3)=0;
Ts=0.045;
p1=0.0773346054189571;  pi1=0.000997098138654076;   p1d=6.92476986915920e-05;
p2=0.0794412433674488;  pi2=0.00178268032161198;    p2d=0.000285914784093145;
p3=0.0799872693981936;  pi3=0.00415333718064728;    p3d=0.000295068632439317;
er=zeros(3,length(q1f));
dq=zeros(3,length(q1f));
q=zeros(3,length(q1f));
t=zeros(1,length(q1f));
k=zeros(3,length(q1f));
ki=zeros(3,length(q1f));
kd=zeros(3,length(q1f));
N=length(q1f);
data1=q1f(:,1);
q1ff=[smooth(q1f(1,:)')';smooth(q1f(2,:)')';smooth(q1f(3,:)')'];
c=1;
tic
while c<N
    c=c+1;
    data1(:,c)=reader;
    q(:,c)=data1(:,c);
    if c==1
        dq(:,c)=[0;0;0];
    else
        dq(:,c)=(data1(:,c)-data1(:,c-1))/Ts;
    end
    s_x=[q(:,c);dq(:,c)];
    State(:,c)=s_x;
     er(1,c)=q1ff(1,c)-data1(1,c);
     er(2,c)=q1ff(2,c)-data1(2,c);
     er(3,c)=q1ff(3,c)-data1(3,c);
     k(1:3,c)=[p1*er(1,c);p2*er(2,c);p3*er(3,c)];
     ki(1:3,c)=[pi1*sum(er(1,1:c));pi2*sum(er(2,1:c));pi3*sum(er(3,1:c))];
     kd(1:3,c)=[p1d*(er(1,c)-er(1,c-1))/Ts;p2d*(er(2,c)-er(2,c-1))/Ts;p3d*(er(3,c)-er(3,c-1))/Ts];
     u(1,c)=k(1,c)+kd(1,c)+ki(1,c);
     u(2,c)=k(2,c)+kd(2,c)+ki(2,c);
     u(3,c)=k(3,c)+kd(3,c)+ki(3,c);
     d(c,:)=writer([u(1,c);u(2,c);u(3,c)]);
      t(c)=toc;
    if(c==1)
        while(t(c)<Ts)
            t(c)=toc;
        end
    else
        while(t(c)<t(c-1)+Ts)
            t(c)=toc;
        end
    end
end
writer([0;0;0]);
fclose(Port.s);