clear
% Select first IGES file using GUI
[filename_iges1, path_iges1] = uigetfile('*.igs', 'Select IGES File For Sacral Symmetry Plane');
if isequal(filename_iges1, 0)
    disp('User canceled IGES file selection. Exiting...');
    return;
end

% Import first IGES data
[ParameterData, ~, ~, ~] = iges2matlab(fullfile(path_iges1, filename_iges1));

% Select second IGES file for "point" using GUI
[filename_iges2, path_iges2] = uigetfile('*.igs', 'Select  IGES File For Mirroring Point');
if isequal(filename_iges2, 0)
    disp('User canceled IGES file selection for point. Exiting...');
    return;
end

% Import second IGES data
[ParameterData2, ~, ~, ~] = iges2matlab(fullfile(path_iges2, filename_iges2));




% Extract point data from the second IGES file. Note: during the import process, the points are
% reversed. That is why HP3side = ParameterData2{1}...

HP3side = [ParameterData2{1}.x; ParameterData2{1}.y; ParameterData2{1}.z];
HP1 = [ParameterData2{2}.x; ParameterData2{2}.y; ParameterData2{2}.z];

% Allocate cooridnates of each anatomical landmark on the sacrum 

S1 = [ParameterData{1}.x; ParameterData{1}.y; ParameterData{1}.z];
S2 = [ParameterData{2}.x; ParameterData{2}.y; ParameterData{2}.z];
S3 = [ParameterData{3}.x; ParameterData{3}.y; ParameterData{3}.z];



% Calculate the normal vector of the sacral plane
normalVector1 = cross(S2 - S3, S1 - S3);
normalVector1 = normalVector1 / norm(normalVector1);
    
%midpoint of s1 and s2
midS12 = (S1+S2)/2;

%Creation of S4. A pont in the mirror plane but not in the sacral plane. ie
%not along the points of intersection of the two planes.

S4 = midS12 + normalVector1*10;

%Creation of the normal vector to the mirror plane

normalVector2 = cross(S4 - S3, midS12 - S3);
normalVector2 = normalVector2 / norm(normalVector2);

% Calculate the vector from the MidS12 to the respective anatomical
% landmarks to be mirrored

vectorToHP1 = midS12 - HP1;
vectorToMidsides3 = midS12 - HP3side;


% Calculate the mirrored point using the reflection formula
HP2 = HP1 + 2 * dot(vectorToHP1, normalVector2) * normalVector2;
HP3side2 = HP3side + 2 * dot(vectorToMidsides3, normalVector2) * normalVector2;


HP3 = (HP3side + HP3side2) / 2;
HP4 = (HP1 + HP2) / 2;
HP5 = HP3;

% Create a figure
figure;

% Plot the original point
scatter3(HP1(1), HP1(2), HP1(3), 'r', 'filled', 'LineWidth', 1.2);
hold on;
scatter3(HP3side(1), HP3side(2), HP3side(3), 'r', '+', 'LineWidth', 1.2);

% Plot the mirrored point
scatter3(HP2(1), HP2(2), HP2(3), 'b', 'filled','LineWidth', 1.2);
scatter3(HP3side2(1), HP3side2(2), HP3side2(3), 'b', '+', 'LineWidth', 1.2);
scatter3(HP3(1), HP3(2), HP3(3), 80, 'm',  '+','LineWidth', 1.2);
scatter3(HP5(1), HP5(2), HP5(3), 'black',  '*','LineWidth', 1.2);
scatter3(HP4(1), HP4(2), HP4(3), 'c',  '*', 'LineWidth', 1.2);

% Plot new point
%scatter3(S4(1), S4(2), S4(3), 'b', 'filled');

% Plot the plane formed by P1, P2, P3
fill3([S1(1), S2(1), S3(1)], [S1(2), S2(2), S3(2)], [S1(3), S2(3), S3(3)], 'g', 'FaceAlpha', 0.3);

