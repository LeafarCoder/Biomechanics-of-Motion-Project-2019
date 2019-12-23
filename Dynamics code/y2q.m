function [Body,q,qd] = y2q(y,Body,NBodies)

% Create vectors q and qd
q = y(1:NCoordinates,1);
qd = y(NCoordinates+1:end,1);

% Update the body information
for i = 1:NBodies
    i1 = 3*i-2;
    i2 = i1+1;
    i3 = i2+1;
    Body(i).r = q(i1:i2,1);
    Body(i).theta = q(i3,1);
    Body(i).rd = qd(i1:i2,1);
    Body(i).thetad = qd(i3,1);
end

end