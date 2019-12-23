function PreProcessing( biomechanical_model_file,...
                        biomechanical_model_save_file,...
                        static_file, static_remove_method, static_remove_var, ...
                        motion_file, motion_remove_method, motion_remove_var)
% Pre-processing of data from the Laboratory of Biomechanics of Lisbon
% The PreProcessing function requires:
% - A Biomechanical Model input file from where to read the model
% - A Biomechanical Model output/save file where to store the generated
% model
% - For each static and motion files:
%   - The file name
%   - The method of projection to the sagital plane
%   - The variable (dummy or not) to remove (only useful for method='var')

% Global memory data
global removeVar

if(strcmp(motion_remove_method,'pca'))
    removeVar = 2; % force to X (use as Principal component)
else
    removeVar = motion_remove_var;
end
progress_bar = waitbar(0,'Reading Human Model Input...');

% Reads input data for the biochanical model
ReadModelInput(biomechanical_model_file);

waitbar(0.2, progress_bar, 'Reading and filtering the static data...');
% Reads the static data (remove coordinate 'static_remove': 1-X, 2-Y, 3-Z)
StaticData = ReadProcessData(static_file, static_remove_method, static_remove_var);

waitbar(0.4, progress_bar, 'Computing body lengths from the static data...');
%Compute the average segment lengths
ComputeAverageLengths(StaticData);

%Compute the total body mass from ground reaction forces and update the
%mass and inertia of the bodies
waitbar(0.5, progress_bar, 'Compute body masses and inertia moments...');
ComputeBodyInertialProperties(totalMass);

% Reads data
% Remove coordinate 'motion_remove': 1-X, 2-Y, 3-Z
waitbar(0.6, progress_bar, 'Reading and filtering the Gait data...');
GaitData = ReadProcessData(motion_file, motion_remove_method, motion_remove_var);

% Computes the positions and angles of the body
waitbar(0.8, progress_bar, 'Evaluating positions...');
EvaluatePositions(GaitData);

% Evaluates the driver
waitbar(0.9, progress_bar, 'Evaluating drivers...');
EvaluateDrivers(GaitData);

%Process the ground reaction forces
waitbar(0.95, progress_bar, 'Processing the groun reaction forces...');
ReadGRF(GaitData.Frequency);

% Updates the data in the files to be read by the kinematic analysis
waitbar(1, progress_bar, 'Saving Biomechanical Model...');
WritesModelInput(biomechanical_model_save_file);

close(progress_bar);
end