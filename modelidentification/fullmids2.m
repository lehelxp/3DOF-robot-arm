clc
clear all
load('idRad_torque.mat')
e = 1e-35;
maxit = 500;   
NP=20;
CR=0.6938;
F=0.9314;
A=[0,0,0];
B=[0];
K0=[0 1 0 1 0 1];
f2=@(K)fullm2(K,idtr.u,idtr.y);
for i=1:1
    i
    [min3(:,i), it3(i)] = DERand1Bin(f2,3,K0,A,B,NP,F,CR,e,maxit);
end