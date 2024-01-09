clear
% Select first IGES file using GUI For healthy hip center of rotation
[filename_iges1, path_iges1] = uigetfile('*.igs', 'Select IGES File For healthy hip center of rotation');
if isequal(filename_iges1, 0)
    disp('User canceled IGES file selection. Exiting...');
    return;
end

% Select second IGES file using GUI For reconstructed hip center of rotation
[filename_iges2, path_iges2] = uigetfile('*.igs', 'Select IGES File For reconstructed hip center of rotation');
if isequal(filename_iges2, 0)
    disp('User canceled IGES file selection. Exiting...');
    return;
end

% Select third IGES file using GUI For healthy side great trochanter
[filename_iges3, path_iges3] = uigetfile('*.igs', 'Select IGES File For healthy side great trochanter');
if isequal(filename_iges3, 0)
    disp('User canceled IGES file selection. Exiting...');
    return;
end

% Select fourth IGES file using GUI For reconstructed side great trochanter
[filename_iges4, path_iges4] = uigetfile('*.igs', 'Select IGES File For reconstructed side great trochanter');
if isequal(filename_iges4, 0)
    disp('User canceled IGES file selection. Exiting...');
    return;
end



% Use uigetfile to select the CSV files of Healthy Pelvis Axes
[Filename, Path] = uigetfile('*.csv', 'Select Healthy Pelvis Axes');

% Construct the full file paths
FilePath = fullfile(Path, Filename);

% Import data from the first CSV file
HealthyAxes = readtable(FilePath);
HealthyAxes = table2array(HealthyAxes)

% Extract individual vectors
x = HealthyAxes(1:3, 1);
y = HealthyAxes(4:6, 1);
z = HealthyAxes(7:9, 1);

% Check orthogonality
dot_xy = dot(x, y);
dot_xz = dot(x, z);
dot_yz = dot(y, z);

% Display the results
disp(['Dot product (x, y): ', num2str(dot_xy)]);
disp(['Dot product (x, z): ', num2str(dot_xz)]);
disp(['Dot product (y, z): ', num2str(dot_yz)]);

% Use uigetfile to select the CSV files Healthy Pelvis Anatomical Landmarks
[Filename2, Path2] = uigetfile('*.csv', 'Select Healthy Pelvis Anatomical Landmarks');

% Construct the full file paths
FilePath2 = fullfile(Path2, Filename2);

% Import data from the first CSV file
HealthyPelvisLandmarks = readtable(FilePath2);
HealthyPelvisLandmarks = table2array(HealthyPelvisLandmarks)

% Import first IGES data
[ParameterData, ~, ~, ~] = iges2matlab(fullfile(path_iges1, filename_iges1));

% Import second IGES data
[ParameterData2, ~, ~, ~] = iges2matlab(fullfile(path_iges2, filename_iges2));

% Import third IGES data
[ParameterData3, ~, ~, ~] = iges2matlab(fullfile(path_iges3, filename_iges3));

% Import fourth IGES data
[ParameterData4, ~, ~, ~] = iges2matlab(fullfile(path_iges4, filename_iges4));



% Extract point data from the IGES files
HealthyHipCenter = [ParameterData{1}.x; ParameterData{1}.y; ParameterData{1}.z]
ReconstructedHipCenter = [ParameterData2{1}.x; ParameterData2{1}.y; ParameterData2{1}.z]
HealthyGreatTrochanter = [ParameterData3{1}.x; ParameterData3{1}.y; ParameterData3{1}.z]
ReconstructedGreatTrochanter = [ParameterData4{1}.x; ParameterData4{1}.y; ParameterData4{1}.z]

%%%%%%%%%%%%%%


% find COR from local origin
HealthyHipCenterFromP5 =  HealthyHipCenter  - HealthyAxes(1:3,2) 
ReconstructedHipCenterFromP5 =  ReconstructedHipCenter - HealthyAxes(1:3,2) 
HealthyGreatTrochanterFromP5 = HealthyGreatTrochanter - HealthyAxes(1:3,2)
ReconstructedGreatTrochanterFromP5 = ReconstructedGreatTrochanter - HealthyAxes(1:3,2)

% Project the difference vector from global reference frame onto the local
% reference frame

HealthyHipCenterLocally(1) = dot(HealthyAxes(1:3,1),HealthyHipCenterFromP5)
HealthyHipCenterLocally(2) = dot(HealthyAxes(4:6,1),HealthyHipCenterFromP5)
HealthyHipCenterLocally(3) = dot(HealthyAxes(7:9,1),HealthyHipCenterFromP5)


