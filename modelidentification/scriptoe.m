load('remelemutolsoid.mat');
nb=1:5;
nf=1:5;
nk=1;
y=0.0174532925.*idu.y(1:end,1);
u=idu.u(1:end,1);
ij=iddata(y,u,0.045);
model=oe(ij,[1 1 1]);
load('idm1.mat')
compare(model,idn1)
%%
y1=0.0174532925.*idu.y(1:end,2);
u1=idu.u(1:end,2);
i2=iddata(y1,u1,0.045);
model2=oe(i2,[1 1 1]);
load('idm2.mat')
figure
compare(model2,idn2)
%%
y2=0.0174532925.*idu.y(1:end,3);
u2=idu.u(1:end,3);
i3=iddata(y2,u2,0.045);
model3=oe(i3,[1 1 1]);
load('idm3.mat')
figure
compare(model3,idn3)