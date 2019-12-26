function [Phi,Jac,niu,gamma,line] = ConstraintGround(Phi,Jac,niu,gamma,k,line)
% access global memory
global Jnt_Ground flag Body 

% define local variables
i = Jnt_Ground(k).i;
rP0 = Jnt_Ground(k).rP0;
theta0 = Jnt_Ground(k).theta0;

l1 = line;
l2 = line + 2;

% Position constraint equation
if(flag.Position == 1)
    Phi(l1:l2) = [  Body(i).r - rP0; ...
                    Body(i).theta - theta0];
end
                
% Jacobian Matrix
if(flag.Jacobian == 1)
    c1 = 3*i-2;
    c2 = c1+2;
    Jac(l1:l2,c1,c2) = eye(3);
end

% RHS of velocity equations
if(flag.Velocity == 1)
    niu(l1:l2) = 0;
end

% RHS of acceleration equations
if(flag.Acceleration == 1)
    gamma(l1:l2) = 0;
end

% update line number for next constraint
line = line + 3;

end
