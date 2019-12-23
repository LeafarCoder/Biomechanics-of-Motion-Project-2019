%Pre-processing of data from the Laboratory of Biomechanics of Lisbon

%Reads input data from the biomechanical model
ReadDraftInput('DraftBiomechanicalModel.txt'); %UPDATE

%Reads the static data
StaticData = ReadProcessData('sta0001_static.tsv');

%Compute the average segment lengths
ComputeAverageLengths(StaticData);

%Compute the total body mass from ground reaction forces and update the
%mass and inertia of the bodies
ComputeBodyProperties(); % NEW

%Reads the gait data
GaitData = ReadProcessData('sta0001_PD1.tsv');

%Computes the positions and angles of the body
EvaluatePositions(GaitData);

%Evaluates the drivers 
EvaluateDrivers(GaitData);

%Process the ground reaction forces
ReadGRF(GaitData.Frequency); %NEW

%Updates the data in the files to be read by the analysis
WritesModelInput('BiomechanicalModel.txt');

