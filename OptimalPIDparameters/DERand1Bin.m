function [out,q] = DERand1Bin(f,dim,range,A,B,NP,F,CR,e,it)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

stop = zeros(1,dim);

x = [];

x = zeros(NP,dim);

for j = 1:NP  %% we generate the initial population according to the constraints

    for i = 1:2:2*dim
        
        x(j,i/2 + 1/2) = range(i) + (range(i+1) - range(i)).*rand;
    
    end
    
    if min(A*x(j,:)' <= B) == 0
        
        for i = 1:2:2*dim
        
            x(j,i/2 + 1/2) = range(i) + (range(i+1) - range(i)).*rand;
    
        end
        
    end
    
end

best = inf;

fx = NaN(1,NP);
q = 0;

for k = 1:NP
    fx(:,k) = f(x(k,:));%
    
    if fx(:,k) < best
        best = fx(:,k);
        bestx = x(k,:)';
    end
    
end

while min(stop)==0 && q <it
    q = q+1;
    
    for k = 1:NP
        
        flag = 0;
        
        while 1
            
            a = randi([1 NP],1,1);
            while a==k
                a = randi([1 NP],1,1);
            end
            
            b = randi([1 NP],1,1);
            while b==k || b==a
                b = randi([1 NP],1,1);
            end
            
            c = randi([1 NP],1,1);
            while c==k || c==a || c==b
                c = randi([1 NP],1,1);
            end
            
            R = randi([1 dim],1,1);
            
            y = zeros(1,dim);
            
            for i = 1:dim
                
                r = rand;
                
                if r<CR || i == R
                    
                    y(1,i) = x(a,i) + F*(x(b,i) - x(c,i));
                    
                    
                    if y(1,i) < range(2*i - 1) || y(1,i) > range(2*i)
                        flag = 1;
                    end
                    
                else
                    
                    y(1,i) = x(k,i);
                    
                end
                
            end
            
            if min(A*y(1,:)' <= B) == 0
                
                flag = 1;
                
            end
            
            if flag==0
                break
            end
            
            flag = 0;
              
        end
        
        fy = f(y);
        
        if fy < best
            
            best = fy;
            bestx(:,q) = y';
          
        else
            bestx(:,q) = bestx(:,end);
        end
        if(q<=100)
        %plot(q,best,'*r')
        % hold on
        end
        if fy < fx(:,k)
            
            x(k,:) = y;
            fx(:,k) = fy;
            
        end
        
    end
    
    for i = 1:dim
        
        sigma = std(bestx(i,:),1);
        stop(i) = sigma < e*(max(bestx(i,:)) - min(bestx(i,:)));
        
    end
    
end

out = bestx(:,end);

end

