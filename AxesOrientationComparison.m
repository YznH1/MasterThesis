clear
% Use uigetfile to select the CSV files
[healthyFilename, healthyPath] = uigetfile('*.csv', 'Select healthy pelvis reference frame axes CSV File');
[reconstructedFilename, reconstructedPath] = uigetfile('*.csv', 'Select reconstructed pelvis reference frame axes CSV File');

% Check if the user canceled file selection
if isequal(healthyFilename, 0) || isequal(reconstructedFilename, 0)
    disp('File selection canceled.');
    return;
end

% Construct the full file paths
healthyFilePath = fullfile(healthyPath, healthyFilename);
reconstructedFilePath = fullfile(reconstructedPath, reconstructedFilename);

% Import data from the first CSV file
HealthyAxes = readtable(healthyFilePath);
HealthyAxes = table2array(HealthyAxes);
HealthyP3 = HealthyAxes(1:3,2)

% Import data from the second CSV file
ReconstructedAxes = readtable(reconstructedFilePath);
ReconstructedAxes = table2array(ReconstructedAxes)
ReconstructedP3 = ReconstructedAxes(1:3,2)


%%%%
%Use GES for angular difference measurement
%since internal rotation is always +ve we set the function to always be the
%right hip. If the rotation value is positive we know it is going in the
%screw direction of the y axis of the healthy hip coordinate frame
%We cant use the convention as is since they consider the orientation of
%the pelvic axes with the femor axes. Instead we consider a pevlis to
%pelvis axes orientation.

FEAAIE=ges(HealthyAxes(:,1),ReconstructedAxes(:,1),2,0)

%coordinate system center deviation = reconstructed - healthy. ie how
%deviated is the reconstructed reference frame from the healthy, decomposed
%on the axes of the healthy pelvis

% Calculate the difference vector
differenceVector = ReconstructedAxes(1:3,2) - HealthyAxes(1:3,2)

% Project the difference vector onto the axis vectors
xComponent = dot(differenceVector, HealthyAxes(1:3,1))
yComponent = dot(differenceVector, HealthyAxes(4:6,1))
zComponent = dot(differenceVector, HealthyAxes(7:9,1))

%%%%%%%%%%%
figure;
hold on
%Plotting the axes of the global reference frame 
% arrow3([0 0 0], [100 0 0], 'r');
% text(100, 0, 0, 'X Axis', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'Color', 'r', 'FontSize', 10);
% 
% arrow3([0 0 0], [0 100 0], 'g','LineStyle');
% text(0, 100, 0, 'Y Axis', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'Color', 'g', 'FontSize', 10);
% 
% arrow3([0 0 0], [0 0 100], 'b','LineStyle');
% text(0, 0, 100, 'Z Axis', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'Color', 'b', 'FontSize', 10);


% arrow3([HealthyP3(1) HealthyP3(2) HealthyP3(3)], [HealthyP3(1)+HealthyAxes(1,1)*100 HealthyP3(2)+HealthyAxes(2,1)*100 HealthyP3(3)+HealthyAxes(3,1)*100], 'r');
% text(HealthyP3(1)+HealthyAxes(1,1)*100 ,HealthyP3(2)+HealthyAxes(2,1)*100 ,HealthyP3(3)+HealthyAxes(3,1)*100, 'Local Healthy X Axis', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'Color', 'r', 'FontSize', 10);
% 
% arrow3([HealthyP3(1) HealthyP3(2) HealthyP3(3)], [HealthyP3(1)+HealthyAxes(4,1)*100 HealthyP3(2)+HealthyAxes(5,1)*100 HealthyP3(3)+HealthyAxes(6,1)*100], 'g');
% text(HealthyP3(1)+HealthyAxes(4,1)*100 ,HealthyP3(2)+HealthyAxes(5,1)*100 ,HealthyP3(3)+HealthyAxes(6,1)*100, 'Local Healthy Y Axis', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'Color', 'g', 'FontSize', 10);
% 
% arrow3([HealthyP3(1) HealthyP3(2) HealthyP3(3)], [HealthyP3(1)+HealthyAxes(7,1)*100 HealthyP3(2)+HealthyAxes(8,1)*100 HealthyP3(3)+HealthyAxes(9,1)*100], 'b');
% text(HealthyP3(1)+HealthyAxes(7,1)*100 ,HealthyP3(2)+HealthyAxes(8,1)*100 ,HealthyP3(3)+HealthyAxes(9,1)*100, 'Local Healthy Z Axis', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'Color', 'b', 'FontSize', 10);

% Calculate arrow endpoints
arrow1_end = [HealthyP3(1)+HealthyAxes(1,1)*100, HealthyP3(2)+HealthyAxes(2,1)*100, HealthyP3(3)+HealthyAxes(3,1)*100];
arrow2_end = [HealthyP3(1)+HealthyAxes(4,1)*100, HealthyP3(2)+HealthyAxes(5,1)*100, HealthyP3(3)+HealthyAxes(6,1)*100];
arrow3_end = [HealthyP3(1)+HealthyAxes(7,1)*100, HealthyP3(2)+HealthyAxes(8,1)*100, HealthyP3(3)+HealthyAxes(9,1)*100];

