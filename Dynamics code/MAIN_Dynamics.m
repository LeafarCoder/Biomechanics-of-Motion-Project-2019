% % FILE DESCRIPTION
% In this file all the high-level commands are executed.
% If some other person or biomechanical lab would need to use the Dynamic
% analysis provided by this application, they would only (in theory) need
% to change parameters on this file such as the names of the files with the
% motion to analyze or the file format with which to store the results.
% 
% PRE-PROCESSING
% In the first section, all the give data is filtered and relevant 
% biomechanical parameters are set such as the body lengths and masses.
% Constraints and drivers are also set and stored in .txt files for later use.
% Be aware that the user can select how the recorded model points can be
% projected into a 2D plane: either select a specific variable (1 for X, 2
% for Y and 3 for Z) or allow a PCA estimation of the sagital plane. For
% the former, introduce 'var' as a removal method and then the number of
% the variable to remove. For the latter, give 'pca' as the removal method,
% followed by a dummy removal variable.
% 
% DYNAMIC ANALYSIS
% ...
% ...
% 
% RESULTS VISUALIZATION AND STORAGE
% The following sections allow the user to visualize and store the
% information. An animation of the movement is shown (as Matlab takes some
% time to display each frame, the user can define a specific animation
% rate [dfined in arbitrary units]).
% The function ShowAnimation might take 4 or 5 parameters. The last
% optional parameters is if the user wants to plot the model at different
% time stamps (this is a vector with the normalized (to 1) time at which to
% observe these poses. If this parameter is not given then, the normal
% animation is shown.
% The plots for the positions, velocities and accelerations for each
% individual body can be seen and stored in a user-defined folder.
% 
% WARNINGS
% Please, do no use the 'clear all' command in between sections. It is done
% once at the beggining of the Pre-processing (can be removed if desired)
% but then variables from one section are needed for another section.

%% Pre-process the data from the lab acquisition
clear all;

% choose GAIT (1) or DEADLIFT (2) motion
motion_option = 1;

analysis_names = {'Gait', 'Deadlift'};
analysis_name = analysis_names{motion_option};

cf = pwd;   % Current folder
biomechanical_model_input_files = {[cf, '\HumanBiomechanicalModel_Gait.txt'], [cf, '\HumanBiomechanicalModel_Deadlift.txt']};
biomechanical_model_input_file = biomechanical_model_input_files{motion_option};
biomechanical_model_save_file = [cf, '\BiomechanicalModel.txt'];

static_file = [cf, '\LabData\static.tsv'];
static_remove_var = 2; % remove Y (project onto XZ plane)

motion_files = {[cf, '\LabData\gait.tsv'], [cf, '\LabData\deadlift.tsv']};
motion_file = motion_files{motion_option};
remove_vars = {2, 1};
motion_remove_var = remove_vars{motion_option};

% Trim (or use 'all') the motion to only analyse that section (in seconds)
times_range_of_interest = {"all", [2.70, 7.50]};
time_range_of_interest = times_range_of_interest{motion_option};

% Only the first force file (f1) needs to be uploaded, all others will be
% deduced from the name (for that the file names must be consistent)
force_files = {[cf, '\LabData\gait_f1.tsv'], [cf, '\LabData\deadlift_f1.tsv']};
force_file = force_files{motion_option};

subjectMass = 68;   % Mass of the subject in Kg

PreProcessing(  biomechanical_model_input_file,...
                biomechanical_model_save_file, ...
                static_file, 'var', static_remove_var,...
                ...motion_file, 'pca', 0);
                motion_file, 'var', motion_remove_var,...
                time_range_of_interest, force_file, subjectMass);
            
disp('Preprocessing Complete')
%% Perform Dynamic Analysis
offset = 10;
[q, qd, qdd, F, time] = DynamicAnalysis(biomechanical_model_save_file, offset);
kinematic_vars = {q, qd, qdd, time};
dynamic_vars = {F(1:3:end,:), F(2:3:end,:), F(3:3:end,:), time};


%% Visualize Simulation (stickman)

rate = 5;
show_laterality = true;
show_at = [0.3,0.6,0.9];
close all;
ShowAnimation(q, time, rate, show_laterality);
%ShowAnimation(q, time, rate, show_laterality, show_at);

%% Show Dynamic plots
% show Fx (1), Fy(2) or Momentum(3) for all bodies
var_option = 2;
%Change sign on plots, to analyse the same as literature
dynamic_vars = {F(1:3:end,:), F(2:3:end,:), -F(3:3:end,:), time};
ShowDynamicPlots(dynamic_vars, var_option);

%% Show Kinematic plots
% show POSITIONS (1), VELOCITIES (2) or ACCELERATIONS (3) for all bodies
var_option = 3;
ShowKinematicPlots(kinematic_vars, var_option);


%% Save Dynamic plots and variables on specified path
% jpg, png, fig (allows to reopen in Matlab and analyse more carefully)
% if 'fig' is used then, to reopen the figure use: openfig(file_path,'visible');
%file_extension = 'jpg';
%SaveDynamicAnalysis(dynamic_vars, analysis_name, file_extension);