ReconstructedHipCenterLocally(1) = dot(ReconstructedHipCenterFromP5, HealthyAxes(1:3,1));
ReconstructedHipCenterLocally(2) = dot(ReconstructedHipCenterFromP5, HealthyAxes(4:6,1));
ReconstructedHipCenterLocally(3) = dot(ReconstructedHipCenterFromP5, HealthyAxes(7:9,1));

HealthyGreatTrochanterLocally(1) = dot(HealthyGreatTrochanterFromP5, HealthyAxes(1:3,1));
HealthyGreatTrochanterLocally(2) = dot(HealthyGreatTrochanterFromP5, HealthyAxes(4:6,1));
HealthyGreatTrochanterLocally(3) = dot(HealthyGreatTrochanterFromP5, HealthyAxes(7:9,1));

ReconstructedGreatTrochanterLocally(1) = dot(ReconstructedGreatTrochanterFromP5, HealthyAxes(1:3,1));
ReconstructedGreatTrochanterLocally(2) = dot(ReconstructedGreatTrochanterFromP5, HealthyAxes(4:6,1));
ReconstructedGreatTrochanterLocally(3) = dot(ReconstructedGreatTrochanterFromP5, HealthyAxes(7:9,1));



%%%%%%%%%%%%%%

% Calculate absolute differences

% Check if signs are the same
signsSame1 = sign(HealthyHipCenterLocally) == sign(HealthyGreatTrochanterLocally);

% Check if all signs are the same
if all(signsSame1)
    % Calculate absolute differences only when signs are the same
    HealthySideGreatTrochanterOffset = abs(HealthyHipCenterLocally - HealthyGreatTrochanterLocally);
    
    % Display the result
    disp('Absolute Differences of healthy trochanter offset (when signs are the same):');
    disp(HealthySideGreatTrochanterOffset);
else
    % Display an alert if signs are not the same for any pair
    disp('Alert: Signs are not the same for some pairs.');
end

% Check if signs are the same
signsSame2 = sign(ReconstructedHipCenterLocally) == sign(ReconstructedGreatTrochanterLocally);

% Check if all signs are the same
if all(signsSame2)
    % Calculate absolute differences only when signs are the same
    ReconstructedSideGreatTrochanterOffset = abs(ReconstructedHipCenterLocally - ReconstructedGreatTrochanterLocally);
    
    % Display the result
    disp('Absolute Differences of reconstructed trochanter offset (when signs are the same):');
    disp(ReconstructedSideGreatTrochanterOffset);
else
    % Display an alert if signs are not the same for any pair
    disp('Alert: Signs are not the same for some pairs.');
end



%%%%%%%%%%%%%%

% Plotting the points
figure;

% Plotting healthy great trochanter 
scatter3(HealthyGreatTrochanter(1), HealthyGreatTrochanter(2), HealthyGreatTrochanter(3), 'bo', 'DisplayName', 'Healthy Great Trochanter','LineWidth', 1.2);
hold on
% Plotting reconstrcuted great trochanter 
scatter3(ReconstructedGreatTrochanter(1), ReconstructedGreatTrochanter(2), ReconstructedGreatTrochanter(3), 'ro', 'DisplayName', 'Reconstructed Great Trochanter','LineWidth', 1.2);


% Plot Healthy Hip Center
scatter3(HealthyHipCenter(1), HealthyHipCenter(2), HealthyHipCenter(3), 'bo', 'DisplayName', 'Healthy Hip Center','LineWidth', 1.2);

% Plot Reconstructed Hip Center
scatter3(ReconstructedHipCenter(1), ReconstructedHipCenter(2), ReconstructedHipCenter(3), 'ro', 'DisplayName', 'Reconstructed Hip Center','LineWidth', 1.2);

plot3(HealthyPelvisLandmarks(1,1),HealthyPelvisLandmarks(2,1),HealthyPelvisLandmarks(3,1),'x','LineWidth', 1.2);
hold on
plot3(HealthyPelvisLandmarks(1,2),HealthyPelvisLandmarks(2,2),HealthyPelvisLandmarks(3,2),'o','LineWidth', 1.2);
plot3(HealthyPelvisLandmarks(1,3),HealthyPelvisLandmarks(2,3),HealthyPelvisLandmarks(3,3),'+','LineWidth', 1.2,'MarkerSize', 12);
plot3(HealthyPelvisLandmarks(1,4),HealthyPelvisLandmarks(2,4),HealthyPelvisLandmarks(3,4),'*','LineWidth', 1.2);
plot3(HealthyPelvisLandmarks(1,5),HealthyPelvisLandmarks(2,5),HealthyPelvisLandmarks(3,5),'square','LineWidth', 1.2);

