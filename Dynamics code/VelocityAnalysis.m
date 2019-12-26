function qd = VelocityAnalysis(q,time)

% global variables
global flag

% Form the RHS of the velocity equations and Jacobian matrix
flag.Position = 0;
flag.Jacobian = 1;
flag.Velocity = 1;
flag.Acceleration = 0;
[~,Jac,niu,~] = FunctionEval(q,[],time);

% Solve system of equations
qd = Jac\niu;
end
