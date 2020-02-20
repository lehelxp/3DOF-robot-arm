clear all
clc
load('m3.mat')
c1=10.6519;
c2=1.1047;
c3=10.7616;
c4=0.9208;
c5=14.8125;
c6=2;
Ts=0.045;
NP = 10 ;
F = 1.1922;
CR = 0.4862;
e = 1e-25;
maxit = 700;   
A = [0,0,0];
B = [0];
K0=[0 0.08 0 0.0045 0 0.00035];
q0=[0];
qref=0.0174532925.*q1f(1,:);
qref2=0.0174532925.*q1f(2,:);
qref3=0.0174532925.*q1f(3,:);
f=@(K)optimalpd(K,qref,[c1;c2],q0);
f2=@(K)optimalpd(K,qref2,[c3;c4],q0);
f3=@(K)optimalpd(K,qref3,[c5;c6],q0);
for i = 1:1
    
i
[min2(:,i), it2(i)] = DERand1Bin(f,3,K0,A,B,NP,F,CR,e,maxit);
%figure

[min3(:,i), it3(i)] = DERand1Bin(f2,3,K0,A,B,NP,F,CR,e,maxit);
%figure
[min4(:,i), it4(i)] = DERand1Bin(f3,3,K0,A,B,NP,F,CR,e,maxit);
end