% Plotting vector directions
%quiver3(HealthyAxes(1,2), HealthyAxes(2,2), HealthyAxes(3,2), HealthyHipCenterFromP5(1), HealthyHipCenterFromP5(2), HealthyHipCenterFromP5(3), 'r', 'LineWidth', 2, 'MaxHeadSize', 0.5, 'DisplayName', 'Healthy Hip Center');

%quiver3(HealthyAxes(1,2), HealthyAxes(2,2), HealthyAxes(3,2), ReconstructedHipCenterFromP5(1), ReconstructedHipCenterFromP5(2), ReconstructedHipCenterFromP5(3), 'b', 'LineWidth', 2, 'MaxHeadSize', 0.5, 'DisplayName', 'Reconstructed Hip Center');

% Plotting vector directions
%quiver3(HealthyAxes(1,2), HealthyAxes(2,2), HealthyAxes(3,2), HealthyGreatTrochanterFromP5(1), HealthyGreatTrochanterFromP5(2), HealthyGreatTrochanterFromP5(3), 'r', 'LineWidth', 2, 'MaxHeadSize', 0.5, 'DisplayName', 'Healthy Great Trochanter');

%quiver3(HealthyAxes(1,2), HealthyAxes(2,2), HealthyAxes(3,2), ReconstructedGreatTrochanterFromP5(1), ReconstructedGreatTrochanterFromP5(2), ReconstructedGreatTrochanterFromP5(3), 'b', 'LineWidth', 2, 'MaxHeadSize', 0.5, 'DisplayName', 'Reconstrcuted Great Trochanter');

% Plotting vector directions in HealthyAxes
quiver3(HealthyAxes(1,2), HealthyAxes(2,2), HealthyAxes(3,2), HealthyAxes(1,1)*100, HealthyAxes(2,1)*100, HealthyAxes(3,1)*100, 'r', 'LineWidth', 2, 'MaxHeadSize', 0.5, 'DisplayName', 'Vector in HealthyAxes');
text(HealthyAxes(1,1)*100+HealthyAxes(1,2), HealthyAxes(2,1)*100+HealthyAxes(2,2), HealthyAxes(3,1)*100+HealthyAxes(3,2), 'Anatomical Healthy X Axis', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'Color', 'r', 'FontSize', 10);
quiver3(HealthyAxes(1,2), HealthyAxes(2,2), HealthyAxes(3,2), HealthyAxes(4,1)*100, HealthyAxes(5,1)*100, HealthyAxes(6,1)*100, 'b', 'LineWidth', 2, 'MaxHeadSize', 0.5, 'DisplayName', 'Vector in HealthyAxes');
text(HealthyAxes(4,1)*100+HealthyAxes(1,2), HealthyAxes(5,1)*100+HealthyAxes(2,2), HealthyAxes(6,1)*100+HealthyAxes(3,2), 'Anatomical Healthy Y Axis', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'Color', 'b', 'FontSize', 10);
quiver3(HealthyAxes(1,2), HealthyAxes(2,2), HealthyAxes(3,2), HealthyAxes(7,1)*100, HealthyAxes(8,1)*100, HealthyAxes(9,1)*100, 'g', 'LineWidth', 2, 'MaxHeadSize', 0.5, 'DisplayName', 'Vector in HealthyAxes');
text(HealthyAxes(7,1)*100+HealthyAxes(1,2), HealthyAxes(8,1)*100+HealthyAxes(2,2), HealthyAxes(9,1)*100+HealthyAxes(3,2)+12, 'Anatomical Healthy Z Axis', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'Color', 'g', 'FontSize', 10);

%quiver3(0, 0, 0, ReconstructedHipCenter(1), ReconstructedHipCenter(2), ReconstructedHipCenter(3), 'b', 'LineWidth', 2, 'MaxHeadSize', 1.5, 'DisplayName', 'Reconstructed Axes');
%quiver3(0, 0, 0, HealthyHipCenter(1), HealthyHipCenter(2), HealthyHipCenter(3), 'b', 'LineWidth', 2, 'MaxHeadSize', 1.5, 'DisplayName', 'Reconstructed Axes');

