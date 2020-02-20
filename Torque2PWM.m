function PWM = Torque2PWM( tau )
a = 834;
b = 15;
PWM = a*tau + sign(tau)*b;

end


