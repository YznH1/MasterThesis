clear
% Select first IGES file using GUI
[filename_iges1, path_iges1] = uigetfile('*.igs', 'Select IGES File For Reconstructed Acetabular Ridge Points ');
if isequal(filename_iges1, 0)
    disp('User canceled IGES file selection. Exiting...');
    return;
end

% Import first IGES data
[ParameterData, ~, ~, ~] = iges2matlab(fullfile(path_iges1, filename_iges1));
% Initialize points with the first set of coordinates
points = zeros(length(ParameterData),3);
points(1,:) = [ParameterData{1}.x, ParameterData{1}.y, ParameterData{1}.z];

% Concatenate the remaining coordinates using a loop
for i = 2:numel(ParameterData)
    points(i,:) = [ParameterData{i}.x, ParameterData{i}.y, ParameterData{i}.z];
end

% Select second IGES file using GUI
[filename_iges2, path_iges2] = uigetfile('*.igs', 'Select IGES File For Healthy Acetabular Ridge Points ');
if isequal(filename_iges2, 0)
    disp('User canceled IGES file selection. Exiting...');
    return;
end

% Import second IGES data
[ParameterData2, ~, ~, ~] = iges2matlab(fullfile(path_iges2, filename_iges2));
% Initialize points with the first set of coordinates
points2 = zeros(length(ParameterData2),3);
points2(1,:) = [ParameterData2{1}.x, ParameterData2{1}.y, ParameterData2{1}.z];

% Concatenate the remaining coordinates using a loop
for i = 2:numel(ParameterData2)
    points2(i,:) = [ParameterData2{i}.x, ParameterData2{i}.y, ParameterData2{i}.z];
end

% Use uigetfile to select the CSV files
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

%%%5

%% compute the normal to the plane and a center point that belongs to the plane
[n,~,center] = affine_fit(points);
[n2,~,center2] = affine_fit(points2);


%Decompose normal vecotor of reconstructed acetabular face

ReconstructednormalCoordinateslocally(1) = dot(HealthyAxes(1:3,1),n)
ReconstructednormalCoordinateslocally(2) = dot(HealthyAxes(4:6,1),n)
ReconstructednormalCoordinateslocally(3) = dot(HealthyAxes(7:9,1),n)

ReconstructednormalCoordinateslocally = ReconstructednormalCoordinateslocally / norm(ReconstructednormalCoordinateslocally);

ReconstructedInclinationAngle = atan2(abs(ReconstructednormalCoordinateslocally(2)),abs(ReconstructednormalCoordinateslocally(3)))

%convert the angle to absolute since inclination angle calculated by atan2
%can never be greater than 90 and less than 0 
%Since the angle obtained is from the horizontal we substract it from 90 to
%get the angle to the vertical

ReconstructedInclinationAngle = 90 - abs(rad2deg(ReconstructedInclinationAngle))

%Decompose normal vector of healthy acetabular face

HealthynormalCoordinateslocally(1) = dot(HealthyAxes(1:3,1),n2)
HealthynormalCoordinateslocally(2) = dot(HealthyAxes(4:6,1),n2)
HealthynormalCoordinateslocally(3) = dot(HealthyAxes(7:9,1),n2)

HealthynormalCoordinateslocally = HealthynormalCoordinateslocally / norm(HealthynormalCoordinateslocally);

Healthyinclinationangle = atan2(abs(HealthynormalCoordinateslocally(2)),abs(HealthynormalCoordinateslocally(3)))

%convert the angle to absolute since inclination angle calculated by atan2
%can never be greater than 90 and less than 0 
%Since the angle obtained is from the horizontal we substract it from 90 to
%get the angle to the vertical

HealthyInclinationAngle = 90 - abs(rad2deg(Healthyinclinationangle))


%plot

scatter3(points(:, 1), points(:,2), points(:,3), 'or','LineWidth', 1.2);
hold on
scatter3(points2(:, 1), points2(:,2), points2(:,3), 'xb','LineWidth', 1.2);


