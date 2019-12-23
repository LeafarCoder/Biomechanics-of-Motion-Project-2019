% Return GRF and CoP for Force Plate 1,2 and 3
% [fp1,fp2,fp3]=tsv2mat(write_file,name_out,plot_f)
%write_file 1 - write file with forces
%name_out - name for the file with the results (ex: forces)
%plot_f 1 - plot forces and COP for debug;

function [fp1,fp2,fp3]=tsv2mat(write_file,name_out,plot_f)

n_fp=3;


[ForceFileName, ForcePathName] = uigetfile({'*.tsv'}, 'Load force data file 1');

name_ori=ForceFileName(1:end-5);

for i=1:n_fp
    force_file=[ForcePathName,name_ori,num2str(i),'.tsv'];    
    
    fid = fopen(force_file);
    header_scan = textscan(fid, '%s %f', 2);
    header.label = header_scan{1};
    header.value = header_scan{2};
    
%     if i==1,
%         disp('Number of frames of analysis');
%         header.value(1)
%         disp('Frequency of aquisition');
%         header.value(2)
%     end
    
    fclose(fid);
    
    
    fid = fopen(force_file);
    header_scan2 = textscan(fid,'%s %f','headerLines',9);
    fclose(fid);
    
    header.label2 = header_scan2{1};
    header.value2 = header_scan2{2};
    
    
    fpdata{i}.XY.x=header.value2(1,1);
    fpdata{i}.XY.y=header.value2(2,1);
    fpdata{i}.XY.z=header.value2(3,1);
    
    fpdata{i}.Xy.x=header.value2(4,1);
    fpdata{i}.Xy.y=header.value2(5,1);
    fpdata{i}.Xy.z=header.value2(6,1);
    
    fpdata{i}.xy.x=header.value2(7,1);
    fpdata{i}.xy.y=header.value2(8,1);
    fpdata{i}.xy.z=header.value2(9,1);
    
    fpdata{i}.xY.x=header.value2(10,1);
    fpdata{i}.xY.x=header.value2(11,1);
    fpdata{i}.xY.x=header.value2(12,1);
    
    fpdata{i}.length_fp=header.value2(13,1);
    fpdata{i}.width_fp=header.value2(14,1);
    
    
    clear vec_aux
    
    vec_aux=[];
    
    for j=1:11
        vec_aux=[vec_aux,'%f '];
    end
    
    fid = fopen(force_file);
    pontos_aux{i} = textscan(fid,vec_aux,'headerLines', 24);
    fclose(fid);
    
end

fp1_f_tr=zeros(header.value(1),9);
fp2_f_tr=zeros(header.value(1),9);
fp3_f_tr=zeros(header.value(1),9);

for i=1:9
    fp1_f_tr(:,i)=pontos_aux{1,1}{:,i+2};
    fp2_f_tr(:,i)=pontos_aux{1,2}{:,i+2};
    fp3_f_tr(:,i)=pontos_aux{1,3}{:,i+2};   
end

COP1_x(:,1)=fp1_f_tr(:,8)+fpdata{1,1}.xy.x+(fpdata{1,1}.length_fp)/2;
COP1_y(:,1)=fp1_f_tr(:,7)+fpdata{1,1}.xy.y+(fpdata{1,1}.width_fp)/2;
COP1_z(:,1)=fp1_f_tr(:,9)+fpdata{1,1}.xy.z;

COP2_x(:,1)=fp2_f_tr(:,8)+fpdata{1,2}.xy.x+(fpdata{1,2}.length_fp)/2;
COP2_y(:,1)=fp2_f_tr(:,7)+fpdata{1,2}.xy.y+(fpdata{1,2}.width_fp)/2;
COP2_z(:,1)=fp2_f_tr(:,9)+fpdata{1,2}.xy.z;

COP3_x(:,1)=fp3_f_tr(:,8)+fpdata{1,3}.xy.x+(fpdata{1,3}.length_fp)/2;
COP3_y(:,1)=fp3_f_tr(:,7)+fpdata{1,3}.xy.y+(fpdata{1,3}.width_fp)/2;
COP3_z(:,1)=fp3_f_tr(:,9)+fpdata{1,3}.xy.z;



%% Relations

fp1=zeros(header.value(1),6);
fp2=zeros(header.value(1),6);
fp3=zeros(header.value(1),6);


fp1(:,1)=-fp1_f_tr(:,2);
fp1(:,2)=-fp1_f_tr(:,1);
fp1(:,3)=fp1_f_tr(:,3);
fp1(:,4)=COP1_x;
fp1(:,5)=COP1_y;
fp1(:,6)=COP1_z;

fp2(:,1)=-fp2_f_tr(:,2);
fp2(:,2)=-fp2_f_tr(:,1);
fp2(:,3)=fp2_f_tr(:,3);
fp2(:,4)=COP2_x;
fp2(:,5)=COP2_y;
fp2(:,6)=COP2_z;

fp3(:,1)=-fp3_f_tr(:,2);
fp3(:,2)=-fp3_f_tr(:,1);
fp3(:,3)=fp3_f_tr(:,3);
fp3(:,4)=COP3_x;
fp3(:,5)=COP3_y;
fp3(:,6)=COP3_z;

if write_file==1,
    save([ForcePathName,name_out,'.mat'],'fp1','fp2','fp3');
end

end
