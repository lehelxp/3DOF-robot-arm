function [ res ] = optimalpd( p,qref,pm,q0 )
kp=p(1);
ki=p(2);
kd=p(3);
ts=0.045;
 k=0.0128;
for i=1:length(qref)
    if i==1
        e(i)=qref(i)-q0;
        u(i)=kp*e(i);
        uc(i)=1000+Torque2PWM(u(i));
        if(abs(uc(i)-1000)<50)
            uc(i)=1000;
        else if (abs(uc(i)-1000)>600)
                if(uc(i)>1000)
                uc(i)=1600;
                else
                uc(i)=400;
                end
            end
        end
        if(uc(i)<1050 && uc(i)>950)
            ui(i)=0;
        elseif (uc(i)<950) 
            ui(i)=-5+k*(uc(i)-950);
        else
            ui(i)=5+k*(uc(i)-1050);
        end
        if(ui(i)>12)
            ui(i)=12;
        elseif ui(i)<-12
            ui(i)=-12;
        end
        x(:,i+1)=motormodel(ui(i),pm,[q0;0]);
    else
        e(i)=qref(i)-x(1,i);
        u(i)=kp*e(i)+ki*sum(e(1:i))+kd*(e(i)-e(i-1))/ts;
         uc(i)=1000+Torque2PWM(u(i));
          if(abs(uc(i)-1000)<50)
            uc(i)=1000;
        else if (abs(uc(i)-1000)>600)
                if(uc(i)>1000)
                uc(i)=1600;
                else
                uc(i)=400;
                end
            end
          end
        if(uc(i)<1050 && uc(i)>950)
            ui(i)=0;
        elseif (uc(i)<950) 
            ui(i)=-5+k*(uc(i)-950);
        else
            ui(i)=5+k*(uc(i)-1050);
        end
        if(ui(i)>12)
            ui(i)=12;
        elseif ui(i)<-12
            ui(i)=-12;
        end
        x(:,i+1)=motormodel(ui(i),[pm],x(:,i));
    end
end
q=x(1,2:end);
res=sum((q-qref).^2)/length(qref);
end

