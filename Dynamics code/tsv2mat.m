function [fp1, fp2, fp3] = tsv2mat(force_file, varargin)

% Return GRF and CoP for Force Plate 1,2 and 3
% INPUTS:
%   - write_file: 1 to write file with forces, 0 otherwise
%   - name_out: if 'write_file' is 1, then provide name for the file with the results (ex: forces)
% OUPUTS:
%   - fp1, fp2, fp3: the force plate data

% Number of force plates to consider
n_fp = 3;

% Get file path, name and extension
[filepath,name,ext] = fileparts(force_file);
% Get the part that is common among all plate force files
base_name = name(1:end-1);

for i = 1:n_fp
    % Generate full path of current force plate file and open file
    force_file = fullfile(filepath, [base_name, num2str(i), ext]);
    fid = fopen(force_file);
    % Get two first header data: # of samples and sampling frequency
    header_scan = textscan(fid, '%s %f', 2);
    header.value = header_scan{2};
    sampleNum = header.value(1);
    
    % Get remaining headers for definition of force plate positions
    header_scan2 = textscan(fid,'%s %f', 14, 'headerLines',8);
    
    header.value2 = header_scan2{2};
    
    fpdata{i}.XY.x = header.value2(1,1);
    fpdata{i}.XY.y = header.value2(2,1);
    fpdata{i}.XY.z = header.value2(3,1);
    
    fpdata{i}.Xy.x = header.value2(4,1);
    fpdata{i}.Xy.y = header.value2(5,1);
    fpdata{i}.Xy.z = header.value2(6,1);
    
    fpdata{i}.xy.x = header.value2(7,1);
    fpdata{i}.xy.y = header.value2(8,1);
    fpdata{i}.xy.z = header.value2(9,1);
    
    fpdata{i}.xY.x = header.value2(10,1);
    fpdata{i}.xY.x = header.value2(11,1);
    fpdata{i}.xY.x = header.value2(12,1);
    
    fpdata{i}.length_fp = header.value2(13,1);
    fpdata{i}.width_fp = header.value2(14,1);
    
    % Read all the forces and inertial moments
    aux = textscan(fid, ['%d', repmat(' %f', 1, 10)], 'headerLines', 2);
    pontos_aux{i}.sampleNum = aux{1};
    pontos_aux{i}.sampleTime = aux{2};
    pontos_aux{i}.data = cell2mat(aux(3:end));
    
    % Close current .tsv document
    fclose(fid);
end

fp1_f_tr = zeros(sampleNum,9);
fp2_f_tr = zeros(sampleNum,9);
fp3_f_tr = zeros(sampleNum,9);

for i = 1:9
    fp1_f_tr(:,i) = pontos_aux{1,1}.data(:,i);
    fp2_f_tr(:,i) = pontos_aux{1,2}.data(:,i);
    fp3_f_tr(:,i) = pontos_aux{1,3}.data(:,i);   
end

COP1_x(:,1) = fp1_f_tr(:,8) + fpdata{1,1}.xy.x + (fpdata{1,1}.length_fp)/2;
COP1_y(:,1) = fp1_f_tr(:,7) + fpdata{1,1}.xy.y + (fpdata{1,1}.width_fp)/2;
COP1_z(:,1) = fp1_f_tr(:,9) + fpdata{1,1}.xy.z;

COP2_x(:,1) = fp2_f_tr(:,8) + fpdata{1,2}.xy.x + (fpdata{1,2}.length_fp)/2;
COP2_y(:,1) = fp2_f_tr(:,7) + fpdata{1,2}.xy.y + (fpdata{1,2}.width_fp)/2;
COP2_z(:,1) = fp2_f_tr(:,9) + fpdata{1,2}.xy.z;

COP3_x(:,1) = fp3_f_tr(:,8) + fpdata{1,3}.xy.x + (fpdata{1,3}.length_fp)/2;
COP3_y(:,1) = fp3_f_tr(:,7) + fpdata{1,3}.xy.y + (fpdata{1,3}.width_fp)/2;
COP3_z(:,1) = fp3_f_tr(:,9) + fpdata{1,3}.xy.z;



%% Relations

fp1 = zeros(sampleNum,6);
fp2 = zeros(sampleNum,6);
fp3 = zeros(sampleNum,6);


fp1(:,1) = -fp1_f_tr(:,2);
fp1(:,2) = -fp1_f_tr(:,1);
fp1(:,3) = fp1_f_tr(:,3);
fp1(:,4) = COP1_x;
fp1(:,5) = COP1_y;
fp1(:,6) = COP1_z;

fp2(:,1) = -fp2_f_tr(:,2);
fp2(:,2) = -fp2_f_tr(:,1);
fp2(:,3) = fp2_f_tr(:,3);
fp2(:,4) = COP2_x;
fp2(:,5) = COP2_y;
fp2(:,6) = COP2_z;

fp3(:,1) = -fp3_f_tr(:,2);
fp3(:,2) = -fp3_f_tr(:,1);
fp3(:,3) = fp3_f_tr(:,3);
fp3(:,4) = COP3_x;
fp3(:,5) = COP3_y;
fp3(:,6) = COP3_z;

% If file name was provided then save te variables
if(nargin == 2)
    name_out = varargin{1};
    save([forcePathName, name_out, '.mat'], 'fp1', 'fp2', 'fp3');
end

end
