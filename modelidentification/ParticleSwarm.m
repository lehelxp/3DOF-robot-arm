function [best ,it ] = ParticleSwarm( fun,dim,lim,params,A,B,e,maxit)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

n = params(1);
omega = params(2);
phip = params(3);
phig = params(4);

x = zeros(dim,n);
v = zeros(dim,n);
p = zeros(dim,n);
stop = zeros(1,dim);

fg = inf;

for j = 1:n %% we generate the initial swarm according to the constraints
    
    for i = 1:2:2*dim
        
        x(i/2 + 1/2,j) = lim(i) + (lim(i+1) - lim(i)).*rand;
        v(i/2 + 1/2,j) = -abs(diff(lim(i:i+1))) + 2*abs(diff(lim(i:i+1)))*rand;
        
    end
    
    ok = A*x(:,j) <= B;
    
    while min(ok)==0
        
        for i = 1:2:2*dim
            
            x(i/2 + 1/2,j) = lim(i) + (lim(i+1) - lim(i)).*rand;
            v(i/2 + 1/2,j) = -abs(diff(lim(i:i+1))) + 2*abs(diff(lim(i:i+1)))*rand;
            
        end
        
        ok = A*x(:,j) <= B;
        
    end
    
end

for i = 1:n  %%we initialize actual positions and best swarm pos
    
    fx = fun(x(:,i));
    
    if fx<fg
        
        fg = fx;
        g(:,1) = x(:,i);
        
    end
    
    p(:,i) = x(:,i);
    fp(i,:) = fun(p(:,i));
    
    if fp(i,:)<fg
        g(:,1) = p(:,i);
        fg = fp(i,:);
    end
    
    
end

it = 0;

while min(stop)==0 && it<maxit
    
    it=it+1;
    
    for i = 1:n
        
        for d = 1:dim
            
            rp = rand;
            rg = rand;
            
            v(d,i) = omega*v(d,i) + phip*rp*(p(d,i) - x(d,i)) + phig*rg*(g(d) - x(d,i));
            
        end
        
        ok = A*(x(:,i) + v(:,i)) <= B;
        
        while (x(d,i) + v(d,i)) < lim(2*d-1) || (x(d,i) + v(d,i)) > lim(2*d) || min(ok)==0
            
            for d = 1:dim
                
                rp = rand;
                rg = rand;
                
                v(d,i) = omega*v(d,i) + phip*rp*(p(d,i) - x(d,i)) + phig*rg*(g(d) - x(d,i));
                
            end
            
            ok = A*(x(:,i) + v(:,i)) <= B;

        end
        
        x(:,i) = x(:,i) + v(:,i);
        
        
        fx = fun(x(:,i));
        
        flag = 0;
        
        if fx < fp(i,:)
            
            flag = 1;
            
            p(:,i) = x(:,i);
            fp(i,:) = fx;
            
            if fp(i) < fg
                
                g(:,it) = p(:,i);
                fg = fp(i,:);
                
            else
                
                g(:,it) = g(:,end);
                
            end
            
        end
        
        if flag == 0
            
            g(:,it) = g(:,end);
            
        end
        
    end
    
    for i = 1:dim
        
        sigma = std(g(i,:),1);
        stop(i) = sigma < e*(max(g(i,:)) - min(g(i,:)));
        
    end
    
end

best = g(:,end);

end

