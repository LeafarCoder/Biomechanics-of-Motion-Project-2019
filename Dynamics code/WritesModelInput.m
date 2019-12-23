function WritesModelInput(ModelName)
%this function writes the updated data for the biomechanical model

global NBody NRevolute NGround NDriver NFplates Body JntRevolute JntGround JntDriver FPlate

%open file
fid = fopen(ModelName, 'w');

%store the general dimensions of the system
fprintf(fid,'%d %d %d %d %d\r\n', NBody, NRevolute, NGround, NDriver, NFplates);

%stores the data for the rigid body information
for i=1:NBody
    fprintf(fid, '%d %f %f %f %f %f 0.0 0.0 0.0\r\n', i, Body(i).mass,...
        Body(i).inertia, Body(i).r(1,1), Body(i).r(2,1),...
        Body(i).theta(1));
end

%stores the data regarding the force plates
for k=1:NFplates
    
    %Bodies i and j
    i = FPlate(k).i;
    j = FPlate(k).j;
    
    fprintf(fid, '%d %d %d %f %f %f %f %d\r\n0',k,i,j,...
        FPlate(k).spi(1)*Body(i).Length,FPlate(k).spi(2)*Body(i).Length,...
        FPlate(k).spj(1)*Body(i).Length,FPlate(k).spj(2)*Body(i).Length,...
        FPlate(k).filename);
    
    %writes the data to the files
    dlmwrite(['FPlates_',num2str(FPlate(k).filename),'.txt'],...
        FPlate(k).Data,'delimiter',' ','precision',16,'newline','pc');
end
end