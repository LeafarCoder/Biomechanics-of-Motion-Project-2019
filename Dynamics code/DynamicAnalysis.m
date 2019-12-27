function [q, qd, qdd, Fx, Fy, T, time] = DynamicAnalysis(biomechanical_model_save_file, offset)

% Define global variables
global tstart tstep tend read_progress

%Reads the output of the preprocessing and interpolates the driver and force plate data
read_progress = waitbar(0, 'Reading Biomechanical Model input file...');
[q,qd,qdd] = ReadInput(biomechanical_model_save_file);
close(read_progress);

%Correct the initial conditions and form the initial y vector

[q(:,1),qd(:,1)]=CorrectInitialConditions();
y0=[q(:,1);qd(:,1)];

%Call the matlab time integrator
tspan=tstart:tstep:tend;
[t,y]=ode45(@FuncEval,tspan,y0);

%Report the results

Report(t,y);

end


