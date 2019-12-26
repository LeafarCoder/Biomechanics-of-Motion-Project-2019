function [q, qd, qdd, time] = DynamicAnalysis(biomechanical_model_save_file, offset)

% Define global variables
global tspan

%Reads the output of the preprocessing and interpolates the driver and force plate data
[q,qd,qdd] = ReadInput(biomechanical_model_save_file);

%Correct the initial conditions

[q,qd]=CorrectInitialConditions;

%form the initial y vector
y0=[q,qd];

%Call the matlab time integrator

[t,y]=ode45(@FuncEval,tspan,y0);

%Report the results

Report(t,y);

end


