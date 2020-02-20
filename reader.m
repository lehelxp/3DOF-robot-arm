function [data] = reader

global Port

fwrite(Port.s,Port.CycleRead);
data1 = fread(Port.s,7);
data2 = fread(Port.s,7);
data3=  fread(Port.s,7);
%convert angles into radian format
% the data is obtained at the 5th and 6th byte of the line, so we have to
% extract this:
% angle = (data(5)*256 + data(6)-offset)*resolution
res=0.29;
zero=145.00;
    if(~isempty(data1)) %Make sure Data Type is Correct       
    %data(:,1) = [(data1(5)*256 + data1(6)-Port.offsetang1)*Port.resang       
         %   (data2(5)*256 + data2(6)-Port.offsetang2)*Port.resang 
          % (data3(5)*256 + data3(6)-Port.offsetang3)*Port.resang] ; %Extract 1st Data Element 
       data=[((data1(5)*256 + data1(6))*res)-zero
                  ((data2(5)*256 + data2(6))*res)-zero
                  ((data3(5)*256 + data3(6))*res)-zero];% current positions expressed in angles
%data=[data1 data2 data3];
    end
end