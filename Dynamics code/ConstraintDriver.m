function [Phi,Jac,niu,gamma,line] = ConstraintDriver(Phi,Jac,niu,gamma,k,time,line)

global Driver Body flag

l1 = line;
l2 = line;

type = Driver(k).type;
i = Driver(k).i;
coordi = Driver(k).coordi;
j = Driver(k).j;

if(type == 1 || type ==3)
    spl = Driver(k).spline;
    spl_d = Driver(k).spline_d;
    spl_dd = Driver(k).spline_dd;
end

switch(type)
    case 1
        if coordi == 1      % X
            Phi(l1:l2) = Body(i).r(1) - ppval(spl, time);
        elseif coordi == 2 % Y
            Phi(l1:l2) = Body(i).r(2) - ppval(spl, time);
        elseif coordi == 3 % Theta
            Phi(l1:l2) = Body(i).theta - ppval(spl, time);
        end
    case 2
        % driver type not used
        
    case 3
        Phi(l1:l2) = pi + Body(j).theta - Body(i).theta - ppval(spl, time);
        
    case 4
        % driver type not used
end

% Jacobian matrix
if(flag.Jacobian == 1)
    c1 = 3 * (i-1) + coordi;
    c2 = c1;
    if(type == 3)
        Jac(l1:l2,c1:c2) = -1;
        c1 = 3 * (j-1) + 3;
        c2 = c1;
        Jac(l1:l2,c1:c2) = 1;
    else
        c1 = 3 * (i-1) + coordi;
        Jac(l1:l2,c1:c1) = 1;
    end
end

% r.h.s of Velocity equations
if(flag.Velocity == 1)
    if(type == 1 || type == 3)
        niu(l1:l2) = ppval(spl_d, time);
    else
        % other driver types (not used)
    end
end

% r.h.s of Acceleration equations
if(flag.Acceleration == 1)
    if(type == 1 || type == 3)
        gamma(l1:l2) = ppval(spl_dd, time);
    else
        % other driver types (not used)
    end
end

% Update line number
line = line + 1;

end