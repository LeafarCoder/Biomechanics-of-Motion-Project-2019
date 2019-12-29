function ShowDynamicPlots(vars, option)

global Body JntRevolute NRevolute removeVar

% remove 'offset' frames from the beggining and end of the plots.
offset = 0;

var = vars{option};
varNames = {'X Force', 'Y Force', 'torque'};
varName = varNames{option};
units = {'N', 'N', 'Nm'};
unit = units{option};
time = vars{4};
time = time(offset+1:end-offset);

n = ceil(sqrt(NRevolute));
t = linspace(time(1), time(end), size(var,2));

if(removeVar == 1)
    list = {'F_x', 'F_y', 'Torque'};
else
    list = {'F_x', 'F_z', 'Torque'};
end

t_coord = list{option};
figure('Name', ['Displaying ',varName]);

for k = 1:NRevolute
    subplot(n,n,k);
    plot(t,var(k,:));
    title([Body(JntRevolute(k).i).Name, ' <> ', Body(JntRevolute(k).j).Name]);
    xlabel('Time (s)');
    ylabel([t_coord, '(', unit, ')']);
end

end

