function [PWM]= writer(tau)
% tau = torque in [-1.18, 1.18] 
% Input u = PWM ratio in [0, 2000], 1000 zero PWM, <1000 counter clockwise,>1000 clockwise
% limits are intrduced u=PWM in [400, 1600]!!!!
global Port

tau1 = tau(1);
tau2 = tau(2);
tau3 = tau(3);
%convert torque into PWM
PWM(1) = Port.PWM_offset + Torque2PWM(tau1);
PWM(2) = Port.PWM_offset + Torque2PWM(tau2);
PWM(3) = Port.PWM_offset + Torque2PWM(tau3);

%saturate the PWM, the range is in abs(PWM-PWM_offset) is between [50 600]
if (abs(PWM(1)-Port.PWM_offset))<50
   PWM(1) = 1000;
else if (abs(PWM(1)-Port.PWM_offset))>600
        if (PWM(1)>1000)
           PWM(1) = 1600;
        else
           PWM(1) = 400;
        end
    end
end

if abs((PWM(2)-Port.PWM_offset))<50
   PWM(2) = 1000;
else 
   if (abs(PWM(2)-Port.PWM_offset))>600
       if (PWM(2)>1000)
           PWM(2) = 1600;
       else
           PWM(2) = 400;
       end
   end
end
if abs((PWM(3)-Port.PWM_offset))<50
   PWM(3) = 1000;
else 
   if (abs(PWM(3)-Port.PWM_offset))>600
       if (PWM(3)>1000)
           PWM(3) = 1600;
       else
           PWM(3) = 400;
       end
   end
end
% write PWM in the command
Port.writePWM(9:10) = GetV(PWM(1));
Port.writePWM(12:13) = GetV(PWM(2));
Port.writePWM(15:16) = GetV(PWM(3));
crcM = mod(sum(bitcmp(Port.writePWM(2:16))),256);
Port.writePWM(17) = crcM;
%send command to the robot arm
PWM=[PWM(1) PWM(2) PWM(3)];
fwrite(Port.s,Port.writePWM); 
end

