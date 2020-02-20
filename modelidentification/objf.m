function[f]=objf(u,y,d)
x(1:2,1)=0;
Ts=0.045;
for i=1:length(u)
x(:,i+1)=[1 Ts;0 1-d(1)*Ts]*x(:,i)+[0;Ts*d(2)]*u(i);
end
f=(1/length(u))*sum((y(:,1)-x(1,2:end)').^2);