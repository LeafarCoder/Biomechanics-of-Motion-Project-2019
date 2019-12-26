function [Phi,Jac,niu,gamma,line] = ConstraintRevolute(Phi,Jac,niu,gamma,k,line)
% access global memory
global JntRevolute flag Body 

% define local variables
i = JntRevolute(k).i;
j = JntRevolute(k).j;
spPi = JntRevolute(k).spi;
spPj = JntRevolute(k).spj;
l1 = line;
l2 = line + 1;

% Position constraint equation
if(flag.Position == 1)
    Phi(l1:l2) = Body(i).r + Body(i).A * spPi - (Body(j).r + Body(j).A * spPj);
end

% Jacobian Matrix
if(flag.Jacobian == 1)
    JacRev_i = [eye(2), Body(i).B*spPi];
    JacRev_j = [-eye(2), -Body(j).B*spPj];
    c1 = 3*i-2; c2 = c1+2;
    c3 = 3*j-2; c4 = c3+2;
    Jac(l1:l2,c1:c2) = JacRev_i;
    Jac(l1:l2,c3:c4) = JacRev_j;
end

% RHS of velocity equations
if(flag.Velocity == 1)
    niu(l1:l2) = 0;
end

% RHS of acceleration equations
if(flag.Acceleration == 1)
    gamma(l1:l2) = Body(i).A*spPi*Body(i).thetad^2 - ...
                     Body(j).A*spPj*Body(j).thetad^2;
end

% update line number for next constraint
line = line + 2;

end
