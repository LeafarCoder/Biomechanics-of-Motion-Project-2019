function [q,qd] = y2q(y)

%access the global memory
global NBody Body NCoord

% Create vectors q and qd
q = y(1:NCoord,1);
qd = y(NCoord+1:end,1);

% Update the body information
for i = 1:NBody
    i1 = 3*i-2;
    i2 = i1+1;
    i3 = i2+1;
    Body(i).r = q(i1:i2,1);
    Body(i).theta = q(i3,1);
    Body(i).rd = qd(i1:i2,1);
    Body(i).thetad = qd(i3,1);
end

end