function ShowKinematicPlots(vars, option)

global Body NBody removeVar

% remove 'offset' frames from the beggining and end of the plots.
offset = 0;

var = vars{option};
varNames = {'position', 'velocity', 'acceleration'};
varName = varNames{option};
units = {'m', 'm', 'rad'};
time = vars{4};
time = time(offset+1:end-offset);

if(option == 2)
    units = strcat(units, '/s');
elseif(option == 3)
    units = strcat(units, '/s^2');
end

n = ceil(sqrt(NBody));
t = linspace(time(1), time(end), size(var,2));

if(removeVar == 1)
    list = {'X', 'Y', 'Theta'};
else
    list = {'X', 'Z', 'Theta'};
end
for coord = 1:3     % X=1, Y=2, Theta=3
    t_coord = list{coord};
    figure('Name', ['Displaying ',varName,' for coordinate ',t_coord])
    for i=1:NBody
        subplot(n,n,i);
        c = (i-1)*3 + coord;
        plot(t,var(c,:));
        title([Body(floor((c-1)/3)+1).Name]);
        xlabel('Time (s)');
        ylabel([t_coord, '(', units{coord}, ')']);
    end
end
end

