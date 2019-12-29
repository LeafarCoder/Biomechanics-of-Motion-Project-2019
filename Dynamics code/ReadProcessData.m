function LabData = ReadProcessData(fileName, remove_method, remove_var, varargin)
% removeVar = 1[X], 2[Y], 3[Z]

% READ FILE
H = dlmread(fileName,'\t',11,0);

t = H(:,2);
samples_of_interest = 1:length(t);

% Sampling frequency
fs = 1/(t(2)-t(1));
LabData.Frequency = fs;

if(nargin > 3)  % if 'time_range_of_interest' is given
    % define the range of time to use
    time_range_of_interest = varargin{1};
    if(~ strcmp(time_range_of_interest, "all"))
        start = time_range_of_interest(1);
        final = time_range_of_interest(2);
        samples_of_interest = 1 + round((start*fs):(final*fs));
    end
end

% Picks all the X,Y,Z coordinates from all bodies
Coordinates = H(samples_of_interest, 3:end);

% If user chose to select the sagital plane by PCA method
if(strcmp(remove_method, 'pca'))
    X = Coordinates(:,1:3:end);
    Y = Coordinates(:,2:3:end);
    Z = Coordinates(:,3:3:end);
    % calculate the path of the centroid (body's centroid for each frame)
    X_centr = mean(X,2);
    Y_centr = mean(Y,2);
    Z_centr = mean(Z,2);
    centroid_path = [X_centr(:),Y_centr(:),Z_centr(:)];
    % Calculate Principal Components
    coefs = pca(centroid_path(:,1:2));
    
    % Rotate coordinates to align with principal components
    pcaCoordinates = zeros(size(Coordinates));
    for coord = 1:(size(pcaCoordinates,2)/3)
        % The coordinate to mantain is the principal component
        pcaCoordinates(:, 2*coord - 1) = Coordinates(:,(1:2) + 3*(coord-1)) * coefs(:,1);
        % Z is the height and so is mantained the same
        pcaCoordinates(:, 2*coord) = Coordinates(:, 3*coord);
        
        % The coordinate to mantain is the principal component
        %pcaCoordinates(:, 3*(coord-1)+(1:2)) = Coordinates(:,(1:2) + 3*(coord-1)) * coefs;
        % Z is the height and so is mantained the same
        %pcaCoordinates(:, 3*coord) = Coordinates(:, 3*coord);
    end
    
    Coordinates = pcaCoordinates;
    % If user chose to select the sagital plane by specific variable removal
elseif(strcmp(remove_method, 'var'))
    % Eliminates the coordinates to project the data onto the sagital plane
    Coordinates(:, remove_var:3:end) = [];
end

%% Filters the data
NCoord = size(Coordinates, 2);

FilteredCoordinates = zeros(size(Coordinates));

for i = 1:NCoord
    FilteredCoordinates(:,i) = ResidualAnalysis(Coordinates(:,i), LabData.Frequency);
end

% Organizes the data according to the defenition of the biomechanical model
% Notice that the coordinates from the lab are organized as follows
% 1 - Head, %2 - L_Shoulder, %3 - L_Elbow, %4 - L_Wrist, %5 - R_Shoulder,
% 6 - R_Elbow, %7 - R_Wrist, %8 - L_Hip, %9 - L_Knee, %10 - L_Ankle,
% 11 - L_Heel, %12 - L_Meta_V, %13 - L_Toe_II, %14 - R_Hip, %15 - R_Knee
% 16 - R_Ankle, %17 - R_Heel, %18 - R_Meta_V, %19 - R_Toe_II

LabData.Coordinates = [
    FilteredCoordinates(:,1:2),... %Head
    (FilteredCoordinates(:,3:4) + FilteredCoordinates(:,9:10)) / 2, ... %Midpoint between shoulders
    FilteredCoordinates(:,11:12),... % Right elbow
    FilteredCoordinates(:,13:14),... % Right wrist
    FilteredCoordinates(:,5:6),... % Left elbow
    FilteredCoordinates(:,7:8),... % Left wrist
    (FilteredCoordinates(:,15:16) + FilteredCoordinates(:,27:28)) / 2, ... %Midpoint between hips
    FilteredCoordinates(:,29:30),... % Right knee
    FilteredCoordinates(:,31:32),... % Right ankle
    FilteredCoordinates(:,35:36),... % Right metatarsal
    FilteredCoordinates(:,37:38),... % Right toe
    FilteredCoordinates(:,17:18),... % Left Knee
    FilteredCoordinates(:,19:20),... % Left ankle
    FilteredCoordinates(:,23:24),... % Left metatarsal
    FilteredCoordinates(:,25:26)] * 1e-3; % Left toe
end