% quiver3(0, 0, 0, 100, 0, 0, 'r', 'LineWidth', 2, 'MaxHeadSize', 0.5, 'DisplayName', 'Healthy Axes');
% text(100, 0, 0, 'X Axis', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'Color', 'r', 'FontSize', 10);
% quiver3(0, 0, 0, 0, 0, 100, 'g', 'LineWidth', 2, 'MaxHeadSize', 0.5, 'DisplayName', 'Healthy Axes');
% text(0, 0, 100, 'Z Axis', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'Color', 'g', 'FontSize', 10);
% quiver3(0, 0, 0, 0, 100, 0, 'b', 'LineWidth', 2, 'MaxHeadSize', 0.5, 'DisplayName', 'Healthy Axes');
% text(0, 100, 0, 'Y Axis', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'Color', 'b', 'FontSize', 10);


%plot the recosntructed pelvis .stl
% TR = stlread('C:\Users\Yazan\OneDrive\Desktop\MEng project\3DP-Prosthesis-Reconsrtucion\Giambartolomei Agnese\GIAMBARTOLOMEI AGNESE_implant femur_001.stl');
% TRR = stlread('C:\Users\Yazan\OneDrive\Desktop\MEng project\3DP-Prosthesis-Reconsrtucion\Giambartolomei Agnese\GIAMBARTOLOMEI AGNESE_femur right_001.stl');
% TRRR = stlread('BARLETTA ANNA MARIA_pelvis left_001.stl');
% TRRRR = stlread('BARLETTA ANNA MARIA_femur left_001.stl');
% TRRRRR = stlread('BARLETTA ANNA MARIA_implant pelvis right_001.stl');
% TRRRRRR = stlread('BARLETTA ANNA MARIA_femur right_001.stl');
transparencyIndex1 = 0.5
% Plot the STL model using patch
% patch('Faces', TR.ConnectivityList, 'Vertices', TR.Points, 'FaceColor', [0.89 0.85 0.79], 'EdgeColor', 'none','FaceLighting','gouraud','AmbientStrength',0.50, 'SpecularStrength',0.2,'FaceAlpha',0.2);
% patch('Faces', TRR.ConnectivityList, 'Vertices', TRR.Points, 'FaceColor', [0 0.4470 0.7410], 'EdgeColor', 'none','FaceLighting','gouraud','AmbientStrength',0.50, 'SpecularStrength',0.2,'FaceAlpha',transparencyIndex1);
% patch('Faces', TRRR.ConnectivityList, 'Vertices', TRRR.Points, 'FaceColor', [0.89 0.85 0.79], 'EdgeColor', 'none','FaceLighting','gouraud','AmbientStrength',0.50, 'SpecularStrength',0.2,'FaceAlpha',0.2);
% patch('Faces', TRRRR.ConnectivityList, 'Vertices', TRRRR.Points, 'FaceColor', [0.89 0.85 0.79], 'EdgeColor', 'none','FaceLighting','gouraud','AmbientStrength',0.50, 'SpecularStrength',0.2,'FaceAlpha',transparencyIndex1);
% patch('Faces', TRRRRR.ConnectivityList, 'Vertices', TRRRRR.Points, 'FaceColor', [0.89 0.85 0.79], 'EdgeColor', 'none','FaceLighting','gouraud','AmbientStrength',0.50, 'SpecularStrength',0.2,'FaceAlpha',0.2);
% patch('Faces', TRRRRRR.ConnectivityList, 'Vertices', TRRRRRR.Points, 'FaceColor', [0.89 0.85 0.79], 'EdgeColor', 'none','FaceLighting','gouraud','AmbientStrength',0.50, 'SpecularStrength',0.2,'FaceAlpha',0.2);
axis equal;
title('Reconstructed Pelvis');
light('Position', [0 1 0]);
light('Position', [0 -1 0]);
axis on;
box on;
grid on;
rotate3d on; 
xlabel('x (Right/Left)');
ylabel('y (Ant/Pos)');
zlabel('z (Pro/Dis)');
xlim([-500 500]);
ylim([-500 500]);
zlim([-500 500]);
view(16,10);
% global graph properties
set(gcf,'Color','w');

legend('Healthy Great Trochanter','Reconstructed Side Great Tochanter','Healthy Hip Center','Reconstructed Hip Center','P1','P2','P3','P4','P5')

% Export angular and origin deviation as a CSV file with GUI for file selection
[fileName, filePath] = uiputfile('*.csv', 'Save offset parameters of healthy and reconstructed trochanters');
if fileName ~= 0
    location = (filePath+"\"+fileName);
    writetable(table([HealthySideGreatTrochanterOffset],[ReconstructedSideGreatTrochanterOffset]), location);
    disp(['File saved successfully: ' fullfile(filePath, fileName)]);
else
    disp('File not saved.');
end

%%%%%%%%%%%