%plot healthy axes at reconstructed acetabulum 
quiver3(center(1), center(2), center(3), x(1)*100, x(2)*100,x(3)*100, 'b', 'LineWidth', 2, 'MaxHeadSize', 1.5, 'DisplayName', 'Healthy Axes');
text(center(1)+x(1)*100, center(2)+x(2)*100, center(3)+x(3)*100, 'Anatomical Healthy X Axis', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'Color', 'b', 'FontSize', 10);

quiver3(center(1), center(2), center(3), y(1)*100, y(2)*100,y(3)*100, 'g', 'LineWidth', 2, 'MaxHeadSize', 1.5, 'DisplayName', 'Healthy Axes');
text(center(1)+y(1)*100, center(2)+y(2)*100, center(3)+y(3)*100, 'Anatomical Healthy Y Axis', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'Color', 'g', 'FontSize', 10);

quiver3(center(1), center(2), center(3), z(1)*100, z(2)*100,z(3)*100, 'r', 'LineWidth', 2, 'MaxHeadSize', 1.5, 'DisplayName', 'Healthy Axes');
text(center(1)+z(1)*100, center(2)+z(2)*100, center(3)+z(3)*100+12, 'Anatomical Healthy Z Axis', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'Color', 'r', 'FontSize', 10);

%plot healthy axes at healthy acetabulum 
quiver3(center2(1), center2(2), center2(3), x(1)*100, x(2)*100,x(3)*100, 'b', 'LineWidth', 2, 'MaxHeadSize', 1.5, 'DisplayName', 'Healthy Axes');
text(center2(1)+x(1)*100, center2(2)+x(2)*100, center2(3)+x(3)*100, 'Anatomical Healthy X Axis', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'Color', 'b', 'FontSize', 10);

quiver3(center2(1), center2(2), center2(3), y(1)*100, y(2)*100,y(3)*100, 'g', 'LineWidth', 2, 'MaxHeadSize', 1.5, 'DisplayName', 'Healthy Axes');
text(center2(1)+y(1)*100, center2(2)+y(2)*100, center2(3)+y(3)*100, 'Anatomical Healthy Y Axis', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'Color', 'g', 'FontSize', 10);

quiver3(center2(1), center2(2), center2(3), z(1)*100, z(2)*100,z(3)*100, 'r', 'LineWidth', 2, 'MaxHeadSize', 1.5, 'DisplayName', 'Healthy Axes');
text(center2(1)+z(1)*100, center2(2)+z(2)*100, center2(3)+z(3)*100+12, 'Anatomical Healthy Z Axis', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'Color', 'r', 'FontSize', 10);


%% PLOT PLANE N
%plot the two adjusted planes

% Define the range of x and y values for the first mech
xRange = linspace(center(1) - 40, center(1) + 40, 3);
yRange = linspace(center(2) - 40, center(2) + 40, 3);

% Create a mesh grid using meshgrid
[X, Y] = meshgrid(xRange, yRange);
% [X,Y] = meshgrid(linspace(center,50,3));

% Define the range of x and y values for the first mech
xRange2 = linspace(center2(1) - 40, center2(1) + 40, 3);
yRange2 = linspace(center2(2) - 40, center2(2) + 40, 3);

% Create a mesh grid using meshgrid
[X2, Y2] = meshgrid(xRange2, yRange2);
% [X1,Y1] = meshgrid(linspace(0,-50,3));
%first plane
surf(X,Y, - (n(1)/n(3)*X+n(2)/n(3)*Y-dot(n,center)/n(3)),'facecolor','red','facealpha',0.5);
%second plane
%first plane
surf(X2,Y2, - (n2(1)/n2(3)*X2+n2(2)/n2(3)*Y2-dot(n2,center2)/n2(3)),'facecolor','blue','facealpha',0.5);
grid on; hold on;
%plot the  points P0
%plot3(P0(1),P0(2),P0(3),'ro','markersize',10,'markerfacecolor','red');

