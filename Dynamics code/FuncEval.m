function [yd] = FuncEval(t, y)
%Function to evaluate yd as required by the time integration (ode45)

%access the global memory
global NBody Body

%transfer positions and velocities to body analysis
[q,qd] = y2q(y);

%Build the mass matrix
[M] = BuildMassMatrix();

%Build Jacobian Matrix and gamma
[~,Jac,~,gamma] = Kinem_FuncEval(q,qd,time);

%Build the force vector
[g]=BuildForceVector();

%Build loading matrix and r.h.s. vector
zeroMat = zeros(NConstraints, NConstraints);
[Mat]=[M Jac'; Jac zeroMat];

b=[g;gamma];

%Solve the system q linear equations
x = Mat\b;


%Force the accelleration and Lagrange multipliers vecotrs
qdd=x(1:NCoordinates,1);
lambda=x(NCoordinates+1:end,1);

%Form vector yd
yd=[qd;qdd];

%Store information for report
[Body] = qdd2Body(qdd,Body,lambda,NBody);

end
