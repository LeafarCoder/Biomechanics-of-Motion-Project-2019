function [g] = ForceGravity()

global Body NBodies grav NCoordinates

% initialize the force vector
g = zeros(NCoordinates,1);

% include the gravity force for every body
for i=1:NBodies
    i1 = 3*i - 2;
    i2 = i1 + 1;
    g(i1:i2,1) = Body(i).mass * grav;
end
end