%plot the normal vector of the reconstructed acetabular surface
quiver3(center(1),center(2),center(3),n(1)*100,n(2)*100,n(3)*100,'k','linewidth',2);
text(center(1)+n(1)*100, center(2)+n(2)*100, center(3)+n(3)*100, 'Normal Vector', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'Color', 'k', 'FontSize', 10);

%plot the normal vector of the healthy acetabular surface
quiver3(center2(1),center2(2),center2(3),n2(1)*100,n2(2)*100,n2(3)*100,'k','linewidth',2);
text(center2(1)+n2(1)*100, center2(2)+n2(2)*100, center2(3)+n2(3)*100, 'Normal Vector', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'Color', 'k', 'FontSize', 10);


%plot the recosntructed pelvis .stl
TR = stlread('C:\Users\Yazan\OneDrive\Desktop\MEng project\3DP-Prosthesis-Reconsrtucion\landi daniela\LANDI DANIELA_implant pelvis_001.stl');
TRR = stlread('C:\Users\Yazan\OneDrive\Desktop\MEng project\3DP-Prosthesis-Reconsrtucion\landi daniela\LANDI DANIELA_pelvis left_001.stl');
TRRR = stlread('C:\Users\Yazan\OneDrive\Desktop\MEng project\3DP-Prosthesis-Reconsrtucion\landi daniela\LANDI DANIELA_pelvis right_002.stl');
transparencyIndex1 = 0.6
% Plot the STL model using patch
patch('Faces', TR.ConnectivityList, 'Vertices', TR.Points, 'FaceColor', [0.89 0.85 0.79], 'EdgeColor', 'none','FaceLighting','gouraud','AmbientStrength',0.50, 'SpecularStrength',0.2,'FaceAlpha',transparencyIndex1);
patch('Faces', TRR.ConnectivityList, 'Vertices', TRR.Points, 'FaceColor', [0.89 0.85 0.79], 'EdgeColor', 'none','FaceLighting','gouraud','AmbientStrength',0.50, 'SpecularStrength',0.2,'FaceAlpha',transparencyIndex1);
patch('Faces', TRRR.ConnectivityList, 'Vertices', TRRR.Points, 'FaceColor', [0 0.4470 0.7410], 'EdgeColor', 'none','FaceLighting','gouraud','AmbientStrength',0.50, 'SpecularStrength',0.2,'FaceAlpha',transparencyIndex1);
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
% xlim([-200 200]);
% ylim([-200 200]);
% zlim([-200 200]);
view(16,10);
% global graph properties
set(gcf,'Color','w');

legend('Reconstructed Acetabular Ridge Points','Healthy Acetabular Ridge Points','','','','','','','','','','','','Best Fit Plane','Best Fit Plane')

% Export inclination angle as a CSV file with GUI for file selection
[fileName, filePath] = uiputfile('*.csv', 'Save inclination angles of healthy and reconstructed acetabulums');
if fileName ~= 0
    location = (filePath+"\"+fileName);
    writetable(table([ReconstructedInclinationAngle],[HealthyInclinationAngle]), location);
    disp(['File saved successfully: ' fullfile(filePath, fileName)]);
else
    disp('File not saved.');
end

function [n,V,p] = affine_fit(X)
    %Computes the plane that fits best (lest square of the normal distance
    %to the plane) a set of sample points.
    %INPUTS:
    %
    %X: a N by 3 matrix where each line is a sample point
    %
    %OUTPUTS:
    %
    %n : a unit (column) vector normal to the plane
    %V : a 3 by 2 matrix. The columns of V form an orthonormal basis of the
    %plane
    %p : a point belonging to the plane
    %
    %NB: this code actually works in any dimension (2,3,4,...)
    %Author: Adrien Leygue
    %Date: August 30 2013
    
    %the mean of the samples belongs to the plane
    p = mean(X,1);
    
    %The samples are reduced:
    R = bsxfun(@minus,X,p);
    %Computation of the principal directions if the samples cloud
    [V,D] = eig(R'*R);
    %Extract the output from the eigenvectors
    n = V(:,1);
    V = V(:,2:end);
end


