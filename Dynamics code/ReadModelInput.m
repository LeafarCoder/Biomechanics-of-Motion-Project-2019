function ReadModelInput(ModelName)
%Function to read an input file (written as txt)
%for the biomechanical system to be studied


% Global memory assignment
global NBody NRevolute NGround NDriver NConstraints NCoordinates
global JntRevolute Body Ground Driver

% Read the input file
file = fopen(ModelName, 'r');

%store the general dimensions of system
t_line = fgetl(file);
H = sscanf(t_line, "%i");
NBody = H(1,1);
NRevolute = H(1,2);
NGround = H(1,3);
NDriver = H(1,4);
NPoint = H(1,5);
NSpringDamper = H(1,6);

NConstraints = 2*NRevolute + 3*NGround + NDriver;
NCoordinates = 3*NBody;

%store data for the rigid body information
for i=1:NBody
    t_line = fgetl(file);
    H = sscanf(t_line, "%i %f %f %i %i %f");
    Body(i).massPerc = H(2);
    Body(i).inertia = H(3);
    Body(i).r = H(4:5)';
    Body(i).theta = H(6);
    Body(i).rd = H(7:8)';
    Body(i).thetad = H(9);
end


%store the data for the revolute joints information
for k=1:NRevolute
    line=line+1;
    JntRevolute(k).i=H(line,2);
    JntRevolute(k).j=H(line,3);
    JntRevolute(k).sPpi=H(line,4:5)';
    JntRevolute(k).sPpj=H(line,6:7)';
end

    


