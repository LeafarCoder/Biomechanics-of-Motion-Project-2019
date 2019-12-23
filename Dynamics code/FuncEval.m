%Function to evaluate yd as required by the time integration (ode45)

function[yd]=FuncEval(t,y)

%access the global memory

global

%transfer positions and velocities to body analysis

[Body,q,qd]=y2q(y,Body,NBodies);


%Build the mass matrix

[M]=BuildMassMatrix(Body,NBodies);


%Build Jacobian Matrix and gamma

[~,Jac,~,gamma]=Kinem_FuncEval(q,qd,time);


%Build the force vector

[g]=BuildForceVector();


%Build loading matrix and r.h.s. vector

Null=zeros(NConstraints,NConstraints);
[Mat]=[M Jac';...
    Jac Null];

b=[g;gamma];


%Solve the system q linear equations

x=Mat\b;


%Force the accelleration and Lagrange multipliers vecotrs

qdd=x(1:NCoordinates,1);
lambda=x(NCoordinates+1:end,1);


%Form vector yd
yd=[qd;qdd];


%Store information for report
[Body]=qdd2Body(qdd,Body,lambda,NBody);

end
