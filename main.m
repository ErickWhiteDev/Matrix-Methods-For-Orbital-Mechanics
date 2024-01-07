clearvars;
clc;
addpath(genpath(pwd));

r1   = [-9.841950433215101e+05 +3.932342044549424e+05 +6.991223682230414e+06];
v1   = [+4.883696742000000e+03 +5.689086045000000e+03 +3.665361590000000e+02];
cov1 = [+4.976545641899520e+04 +5.787130862568278e+04 +3.370410320935015e+03 +1.137272273949272e+01 -4.325472616114674e+00 -8.009705480233521e+01; ...
        +5.787130862568278e+04 +6.730377643610841e+04 +3.926542932121541e+03 +1.321992688238858e+01 -5.035560720747812e+00 -9.314985106902773e+01; ...
        +3.370410320935015e+03 +3.926542932121541e+03 +2.461403197221289e+02 +7.586865834476763e-01 -3.077848629905763e-01 -5.434034460756914e+00; ...
        +1.137272273949272e+01 +1.321992688238858e+01 +7.586865834476763e-01 +2.608186227148725e-03 -9.804181796720670e-04 -1.829751672999786e-02; ...
        -4.325472616114674e+00 -5.035560720747812e+00 -3.077848629905763e-01 -9.804181796720670e-04 +3.895883508545853e-04 +6.968892326415779e-03; ...
        -8.009705480233521e+01 -9.314985106902773e+01 -5.434034460756914e+00 -1.829751672999786e-02 +6.968892326415779e-03 +1.289253320300791e-01];

r2   = [-9.839696058965517e+05 +3.936845951174244e+05 +6.991219291625473e+06];
v2   = [+1.509562687000000e+03 +7.372938617000000e+03 -1.492509430000000e+02];
cov2 = [+4.246862551076427e+04 +2.066374367781032e+05 -5.011108933888592e+03 +3.104606531932427e+01 -1.201093683199582e+01 -2.207975848324051e+02; ...
        +2.066374367781032e+05 +1.005854717283451e+06 -2.434876491048039e+04 +1.510022508670080e+02 -5.850063541467530e+01 -1.074752763805685e+03; ...
        -5.011108933888592e+03 -2.434876491048039e+04 +6.131274993037449e+02 -3.667147183233717e+00 +1.391769957262238e+00 +2.601457791444154e+01; ...
        +3.104606531932427e+01 +1.510022508670080e+02 -3.667147183233717e+00 +2.272826228568773e-02 -8.778253314778023e-03 -1.613538091053610e-01; ...
        -1.201093683199582e+01 -5.850063541467530e+01 +1.391769957262238e+00 -8.778253314778023e-03 +3.428801115804722e-03 +6.251148178133809e-02; ...
        -2.207975848324051e+02 -1.074752763805685e+03 +2.601457791444154e+01 -1.613538091053610e-01 +6.251148178133809e-02 +1.148404222181769e+00];

r1 = r1 / 1000;
v1 = v1 / 1000;
cov1 = cov1 / 1000;

r2 = r2 / 1000;
v2 = v2 / 1000;
cov2 = cov2 / 1000;

[x1, y1, z1, ox1, oy1, oz1] = ProcessEphemeris(r1, v1, cov1);

[x2, y2, z2, ox2, oy2, oz2] = ProcessEphemeris(r2, v2, cov2, 10000);

baddist = mvnrnd([r2, v2], cov2, 10000);

x3 = baddist(:, 1);
y3 = baddist(:, 2);
z3 = baddist(:, 3);

xrad = (max(x2) - min(x2)) / 2;
yrad = (max(y2) - min(y2)) / 2;
zrad = (max(z2) - min(z2)) / 2;

I = imread('earth.png');
[ex, ey, ez] = sphere(100);
r = 6378.1;

figure (1);
hold on;
grid on;
axis equal;

scatter3(x1, y1, z1, 'MarkerEdgeColor', 'b', 'MarkerFaceColor', 'b');
plot3(ox1, oy1, oz1, "r", "LineWidth", 2.5);

warp(-ex * r, ey * r, -ez * r, I);

xlabel("Distance From Center of the Earth (km)");
ylabel("Distance From Center of the Earth (km)");
zlabel("Distance From Center of the Earth (km)");

title("Satellite Orbit Around Earth");

legend("Satellite Ephemeris Probability Distribution", "Satellite Orbit", "Location", "north");

set(gca, "FontName", "Times New Roman", "FontSize", 20);
set(gca, "LineWidth", 1);

figure (2);
hold on;
grid on;

scatter3(x1, y1, z1, 'MarkerEdgeColor', 'b', 'MarkerFaceColor', 'b');

xlabel("Distance From Center of the Earth (km)");
ylabel("Distance From Center of the Earth (km)");
zlabel("Distance From Center of the Earth (km)");

title("Satellite Ephemeris Probability Distribution");

view(-25, 25);

set(gca, "FontName", "Times New Roman", "FontSize", 20);
set(gca, "LineWidth", 1);

figure (3);
hold on;
grid on;
axis equal;

scatter3(x2(1:1000), y2(1:1000), z2(1:1000), 'MarkerEdgeColor', 'b', 'MarkerFaceColor', 'b');
plot3(ox2, oy2, oz2, "r", "LineWidth", 2.5);

warp(-ex * r, ey * r, -ez * r, I);

xlabel("Distance From Center of the Earth (km)");
ylabel("Distance From Center of the Earth (km)");
zlabel("Distance From Center of the Earth (km)");

title("Satellite Orbit Around Earth");

legend("Satellite Ephemeris Probability Distribution", "Satellite Orbit", "Location", "north");

set(gca, "FontName", "Times New Roman", "FontSize", 20);
set(gca, "LineWidth", 1);

figure (4);
hold on;
grid on;

scatter3(x2(1:1000), y2(1:1000), z2(1:1000), 'MarkerEdgeColor', 'b', 'MarkerFaceColor', 'b');

xlabel("Distance From Center of the Earth (km)");
ylabel("Distance From Center of the Earth (km)");
zlabel("Distance From Center of the Earth (km)");

title("Satellite Ephemeris Probability Distribution");

view(-25, 25);

set(gca, "FontName", "Times New Roman", "FontSize", 20);
set(gca, "LineWidth", 1);

figure (5);
hold on;
grid on;

scatter3(x2, y2, z2, 2, 'MarkerEdgeColor', 'b', 'MarkerFaceColor', 'b');
scatter3(x3, y3, z3, 2, 'MarkerEdgeColor', 'r', 'MarkerFaceColor', 'r');

plot3(ox2, oy2, oz2, "g", "LineWidth", 2.5);

xlabel("Distance From Center of the Earth (km)");
ylabel("Distance From Center of the Earth (km)");
zlabel("Distance From Center of the Earth (km)");

xlim([mean(x2) - xrad, mean(x2) + xrad]);
ylim([mean(y2) - yrad, mean(y2) + yrad]);
zlim([mean(z2) - zrad, mean(z2) + zrad]);

title("Satellite Ephemeris Probability Distribution Comparisons");

legend("Equinoctial Probability Distribution", "Cartesian Probability Distribution", "Satellite Orbit", "Location", "north");

view(-25, 25);

set(gca, "FontName", "Times New Roman", "FontSize", 20);
set(gca, "LineWidth", 1);
