clear
% Define the data for the two variables
x1 = ["3D Printed Implant","3D Printed Implant","3D Printed Implant","3D Printed Implant","3D Printed Implant","3D Printed Implant","3D Printed Implant","3D Printed Implant"]
x1 = cellstr(x1)
X1 = categorical(x1)
x2 = cellstr(["Bone Graft","Bone Graft","Bone Graft","Bone Graft","Bone Graft","Bone Graft","Bone Graft","Bone Graft"])
X2 = categorical(x2)
y1 = [42.92513114
57.52563747
54.50343951
43.1186701
45.43998474
50.13525361
61.35826787
50.05122264]

y2 = [31.38129208
38.88513285
42.20929097
48.83249584
15.29804118
33.26015732
31.70685373
26.67825937
]
% Create the scatter plot
figure;

scatter(X1, y1, 'o', 'fill', 'red'); 
%colororder("reef")
hold on

scatter(X2, y2, 'square', 'fill', 'blue'); 

% Add a shaded box from y = 30 to y = 45

ylim([10 65]);
% Add a shaded box from y = 30 to y = 45 using patch
patch([0.5 0.5 2.5 2.5], [30 45 45 30], 'green', 'FaceAlpha', 0.1);
patch([0.5 0.5 2.5 2.5], [45 50 50 45], 'blue', 'FaceAlpha', 0.1);

% Set the title and labels
title('Reconstructed Acetabular Inclination Angles');
%xlabel('X-Axis');
ylabel('Inclination Angle (deg)');


