function [yd,qdd,lambda,Jac] = FuncEval(t, y)
%Function to evaluate yd as required by the time integration (ode45)

%access the global memory
global NBody Body flag NConstraints NCoord

%transfer positions and velocities to body analysis
[q,qd] = y2q(y);

%Build the mass matrix
[M] = BuildMassMatrix();

%Build Jacobian Matrix and gamma
flag.Position = 1;
flag.Jacobian = 1;
flag.Velocity = 1;
flag.Acceleration = 1;
[Phi,Jac,niu,gamma] = FunctionEval(q,qd,t);

%Redefine gamma for stabilization
alpha = 5;
beta = 5;
Gamma = gamma - 2*alpha *(Jac * qd - niu) - beta^2 * Phi;

%Build the force vector
[g] = BuildForceVector(t);

%Build loading matrix and r.h.s. vector
zeroMat = zeros(NConstraints, NConstraints);
[Mat] = [M Jac'; Jac zeroMat];

b = [g; Gamma];

%Solve the system q linear equations
x = Mat\b;


%Force the accelleration and Lagrange multipliers vecotrs
qdd = x(1:NCoord,1);
lambda = x(NCoord+1:end,1);

%Form vector yd
yd =[qd;qdd];

%Store information for report
%[Body] = qdd2Body(qdd,Body,lambda,NBody);

end
