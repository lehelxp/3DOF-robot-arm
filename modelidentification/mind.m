clear all
load('idm1.mat')
load('idm2.mat')
load('idm3.mat')
i1=1;j1=1;
f=@(K)objf(idn2.u,idn2.y,K);
f1=@(K)objf(idn3.u,idn3.y,K);
f2=@(K)objf(idn1.u,idn1.y,K);
for i=11:0.1:15
   for j=0:0.1:2.5
   a(i1,j1)=objf(idn3.u,idn3.y,[i j]);
   j1=j1+1;
   end
   i1=i1+1;
   j1=1;
end
% [D1,D2]=meshgrid([11:0.1:15],[0:0.1:2.5]);
% mesh(D1,D2,a');
% hold on 
% plot3(min4(1,1),min4(2,1),f1(min4),'r*');
% title('Third joint MSE evolution')
% xlabel('c1');
% ylabel('c2');
% zlabel('MSE');
%objf(idn,Ts,[1.2888 0.673])
n = 156;
omega = 0.4091;
phip = 2.1304;
phig = 1.0575;
NP = 24;
F = 0.8905;
CR = 0.2515;
e = 1e-20;
maxit = 2000;   
A = [0,0];
B = [0];
K0=[5 15 0 2];
for i = 1:2
i
%[min1(:,i), it1(i)] = ParticleSwarm(f,2,K0,[n,omega,phip,phig],A,B,e,maxit);
[min2(:,i), it2(i)] = DERand1Bin(f,2,K0,A,B,NP,F,CR,e,maxit);
%[min3(:,i), it3(i)] = ParticleSwarm(f1,2,K0,[n,omega,phip,phig],A,B,e,maxit);
[min4(:,i), it4(i)] = DERand1Bin(f1,2,K0,A,B,NP,F,CR,e,maxit);
[min5(:,i), it5(i)] = DERand1Bin(f2,2,K0,A,B,NP,F,CR,e,maxit);

end