% Plot arrows
arrow3([HealthyP3(1) HealthyP3(2) HealthyP3(3)], [arrow1_end(1) arrow1_end(2) arrow1_end(3)], '-r',10,30);
% text(arrow1_end(1), arrow1_end(2), arrow1_end(3), 'Anatomical Healthy X Axis', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'Color', 'r', 'FontSize', 10);

arrow3([HealthyP3(1) HealthyP3(2) HealthyP3(3)], [arrow2_end(1) arrow2_end(2) arrow2_end(3)],'-g',10,30);
% text(arrow2_end(1), arrow2_end(2), arrow2_end(3), 'Anatomical Healthy Y Axis', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'Color', 'g', 'FontSize', 10);

arrow3([HealthyP3(1) HealthyP3(2) HealthyP3(3)], [arrow3_end(1) arrow3_end(2) arrow3_end(3)], '-b',10,30);
% text(arrow3_end(1), arrow3_end(2), arrow3_end(3), 'Anatomical Healthy Z Axis', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'Color', 'b', 'FontSize', 10);


%%%%%%%%%%

% Calculate arrow endpoints for Reconstructed axes
arrow11_end = [ReconstructedP3(1)+ReconstructedAxes(1,1)*100, ReconstructedP3(2)+ReconstructedAxes(2,1)*100, ReconstructedP3(3)+ReconstructedAxes(3,1)*100];
arrow12_end = [ReconstructedP3(1)+ReconstructedAxes(4,1)*100, ReconstructedP3(2)+ReconstructedAxes(5,1)*100, ReconstructedP3(3)+ReconstructedAxes(6,1)*100];
arrow13_end = [ReconstructedP3(1)+ReconstructedAxes(7,1)*100, ReconstructedP3(2)+ReconstructedAxes(8,1)*100, ReconstructedP3(3)+ReconstructedAxes(9,1)*100];


arrow3([ReconstructedP3(1) ReconstructedP3(2) ReconstructedP3(3)], [arrow11_end(1) arrow11_end(2) arrow11_end(3)],'--k',10,30);
% text(arrow1_end(1), arrow1_end(2), arrow1_end(3)*1.2, 'Anatomical Reconstructed X Axis', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'Color', 'k', 'FontSize', 10);

arrow3([ReconstructedP3(1) ReconstructedP3(2) ReconstructedP3(3)], [arrow12_end(1) arrow12_end(2) arrow12_end(3)],'--_y',10,30);
%text(arrow2_end(1), arrow2_end(2), arrow2_end(3)*1.2, 'Anatomical Reconstructed Y Axis', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'Color', 'yellow', 'FontSize', 10);

arrow3([ReconstructedP3(1) ReconstructedP3(2) ReconstructedP3(3)], [arrow13_end(1) arrow13_end(2) arrow13_end(3)],'--m',10,30);
%text(arrow3_end(1), arrow3_end(2), arrow3_end(3)*1.2, 'Anatomical Reconstructed Z Axis', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'Color', 'magenta', 'FontSize', 10);


%plot the recosntructed pelvis .stl
TR = stlread('BARLETTA ANNA MARIA_pelvis left_001.stl');
TRR = stlread('BARLETTA ANNA MARIA_pelvis right bone graft_001.stl');
transparencyIndex1 = 0.5
% Plot the STL model using patch
patch('Faces', TR.ConnectivityList, 'Vertices', TR.Points, 'FaceColor', [0 0.4470 0.7410], 'EdgeColor', 'none','FaceLighting','gouraud','AmbientStrength',0.50, 'SpecularStrength',0.2,'FaceAlpha',0.9);
patch('Faces', TRR.ConnectivityList, 'Vertices', TRR.Points, 'FaceColor', [0.89 0.85 0.79], 'EdgeColor', 'none','FaceLighting','gouraud','AmbientStrength',0.50, 'SpecularStrength',0.2,'FaceAlpha',0.3);
axis equal;
title('Healthy & Reconstructed Pelvises');
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
%%%%%%%%%%

legend('Anatomical Healthy X-axis','','Anatomical Healthy Y-axis','','Anatomical Healthy Z-axis','','Anatomical Reconstructed X-axis','','Anatomical Reconstructed Y-axis','','Anatomical Reconstructed Z-axis')


% Export angular and origin deviation as a CSV file with GUI for file selection
[fileName, filePath] = uiputfile('*.csv', 'Save angular and origin deviation');
if fileName ~= 0
    location = (filePath+"\"+fileName);
    writetable(table([FEAAIE],[xComponent;yComponent;zComponent]), location);
    disp(['File saved successfully: ' fullfile(filePath, fileName)]);
else
    disp('File not saved.');
end