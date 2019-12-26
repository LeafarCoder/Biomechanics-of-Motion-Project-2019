function [Phi,Jac,niu,gamma] = FunctionEval(q,qd,time)

% global variables
global flag Body NConstraints NCoord NRevolute NGround NDriver NBody

% Initialize Phi,Jac,niu and gamma
Phi = zeros(NConstraints,1);
Jac = zeros(NConstraints,NCoord);
niu = zeros(NConstraints,1);
gamma = zeros(NConstraints,1);

% Transfer data to working variables
for i = 1:NBody
    i1 = 3*i-2;
    i2 = i1+1;
    i3 = i2+1;
    Body(i).r = q(i1:i2,1);
    Body(i).theta = q(i3,1);
    ctheta = cos(Body(i).theta);
    stheta = sin(Body(i).theta);
    Body(i).A = [ctheta -stheta;
                 stheta ctheta];
    Body(i).B = [-stheta -ctheta;
                 ctheta -stheta];
             
    if(flag.Acceleration == 1)
        Body(i).rd = qd(i1:i2,1);
        Body(i).thetad = qd(i3,1);
    end
end

line = 1;
% For each Revolute Joint
for k = 1:NRevolute
    [Phi,Jac,niu,gamma,line] = ConstraintRevolute(Phi,Jac,niu,gamma,k,line);
end
    
% For each Ground Joint
for k = 1:NGround
    [Phi,Jac,niu,gamma,line] = ConstraintGround(Phi,Jac,niu,gamma,k,line);
end

% For each Driver
for k = 1:NDriver
    [Phi,Jac,niu,gamma,line] = ConstraintDriver(Phi,Jac,niu,gamma,k,time,line);
end

end