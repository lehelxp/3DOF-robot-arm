function [vs]=fullm2(p,u,y)
m1=0.110;
m2=0.160;
m3=0.175;
l1=0.04;
l2=0.118;
l3=0.085+0.087;
Ts=0.045;
x=zeros(6,length(y));
I1x=0;
I1y=0;
I2x=0;
I2y=0.042;
I2z=0;
I3x=0.015;
I3y=0.018;
I3z=0;
b1=p(1);
b2=p(2);
b3=p(3);
g=10;q2=0;q3=0;q1d=0;q2d=0;q3d=0;
M=[I1x+I1y+I2x*cos(q2)^2+I2y*sin(q2)^2+I2z+I3x*cos(q2+q3)^2+I3y*sin(q2+q3)^2+I3z+m3*l2*cos(q2)^2+m3*l2*l3*cos(q2)*cos(q2+q3) 0 0;0 I2x+I2y+I3x+I3y+m3*l2^2+m3*l2*l3*cos(q3) I3x+I3y+1/2*m3*l2*l3*cos(q3); 0 I3x+I3y+1/2*m3*l2*l3*cos(q3) I3x+I3y];
B=[(I2y-I2x)*sin(q2)*cos(q2)+(I3y-I3x)*sin(q2+q3)*cos(q2+q3)-m3*l2^2*sin(q2)*cos(q2)-1/2*m3*l2*l3*sin(2*q2+q3) (I3y-I3x)*sin(q2+q3)*cos(q2+q3)-1/2*m3*l2*l3*cos(q2)*sin(q2+q3) 0;0 0 -1/2*m2*l2*l3*sin(q3); 0 0 0];
C=[0 0 0;(I2x-I2y)*sin(q2)*cos(q2)+(I3x-I3y)*sin(q2+q3)*cos(q2+q3)+m3*l2^2*sin(q2)*cos(q2)+1/2*m3*l2*l3*sin(2*q2+q3) 0 -1/2*m2*l2*l3*sin(q3); (I3x-I3y)*sin(q2+q3)*cos(q2+q3)+1/2*m2*l2*l3*cos(q2)*sin(q2+q3) 1/2*m3*l2*l3*sin(q3) 0];
G=[0;(1/2*m2+m3)*g*l2*cos(q2)+1/2*m3*g*l3*cos(q2+q3);1/2*m3*g*l3*cos(q2+q3)];
im=inv(M);
for i=1:length(y)
if i==1
    qdd=im*(-2*B*[q1d*q2d;q1d*q3d;q2d*q3d]-C*[q1d^2; q2d^2; q3d^2]+G+u(i,:)'+[b1 0 0;0 b2 0;0 0 b3]*[q1d;q2d;q3d]);
    xd=[zeros(3,1);qdd];
else
    q1d=qdd(1)*Ts+q1d;
    q2d=qdd(2)*Ts+q2d;
    q3d=qdd(3)*Ts+q3d;
   qdd=im*(-2*B*[q1d*q2d;q1d*q3d;q2d*q3d]-C*[q1d^2; q2d^2; q3d^2]+G+u(i,:)'+[b1 0 0;0 b2 0;0 0 b3]*[q1d;q2d;q3d]);
xd(:,i)=[q1d;q2d;q3d;qdd];
x(1,i)=x(1,i)+xd(1,i-1)*Ts;
x(2,i)=x(2,i)+xd(2,i-1)*Ts;
x(3,i)=x(3,i)+xd(3,i-1)*Ts;
x(4:6,i)=xd(1:3,i);
end
end
v(1)=sum((y(:,1)-x(1,1:end)').^2);
v(2)=sum((y(:,2)-x(2,1:end)').^2);
v(3)=sum((y(:,3)-x(3,1:end)').^2);
vs=sum(v);