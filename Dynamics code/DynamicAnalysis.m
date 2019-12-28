function [q, qd, qdd, Fx, Fz, T, t] = DynamicAnalysis(biomechanical_model_save_file, offset)

% Define global variables
global tstart tstep tend read_progress NCoord

%Reads the output of the preprocessing and interpolates the driver and force plate data
read_progress = waitbar(0, 'Reading Biomechanical Model input file...');
[q,qd,qdd] = ReadInput(biomechanical_model_save_file);
close(read_progress);

%Correct the initial conditions and form the initial y vector

[q(:,1),qd(:,1)] = CorrectInitialConditions();
y0 = [q(:,1);qd(:,1)];

%Call the matlab time integrator
disp('ode45 running')
tspan = tstart:tstep:tend;
[t,y] = ode45(@FuncEval,tspan,y0);
t=t';
disp('ode45 Complete')

%Translate y into working variables
q = y(:,1:NCoord)';
qd = y(:,NCoord+1:end)';

%Calculating lambdas for everytime step
lambda = zeros(size(q,1), size(q,2));
Jac = zeros(size(q,1), size(q,1), size(q,2));

for i = 1:length(t)
    [~, qdd(:,i) , lambda(:,i), Jac(:,:,i)] = FuncEval(t(i), y(i,:)');
end

%Calculating internal forces Fx, Fz, T 
% Apply black magic ????????



%Temporary Bullshit
Fx=0;
Fz=0;
T=0;

end


