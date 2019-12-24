function EvaluateDrivers(GaitData)
% This function defines the variation of the degrees of freedom that drive
% the system
% global memory data
global NDriver Body Driver

% Number of frames to evaluate
NFrames = size(GaitData.Coordinates,1);

% Time frame
fs = GaitData.Frequency;
Time = (0 : 1 / fs : (NFrames - 1) / fs)';

for i = 1 : NDriver
    
    % Allocates memory for the dof
    Dof = zeros(NFrames,1);
    
    % Goes through all frames
    for j = 1:NFrames
        switch(Driver(i).type)
            case 1  % type = 1
                % Body to drive
                Bodyi = Driver(i).i;

                % The type 1 driver is a trajectory driver that guides the
                % position or orientation of the body
                if (Driver(i).coordi == 1)      % along X
                    Dof(j) = Body(Bodyi).r(j,1);
                elseif (Driver(i).coordi ==2)   % along Z
                    Dof(j) = Body(Bodyi).r(j,2);
                else                            % along theta
                    Dof(j) = Body(Bodyi).theta(j);
                end
                
            case 3  % type = 1
                % Body i and j
                Bodyi = Driver(i).i;
                Bodyj = Driver(i).j;

                % Updates the dof, according to the definition of the driver
                Dof(j) = pi - Body(Bodyi).theta(j) + Body(Bodyj).theta(j);
        end
        
        % end of the loop that goes through all frames
    end
    
    % Update the results
    Driver(i).Data = [Time, Dof];
    
    % end of the loop that goes through all bodies
end
end