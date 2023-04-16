clc
clear
close all

%----------Wartosc zmieniana-----------
lambda = 1/3.6;
%--------------------------------------

%r=35mm=0.035m
r = 0.035;
%n=5500 obr/min
n = 5500;
omega = (2 * pi * n) / 60; %czestotliwosc w radianach na sekunde

%wartosci alfa podane sa w stopniach
alfa_min = -10;
alfa_max = 370;
alfa_step = 5;
alfa_vector_degrees = alfa_min:alfa_step:alfa_max;
alfa_vector_radians = deg2rad(alfa_vector_degrees);

t = alfa_vector_degrees / omega;
t_radian = alfa_vector_radians / omega;
deltat = deg2rad(alfa_step) / omega;

Y = r * (cosd(omega * t) + (1 / lambda) * (sqrt(1 - (lambda^2) * (sind(omega * t).^2))));

fig1 = figure(1);
plot(alfa_vector_degrees, Y);
title('Wykres polozenia tloka');
xlabel('α [°]');
ylabel('Y [m]');
grid on;
xlim([-10, 370]);

N = length(Y);
dY = zeros(1, N);
%t_radian(i+1)-t_radian(i-1)
for i = 2:N - 1
    dY(i) = (Y(i + 1) - Y(i - 1)) / (2 * deltat);
end

ddY = zeros(1, N);

%(t_radian(i+1)-t_radian(i-1)
for i = 2:N - 1
    ddY(i) = (dY(i + 1) - dY(i - 1)) / (2 * deltat);
end

fig2 = figure(2);
hold on;
plot(alfa_vector_degrees, dY, 'Color', 'blue'); % Rysowanie wykresu v(a)
[m2, index] = max(dY);
scatter(((index - 3) * alfa_step), m2, 'filled', 'blue');
title('Wykres v(α) oraz a(α)');
xlabel('alfa [°]');
ylabel('v [m/s]');
grid on;
xlim([0, 360]);
yyaxis right;
ax = gca;
ax.YColor = 'b';
plot(alfa_vector_degrees, ddY, 'Color', 'red'); % Rysowanie wykresu A(a)
ylabel('a [m/s^2]');
[m3, index] = max(ddY);
scatter(180, m3, 'filled', 'red');
m4 = min(ddY);
fprintf('Wartosc maksymalna predkosci wynosi %f\n', m2);
fprintf('Wartosc maksymalna przyspieszenia wynosi %f, natomiast wartosc minimalna jest rowna %f\n', m3, m4);
legend('predkosc', 'Maksimum predkosci', 'przyspieszenie', 'Maksimum przyspieszenia', 'Location', 'northwest');

%porownanie Stirlinga majacego 2 element wzoru
syms alfa
yrownanie = r * (cos(alfa) + (1 / lambda) * sqrt(1 - lambda^2 * sin(alfa)^2));

yf = matlabFunction(yrownanie);

Y = yf(deg2rad(alfa_vector_degrees));
n = size(Y, 2);
m = n - 1;

tab = zeros(n);
tab(:, 1) = Y;

for i = 2:n

    for j = 1:m
        tab(j, i) = tab(j + 1, i - 1) - tab(j, i - 1);
        m = m - 1;
    end

    m = n - i;
end

m = n - 2;

dY_expanded = zeros(m, 1);

for i = 1:m
    % dY_expanded(i, 1) = ((tab(i + 1, 2) + tab(i, 2)) / (2)) - ((1/6) * ((tab(i + 1, 4) + tab(i, 4))) / 2);
    dY_expanded(i, 1) = ((tab(i + 1, 2) + tab(i, 2)) / 2) - ((1/6) * ((tab(i + 1, 4) + tab(i, 4)) / 2));
    m = m - 1;
end

h = alfa_vector_degrees(2) - alfa_vector_degrees(1);
dY_expanded = dY_expanded * (1 / h);
dY_expanded = dY_expanded';
% 1 / alfa_step
fig3 = figure(3);
plot(alfa_vector_degrees, dY);
hold on;
plot(alfa_vector_degrees, [0 dY_expanded 0]);
title('Wykres polozenia pochodnej tloka');
xlabel('alfa[stopnie]');
ylabel('Y [m]');
grid on;
legend('Stirling 1', 'Stirling 2');

fig4 = figure(4);
plot(alfa_vector_degrees, dY);
hold on;
% Y = r * (cosd(omega * t) + (1 / lambda) * (sqrt(1 - (lambda^2) * (sind(omega * t).^2))));
plot(alfa_vector_degrees, [0 dY_expanded 0] * 33500);
title('Wykres polozenia pochodnej tloka');
xlabel('alfa [°]');
ylabel('Y [m]');
grid on;
legend('Stirling 1', 'Stirling 2')
