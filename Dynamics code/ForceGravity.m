function [g] = ForceGravity()

global Body NBody NCoord

% initialize the force vector
g = zeros(NCoord,1);

% include the gravity force for every body
for i = 1:NBody
    i1 = 3*i - 2;
    i2 = i1 + 1;
    grav = [0 ; -9.807];
    g(i1:i2,1) = Body(i).mass * grav;
    
end

end