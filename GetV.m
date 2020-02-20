function [ cmd ] = GetV( v )
rv=mod(v,256);
cmd(1)=uint8(rv);
rb=floor(v/256);
cmd(2)=uint8(rb);
end

