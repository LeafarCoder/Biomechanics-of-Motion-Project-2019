function [q,qd] = CorrectInitialConditions()

%global memory assignment
global NBody Body tstart

%setup the initial conditions for kinematic analysis

time = tstart;

for i = 1:NBody
    i1 = 3*i-2;
    i2 = i1+1;
    i3 = i2+1;
    q(i1:i2,1) = Body(i).r;
    q(i3,1) = Body(i).theta;
end

%Perform the position analysis
q = PositionAnalysis(q,time);

%Perform the velocity analysis
qd = VelocityAnalysis(q,time);

%Transfer data to working arrays
for i = 1:NBody
    i1 = 3*i-2;
    i2 = i1+1;
    i3 = i2+1;
    Body(i).r = q(i1:i2,1);
    Body(i).theta = q(i3,1);
    Body(i).rd = qd(i1:i2,1);
    Body(i).thetad = qd(i3,1);
end

end
