clear

% Use uigetfile to select the CSV files
[Filename, Path] = uigetfile('*.csv', 'Select Healthy Pelvis Anatomical Landmarks (Palpated & Mirrored) CSV File');

% Construct the full file paths
FilePath = fullfile(Path, Filename);

% Import data from the first CSV file
Healthypoints = readtable(FilePath);
Healthypoints = table2array(Healthypoints);

P1 = Healthypoints(:,1);
P2 = Healthypoints(:,2);
P3 = Healthypoints(:,3);
P4 = Healthypoints(:,4);
P5 = Healthypoints(:,5);

R = PLANAX(P1,P2,P3,P4,P5);

%%%%%%%%

% Extract individual vectors
x = R(1:3, 1);
y = R(4:6, 1);
z = R(7:9, 1);

% Check orthogonality
dot_xy = dot(x, y);
dot_xz = dot(x, z);
dot_yz = dot(y, z);

% Display the results
disp(['Dot product (x, y): ', num2str(dot_xy)]);
disp(['Dot product (x, z): ', num2str(dot_xz)]);
disp(['Dot product (y, z): ', num2str(dot_yz)]);


%%%%%%%%
Rot = [0;0;0.5];

R = ROTTER(R,Rot);

%%%%%%%%

% Extract individual vectors
x = R(1:3, 1);
y = R(4:6, 1);
z = R(7:9, 1);

% Check orthogonality
dot_xy = dot(x, y);
dot_xz = dot(x, z);
dot_yz = dot(y, z);

% Display the results
disp(['Dot product (x, y): ', num2str(dot_xy)]);
disp(['Dot product (x, z): ', num2str(dot_xz)]);
disp(['Dot product (y, z): ', num2str(dot_yz)]);

%%%%%%%%


% Define the x, y, and z coordinates of the tip of the healthy x-axis
x1 = (R(1,1)*100+P3(1));
y1 = (R(2,1)*100+P3(2));
z1 = (R(3,1)*100+P3(3));

% Define the x, y, and z coordinates of the tip of the healthy y-axis
x2 = (R(4,1)*100+P3(1));
y2 = (R(5,1)*100+P3(2));
z2 = (R(6,1)*100+P3(3));

% Define the x, y, and z coordinates of the tip of the healthy z-axis
x3 = (R(7,1)*100+P3(1));
y3 = (R(8,1)*100+P3(2));
z3 = (R(9,1)*100+P3(3));

%%%%%%%%%%%%

plot3(P1(1),P1(2),P1(3),'x','LineWidth', 1.3);
hold on
plot3(P2(1),P2(2),P2(3),'o','LineWidth', 1.3);
plot3(P3(1),P3(2),P3(3),'+','LineWidth', 1.3, 'MarkerSize', 10);
plot3(P4(1),P4(2),P4(3),'*','LineWidth', 1.3);
plot3(P5(1),P5(2),P5(3),'square','LineWidth', 1.3);
plot3([x1 x2 x3], [y1 y2 y3], [z1 z2 z3], 'o');

arrow3([P3(1) P3(2) P3(3)], [x1 y1 z1], 'r');
text(x1, y1, z1, 'Anatomical X Axis', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'Color', 'r', 'FontSize', 10);
 
arrow3([P3(1) P3(2) P3(3)], [x2 y2 z2], 'g');
text(x2, y2, z2+10, 'Anatomical Y Axis', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'Color', 'g', 'FontSize', 10);
 
arrow3([P3(1) P3(2) P3(3)], [x3 y3 z3], 'b');
text(x3, y3, z3+10, 'Anatomical Z Axis', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'Color', 'b', 'FontSize', 10);

%%%%%%%%%%

% %Plotting the axes of the global reference frame 
% arrow3([0 0 0], [100 0 0], 'r');
% text(100, 0, 0, 'Global X Axis', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'Color', 'r', 'FontSize', 10);
% 
% arrow3([0 0 0], [0 100 0], 'g');
% text(0, 100, 0, 'Global Y Axis', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'Color', 'g', 'FontSize', 10);
% 
% arrow3([0 0 0], [0 0 100], 'b');
% text(0, 0, 100, 'Global Z Axis', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'Color', 'b', 'FontSize', 10);


%plotting the pelvis

%plot the recosntructed pelvis .stl
TR = stlread('C:\Users\Yazan\OneDrive\Desktop\MEng project\3DP-Prosthesis-Reconsrtucion\Giambartolomei Agnese\GIAMBARTOLOMEI AGNESE_pelvis right_002.stl');
TRR = stlread('C:\Users\Yazan\OneDrive\Desktop\MEng project\3DP-Prosthesis-Reconsrtucion\Giambartolomei Agnese\GIAMBARTOLOMEI AGNESE PELVIS RIGHT COPY.stl');
transparencyIndex1 = 0.5
% Plot the STL model using patch
patch('Faces', TR.ConnectivityList, 'Vertices', TR.Points, 'FaceColor', [0.89 0.85 0.79], 'EdgeColor', 'none','FaceLighting','gouraud','AmbientStrength',0.50, 'SpecularStrength',0.2,'FaceAlpha',0.9);
patch('Faces', TRR.ConnectivityList, 'Vertices', TRR.Points, 'FaceColor', [0 0.4470 0.7410], 'EdgeColor', 'none','FaceLighting','gouraud','AmbientStrength',0.50, 'SpecularStrength',0.2,'FaceAlpha',0.9);
axis equal;
title('Healthy Pelvis');
light('Position', [0 1 0]);
light('Position', [0 -1 0]);
axis on;
box on;
grid on;
rotate3d on; 
xlabel('x (Right/Left)');
ylabel('y (Ant/Pos)');
zlabel('z (Pro/Dis)');
view(16,10);
% global graph properties
set(gcf,'Color','w');

legend('P1','P2','P3','P4','P5')

% Export R and P5 as a CSV file with GUI for file selection
[fileName, filePath] = uiputfile('*.csv', 'Save R and P5 as CSV');
if fileName ~= 0
    location = (filePath+"\"+fileName)
    PP5 = [P5;0;0;0;0;0;0]
    writetable(table([R],[PP5]), location);
    disp(['File saved successfully: ' fullfile(filePath, fileName)]);
else
    disp('File not saved.');
end
