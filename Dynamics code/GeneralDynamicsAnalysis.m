clear all

%Have a global memory available

global tspan

%Read and pre-process data
ReadInputData();

%Correct the initial conditions

[q,qd]=CorrectInitialConditions;

%form the initial y vector
y0=[q,qd];

%Call the matlab time integrator

[t,y]=ode45(@FuncEval,tspan,y0);

%Report the results

Report(t,y);



