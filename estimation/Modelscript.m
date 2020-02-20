clear all
clc
close all
syms q1 q2 q3 q1d q2d q3d q1dd q2dd q3dd tau1 tau2 tau3 I1x I1y I1z I2x I2y I2z I3x I3y I3z m1 m2 m3 l1 l2 l3 'real'
I1x=0;
I1y=0;
I2x=0;
I2y=0.042;
I2z=0;
I3x=0.015;
I3y=0.018;
I3z=0;
b1=0;
b2=0.0095;
b3=0.0074;
m1=0.110;
m2=0.160;
m3=0.175;
l1=0.04;
l2=0.118;
l3=0.085+0.087;
Ts=0.045;
x=[q1 q2 q3 q1d q2d q3d q1dd q2dd q3dd tau1 tau2 tau3];
g=10;
M11=I1x+I1y+I2x*cos(q2)^2+I2y*sin(q2)^2+I2z+I3x*cos(q2+q3)^2+I3y*sin(q2+q3)^2+I3z+m3*l2*cos(q2)^2+m3*l2*l3*cos(q2)*cos(q2+q3);
M22=I2x+I2y+I3x+I3y+m3*l2^2+m3*l2*l3*cos(q3);
M23=I3x+I3y+1/2*m3*l2*l3*cos(q3);
M32=M23;
M33=I3x+I3y;
M=[M11 0 0; 0 M22 M23;0 M32 M33];
V112=(I2y-I2x)*sin(q2)*cos(q2)+(I3y-I3x)*sin(q2+q3)*cos(q2+q3)-m3*l2^2*sin(q2)*cos(q2)-1/2*m3*l2*l3*sin(2*q2+q3);
V113=(I3y-I3x)*sin(q2+q3)*cos(q2+q3)-1/2*m3*l2*l3*cos(q2)*sin(q2+q3);
V223=-1/2*m2*l2*l3*sin(q3);
B=[V112 V113 0; 0 0 V223;0 0 0];
V211=(I2x-I2y)*sin(q2)*cos(q2)+(I3x-I3y)*sin(q2+q3)*cos(q2+q3)+m3*l2^2*sin(q2)*cos(q2)+1/2*m3*l2*l3*sin(2*q2+q3);
V233=-1/2*m2*l2*l3*sin(q3);
V311=(I3x-I3y)*sin(q2+q3)*cos(q2+q3)+1/2*m3*l2*l3*cos(q2)*sin(q2+q3);
V322=1/2*m3*l2*l3*sin(q3);
C=[0 0 0; V211 0 V233; V311 V322 0];
c2=(1/2*m2+m3)*g*l2*cos(q2)+1/2*m3*g*l3*cos(q2+q3);
c3=1/2*m3*g*l3*cos(q2+q3);
G=[0; c2;c3];Lf1=0;Lf2=0;Lf3=0;
Qm(q1,q2,q3,q1d,q2d,q3d,q1dd,q2dd,q3dd,tau1,tau2,tau3)=M*[q1dd;q2dd;q3dd]+2*B*[q1d*q2d;q1d*q3d;q2d*q3d]+C*[q1d^2; q2d^2; q3d^2]+ G + [b1 0 0;0 b2 0;0 0 b3]*[q1d;q2d;q3d]-[tau1;tau2;tau3];
q2=0;q3=0;
Bs=[zeros(3);inv(eval(M))];
As=[zeros(3),eye(3);zeros(3),[b1 0 0;0 b2 0;0 0 b3]*inv(eval(M))];
Cs=eye(3);
Cs(1:3,4:6)=zeros(3);
Ds=zeros(3);
K=place(As,Bs,[-1 -2 -3 -4 -5 -6]);
s=tf('s');
H=Cs*inv(s*eye(6)-As)*Bs+Ds;
L=place(As',Cs',[-1 -2 -3 -2.5 -3.5 -1.5]);
%% Discrete linear model with observer+control
% B=[zeros(3); 0.354082346381905 0 0;0 1.246210340211422 -1.248976771390399; 0 1.248976771390399  2.501749343700789];
% A=zeros(6);
% A(1:3,4:6)=eye(3);
% C=eye(3);
% C(1:3,4:6)=zeros(3);
% D=zeros(3);
T=0.045;
Ad=eye(6)+As*T;
Bd=Bs*T;
Ld=place(Ad',Cs',[-0.3 -0.5 -0.6 -0.7 -0.4 -0.2]);
q=100*eye(6);
r=eye(3);
Kd1=dlqr(Ad,Bd,q,r); 
%Kd=place(Ad,Bd,[-0.6 -0.5 -0.1 -0.2 -0.3 -0.4]);
x = ones(6,1);
xhat = zeros(6,1);
for k=1:1000
    u(:,k)= -Kd1*x(:,k);
x(:,k+1) =discmodel([u(:,k); x(:,k)]);
xhat(:,k+1)=discObs([u(:,k);xhat(:,k);x(1:3,k)]);
end
plot(x')
figure
plot(xhat')
figure
plot(x'-xhat')
%% Discrete linear model with observer control
B=[0 0 0; 0 0 0; 0 0 0; 25.509032748496242 0 0;0 22.552424969495092 -23.766087136262560; 0 -23.766087136262560  55.348093019453124];
A=[zeros(3),eye(3);zeros(3),[0 0 0;0 0.2142 -0.2258;0 -0.1759 0.4096]];
C=eye(3);
C(1:3,4:6)=zeros(3);
D=zeros(3);
T=0.045;
Ad=eye(6)+A*T;
Bd=B*T;
Ld=place(Ad',C',[-0.3 -0.5 -0.6 -0.7 -0.4 -0.2]);
%Kd=place(Ad,Bd,[-0.6 -0.5 -0.1 -0.2 -0.3 -0.4]);
q=100*eye(6);
r=eye(3);
Kd1=dlqr(Ad,Bd,q,r); 
x = ones(6,1);
xhat = zeros(6,1);
for k=1:4000
    u(:,k)= -Kd1*xhat(:,k);
x(:,k+1) =discmodel([u(:,k); x(:,k)]);
xhat(:,k+1)=discObs([u(:,k);xhat(:,k);x(1:3,k)]);
end
plot(x')
figure
plot(xhat')