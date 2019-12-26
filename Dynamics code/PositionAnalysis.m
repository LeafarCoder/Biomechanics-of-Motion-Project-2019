function q = PositionAnalysis(q,time)

% global variables
global flag

% Define initial error
flag.Position = 0;
flag.Jacobian = 0;
flag.Velocity = 0;
flag.Acceleration = 0;

tol = 1e-10;
maxIter = 12;

error = 10*tol;
i = 0;

% Start the Newton-Raphson iterations

while(error > tol)
    i = i + 1;
    flag.Position = 1;
    flag.Jacobian = 1;
    flag.Velocity = 0;
    flag.Acceleration = 0;
    [Phi,Jac,~,~] = FunctionEval(q,[],time);
    
    % Calculate correction step
    delta_q = Jac\Phi;

    % Evaluate updates positions and error
    q = q - delta_q;
    %ShowAnimation(q);
    error = max(abs(delta_q));
    
    % To avoid infinite iterations (no convergence)
    if(i > maxIter)
        %disp(['Position iter #: ', num2str(i)]);
        break;
    end
end
%disp(['Position iter #: ', num2str(i)]);
end