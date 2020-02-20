global m1 m2 m3 l1 l2 l3 
m1=0.110;
m2=0.160;
m3=0.175;
l1=0.04;
l2=0.118;
l3=0.085+0.087;
load('idRad_torque.mat')
Ts=0.045;
n = 63;
omega = 0.6571;
phip = 1.6319;
phig = 0.6239;
NP = 18;
F = 0.5026;
CR = 0.6714;
e = 1e-35;
maxit = 250;   
A = [0,0,0,0,0,0,0,0];
B = [0];
K0=[0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1];
f=@(K)fullm(K,idtr.u,idtr.y);

for i = 1:1
i
%[min1(:,i), it1(i)] = ParticleSwarm(f,11,K0,[n,omega,phip,phig],A,B,e,maxit);
figure
[min2(:,i), it2(i)] = DERand1Bin(f,8,K0,A,B,NP,F,CR,e,maxit);

end