% Plot the plane formed by S4, midS15, P3
fill3([S4(1), midS12(1), S3(1)], [S4(2), midS12(2), S3(2)], [S4(3), midS12(3), S3(3)], 'r', 'FaceAlpha', 0.3);



% Plot the normal vector of the plane with an extended length
% quiver3(midS12(1), midS12(2), midS12(3), 20 * normalVector1(1), 20 * normalVector1(2), 20 * normalVector1(3), 'k', 'LineWidth', 4, 'MaxHeadSize', 10);

%plot the recosntructed pelvis .stl
TR = stlread('C:\Users\Yazan\OneDrive\Desktop\MEng project\3DP-Prosthesis-Reconsrtucion\Perini Massimo\PERINI MASSIMO_pelvis left_001.stl');
TRR = stlread('C:\Users\Yazan\OneDrive\Desktop\MEng project\3DP-Prosthesis-Reconsrtucion\Perini Massimo\PERINI MASSIMO_pelvis right_001.stl');
TRRR = stlread('C:\Users\Yazan\OneDrive\Desktop\MEng project\3DP-Prosthesis-Reconsrtucion\Perini Massimo\PERINI MASSIMO_pelvis right_001.stl');
transparencyIndex1 = 0.5
% Plot the STL model using patch
patch('Faces', TR.ConnectivityList, 'Vertices', TR.Points, 'FaceColor', [0.89 0.85 0.79], 'EdgeColor', 'none','FaceLighting','gouraud','AmbientStrength',0.50, 'SpecularStrength',0.2,'FaceAlpha',0.9);
patch('Faces', TRR.ConnectivityList, 'Vertices', TRR.Points, 'FaceColor', [0 0.4470 0.7410], 'EdgeColor', 'none','FaceLighting','gouraud','AmbientStrength',0.50, 'SpecularStrength',0.2,'FaceAlpha',0.9);
patch('Faces', TRRR.ConnectivityList, 'Vertices', TRRR.Points, 'FaceColor', [0.89 0.85 0.79], 'EdgeColor', 'none','FaceLighting','gouraud','AmbientStrength',0.50, 'SpecularStrength',0.2,'FaceAlpha',0.3);
axis equal;
title('Reconstructed Pelvis');
light('Position', [0 1 0]);
light('Position', [0 -1 0]);
axis on;
box on;
rotate3d on; 
xlabel('x (Right/Left)');
ylabel('y (Ant/Pos)');
zlabel('z (Pro/Dis)');
view(16,10);
% global graph properties
set(gcf,'Color','w');


% Display legend
legend('P1:', 'P3 Right:', 'P2:', 'P3 Left:', 'P3:', 'P5', 'P4:', 'Sacral Plane', 'Mirror Plane');

side = referenceSideGUI();
disp(['Reference side is on the ' num2str(side)]);

% Save variables in a .csv file with a modified name
[~, name, ~] = fileparts(filename_iges2);
modified_filename = [name, '_complete.csv'];
[~, path] =  uiputfile('*.csv', 'Save Variables As', modified_filename);
location = (path+"\"+modified_filename)

if side == 1
    writetable(table(HP1, HP2, HP3, HP4, HP5),location);
else
    writetable(table(HP2, HP1, HP3, HP4, HP5),location);
end
    


disp(['Variables saved in ', modified_filename]);

function side = referenceSideGUI()
    % Create figure
    fig = uifigure('Name', 'Reference Is On The Right Side?', 'Position', [100, 100, 300, 150]);

    % Create yes button
    yesButton = uibutton(fig, 'Text', 'Yes', 'Position', [50, 50, 75, 30], 'ButtonPushedFcn', @(btn,event)buttonCallback(1));

    % Create no button
    noButton = uibutton(fig, 'Text', 'No', 'Position', [175, 50, 75, 30], 'ButtonPushedFcn', @(btn,event)buttonCallback(0));

    % Initialize side variable
    side = [];

    % Wait for the user to respond
    waitfor(fig);

    % Callback function for buttons
    function buttonCallback(response)
        side = response;
        close(fig);
    end
end


