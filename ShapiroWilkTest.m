clear
% 
x1 = [0.400672848
0.41907365
0.386545379
0.298504978
0.405244919
0.342903028
0.350859243
0.400178155


]

y1 = [0.36
0.26
0.06
-0.02
0.04
0.06
0.01
0.08
]

z1 = [0.796816923
0.804576752
0.694185137
0.635873924
0.855402229
0.71705525
0.697612649
0.756106389

]

x2 = [0.545526664
0.526413701
0.408057064
0.29201706
0.422562306
0.362275225
0.352744886
0.430781116


]

y2 = [0.11
-0.16
-0.02
0.01
-0.23
0.01
0.24
-0.06
]

z2 = [0.73979717
0.749202474
0.691223665
0.654231211
0.802496978
0.682958172
0.828784584
0.762539328
]
% 
% 
% 
% % 
% %  % histogram(x2,15)
  [HNorm1, pNorm1, WNorm1] = swtest(x1,0.05,0)
  [HNorm2, pNorm2, WNorm2] = swtest(x2,0.05,0)
  [HNorm3, pNorm3, WNorm3] = swtest(y1,0.05,0)
  [HNorm4, pNorm4, WNorm4] = swtest(y2,0.05,0)
% % 

%first = [x1,x2]
second = [y1,y2]
%third  = [z1,z2]

%t = tiledlayout(1,2,'TileSpacing','Compact');

%nexttile

% boxplot(first,'Labels',{'Healthy','Reconstructed'})
% ylabel('Greater Trochanter Offset')
% title('3D Printed Implant')

%nexttile

boxplot(second,'Labels',{'3D Printed Implant','Bone Graft'})
ylabel('Greater Trochanter Offset Deviation')
%title('Bone Graft')

% nexttile
% 
% boxplot(third,'Labels',{'Healthy','Reconstructed'})
% ylabel('Hip Center of Rotation Position')
% title('Medio/Lateral')

title('Greater Trochanter')

%Anterior/Posterior
% % 
[Hvar,pvar] = vartest2(x1,x2)


if Hvar == 0 & HNorm1 == 0 & HNorm2 == 0
    [Httest,pttest,ci,stats] = ttest2(x1,x2,'Vartype','equal')
    first = 1
elseif Hvar == 1 & HNorm1 == 0 & HNorm2 == 0
    [Httest,pttest,ci,stats] = ttest2(x1,x2,'Vartype','unequal')
    second = 2
end

[Hvar,pvar] = vartest2(y1,y2)

if Hvar == 0 & HNorm3 == 0 & HNorm4 == 0
    [Httest,pttest,ci,stats] = ttest2(y1,y2,'Vartype','equal')
    first = 1
elseif Hvar == 1 & HNorm3 == 0 & HNorm4 == 0
    [Httest,pttest,ci,stats] = ttest2(y1,y2,'Vartype','unequal')
    second = 2
end

[H, pValue, W] = swtest(x1, 0.05, 0)
[H, pValue, W] = swtest(x2, 0.05, 0)
[H, pValue, W] = swtest(y1, 0.05, 0)
[H, pValue, W] = swtest(y2, 0.05, 0)

% nu = stats.df;
% k = linspace(-15,15,300);
% tdistpdf = tpdf(k,nu);
% tval = stats.tstat
% tvalpdf = tpdf(tval,nu);
% tcrit = -tinv(0.95,nu)
% plot(k,tdistpdf)
% hold on
% scatter(tval,tvalpdf,"filled")
% xline(tcrit,"--")
% legend(["Student's t pdf","t-statistic","Critical Cutoff"])
