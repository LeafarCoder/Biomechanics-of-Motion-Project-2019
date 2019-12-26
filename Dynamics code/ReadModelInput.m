function ReadModelInput(ModelName)
%Function to read an input file (written as txt)
%for the biomechanical system to be studied


% Global memory assignment
global NBody NRevolute NGround NDriver NFPlate NConstraints NCoordinates
global JntRevolute Body Ground Driver FPlate


% Read the input file
file = fopen(ModelName, 'r');

% Store the general dimensions of system
t_line = fgetl(file);
H = sscanf(t_line, "%i");
NBody = H(1);
NRevolute = H(2);
NGround = H(3);
NDriver = H(4);
NFPlate = H(5);

NConstraints = 2*NRevolute + 3*NGround + NDriver;
NCoordinates = 3*NBody;

% Store data for the rigid body information
for i=1:NBody
    t_line = fgetl(file);
    H = sscanf(t_line, "%i %f %f %i %i %f");
    Body(i).massPerc = H(2);
    Body(i).rg = H(3);
    Body(i).pi = H(4);
    Body(i).pj = H(5);
    Body(i).PCoM = H(6);
    Body(i).Name = char(sscanf(t_line, "%*i %*f %*f %*i %*i %*f %s"))';
end

% Store the data for the revolute joints information
for k=1:NRevolute
    t_line = fgetl(file);
    H = sscanf(t_line, "%i %i %i %f %f %f %f");
    JntRevolute(k).i = H(2);
    JntRevolute(k).j = H(3);
    JntRevolute(k).spi = H(4:5)';
    JntRevolute(k).spj = H(6:7)';
end

% Stores the data for the ground joints
for k = 1:NGround
    t_line = fgetl(file);
    H = sscanf(t_line, "%i %f %f %f");
    Ground(k).i = H(1);
    Ground(k).rP0 = H(2:3);
    Ground(k).theta0 = H(4);
    to be developed further
end

% Stores the data for the driver joints
for k = 1:NDriver
    t_line = fgetl(file);
    H = sscanf(t_line, "%i %i %i %i %i %i %i");
    Driver(k).type = H(2);
    Driver(k).i = H(3);
    Driver(k).coordi = H(4);
    Driver(k).j = H(5);
    Driver(k).coordj = H(6);
    Driver(k).filename = H(7);
end

% Store the data for the force plates
for k = 1:NFPlate
    t_line = fgetl(file);
    H = sscanf(t_line, "%i %i %i %f %f %f %f %i");
    FPlate(k).i = H(2);
    FPlate(k).j = H(3);
    FPlate(k).spi = H(4:5)';
    FPlate(k).spj = H(6:7)';
    FPlate(k).filename = H(8);
end

end
