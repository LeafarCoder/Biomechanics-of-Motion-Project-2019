function qdd = AccelerationAnalysis(q,qd,time)

% global variables
global flag

% Form the RHS of the acceleration equations and Jacobian matrix
flag.Position = 0;
flag.Jacobian = 1;
flag.Velocity = 0;
flag.Acceleration = 1;
[~,Jac,~,gamma] = FunctionEval(q,qd,time);

% Solve system of equations
qdd = Jac\gamma;
end