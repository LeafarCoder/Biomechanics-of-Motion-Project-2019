function WritesModelInput(ModelName)

global NBody NRevolute NGround NDriver NFPlates removeVar
global Body JntRevolute Ground Driver FPlate

%Open file
fid = fopen(ModelName, 'w');

%Store the general dimensions of the system
fprintf(fid, '%i %i %i %i %i\r\n', NBody, NRevolute, NGround, NDriver, NFPlates);

%Stores the data for the rigid body information
for i = 1:NBody
    fprintf(fid, '%i %f %f %f %f %f %f %f %s\r\n', i,...
        Body(i).mass, Body(i).rg, ...
        Body(i).r(1,1), Body(i).r(1,2), Body(i).theta(1),...
        Body(i).Length, Body(i).PCoM, Body(i).Name);
end

%Stores the data for the revolute joints
for k = 1:NRevolute
    % Bodies i and j
    i = JntRevolute(k).i;
    j = JntRevolute(k).j;
    
    fprintf(fid, '%i %i %i %f %f %f %f\r\n', k, i, j,...
        JntRevolute(k).spi(1) * Body(i).Length,...
        JntRevolute(k).spi(2) * Body(i).Length,...
        JntRevolute(k).spj(1) * Body(j).Length,...
        JntRevolute(k).spj(2) * Body(j).Length);
end

%Stores the data for the ground joints
for k = 1:NGround
    fprintf(fid, '%i %i %f %f %f\r\n', k, Ground(k).i,...
        Ground(k).rP0(1), Ground(k).rP0(2), Ground(k).theta0);
    % To be developed further ...
end

%Stores the data for the driver joints
for k = 1:NDriver
    fprintf(fid, '%i %i %i %i %i %i %i\r\n', k, ...
        Driver(k).type, ... % type: 1, 2, 3 or 4
        Driver(k).i, Driver(k).coordi, Driver(k).j, ...
        Driver(k).coordj, Driver(k).filename);
    
    %Writes the driving data to the files
    file = ['Driver_', num2str(Driver(k).filename),'.txt'];
    dlmwrite(file, Driver(k).Data, 'delimiter', '\t', 'newline', 'pc');
end

%Stores the data regarding the force plates
for k = 1:NFPlates
    
    %Bodies i and j
    i = FPlate(k).i;
    j = FPlate(k).j;
    
    fprintf(fid, '%i %i %i %f %f %f %f %i\r\n',k,i,j,...
        FPlate(k).spi(1)*Body(i).Length, FPlate(k).spi(2)*Body(i).Length,...
        FPlate(k).spj(1)*Body(i).Length, FPlate(k).spj(2)*Body(i).Length,...
        FPlate(k).filename);
    
    %writes the data to the files
    file = ['FPlates_',num2str(FPlate(k).filename),'.txt'];
    dlmwrite(file, FPlate(k).Data, 'delimiter', ' ', 'precision', 16, 'newline', 'pc');
end

%Writes the time information
fprintf(fid, '%f %f %f\r\n',...
    Driver(1).Data(1,1),...
    Driver(1).Data(2,1) - Driver(1).Data(1,1),...
    Driver(1).Data(end,1));

% Which variable was removed (X, Y or Z)
fprintf(fid, '%i\r\n', removeVar);

%Close the file
fclose(fid);
fclose('all');
end

