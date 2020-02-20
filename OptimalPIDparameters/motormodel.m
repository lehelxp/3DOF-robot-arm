function[xt]=motormodel(u,d,x0)
Ts=0.045;
xt=[1 Ts;0 1-d(1)*Ts]*x0+[0;Ts*d(2)]*u;
end
