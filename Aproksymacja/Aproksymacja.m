%-------------------------------------------------------------------------%
%                               Informacje
%-------------------------------------------------------------------------%
%
% Radosław Tchórzewski & Oliver Davis                  
% METODY NUMERYCZNE
% AEI AiR Grupa 6
% Lab 7, "Aproksymacja", 31.05.2022
%
%-------------------------------------------------------------------------%

clc
clear
close all

x = [20 30 40 50 80 140 200 250];
y = [4.8 3.2 2.5 2.5 1.5 1.7 1.2 0.8];
fprintf('Przyklad 1:\n');
xn = linspace(15,280,1000); %Przedzial dla generowanego wykresu
aproksymacja(x,y,xn);
title('Regresja wielkości drgań gruntu względem odległości od ogniska trzęsienia ziemi');
xlabel('Odległość od ogniska trzęsienia, km');
ylabel('Wielkość drgań pionowych gruntu, cm');
xlim([15,280]);
hold off;

fprintf("\n-------------------------------------------------------------------------\n\n");

x = [10 20 30 40 50 60 70 80];
y = [6.5 5.5 3.8 3.3 2.5 2.2 1.7 1.5];
fprintf('Przyklad 2:\n');
xn = linspace(1,100); %Przedzial dla generowanego wykresu
aproksymacja(x,y,xn);
title('Kąt obrotu wektora namagnesowania próbki w zależności od wielkości ziaren próbki');
xlabel('Wielkość ziaren, μm');
ylabel('Kąt obrotu, °');
xlim([1,100]);
hold off;


function aproksymacja(x,y,xn)

    %FUNKCJA LINIOWA
    corr1 = corrcoef(x,y); % Macierz współczynników korelacji
    wsp1 = abs(corr1(1,2)); % Obliczony współczynnik korelacji

    %FUNKCJA HIPERBOLICZNA
    xp2 = 1./x;
    corr2 = corrcoef(xp2,y);
    wsp2 = abs(corr2(1,2));

    %FUNKCJA POTĘGOWA
    xp3 = log(x);
    yp3 = log(y);
    corr3 = corrcoef(xp3,yp3);
    wsp3 = abs(corr3(1,2));

    %FUNKCJA LOGARYTMICZNA
    xp4 = log(x);
    corr4 = corrcoef(xp4,y);
    wsp4 = abs(corr4(1,2));

    %FUNKCJA WYKŁADNICZA
    yp5 = log(y);
    corr5 = corrcoef(x,yp5);
    wsp5 = abs(corr5(1,2));

    [corrMax,i] = max([wsp1 wsp2 wsp3 wsp4 wsp5]); % Zwracanie współczynnika korelacji i jego pozycji

    switch i % Dobieranie funkcji aproksymujacej na bazie wspolczynnika korelacji
        case 1 %FUNKCJA LINIOWA
            linCoef = coefficients(x,y); % Wyznaczenie współczynników c1 i c2
            Error = MSE(x,y,linCoef); % Błąd średniokwadratowy
            yn = linCoef(1) + linCoef(2).*xn;
            PlotGraph(xn,yn,x,y); %Tworzenie wykresu
            fprintf('Najlepiej aproksymuje funkcja liniowa o wspolczynniku rownym: %f\n',corrMax);
            fprintf('Błąd średniokwadratowy dla tej funkcji wynosi: %f\n',Error);

        case 2 %FUNKCJA HIPERBOLICZNA
            linCoef = coefficients(xp2,y);
            Error = MSE(xp2,y,linCoef);
            yn = linCoef(1) + linCoef(2)./xn;
            PlotGraph(xn,yn,x,y); %Tworzenie wykresu
            fprintf('Najlepiej aproksymuje funkcja hiperboliczna o wspolczynniku rownym: %f\n',corrMax);
            fprintf('Błąd średniokwadratowy dla tej funkcji wynosi: %f\n',Error);

        case 3 %FUNKCJA POTĘGOWA
            linCoef = coefficients(xp3,yp3);
            Error = MSE(xp3,yp3,linCoef);
            linCoef(1) = exp(linCoef(1));
            yn = linCoef(1) * xn.^linCoef(2);
            PlotGraph(xn,yn,x,y); %Tworzenie wykresu
            fprintf('Najlepiej aproksymuje funkcja potegowa o wspolczynniku rownym: %f\n',corrMax);
            fprintf('Błąd średniokwadratowy dla tej funkcji wynosi: %f\n',Error);

        case 4 %FUNKCJA LOGARYTMICZNA
            linCoef = coefficients(xp4,y);
            Error = MSE(xp4,y,linCoef);
            yn = linCoef(1) + linCoef(2)*log(xn);
            PlotGraph(xn,yn,x,y); %Tworzenie wykresu     
            fprintf('Najlepiej aproksymuje funkcja logarytmiczna o wspolczynniku rownym: %f\n',corrMax);
            fprintf('Błąd średniokwadratowy dla tej funkcji wynosi: %f\n',Error);

        case 5 %FUNKCJA WYKŁADNICZA
            linCoef = coefficients(x,yp5);
            Error = MSE(x,yp5,linCoef);
            linCoef(1) = exp(linCoef(1));
            yn = linCoef(1) * exp(linCoef(2).*xn);
            PlotGraph(xn,yn,x,y); %Tworzenie wykresu
            fprintf('Najlepiej aproksymuje funkcja wykladnicza o wspolczynniku rownym: %f\n',corrMax);
            fprintf('Błąd średniokwadratowy dla tej funkcji wynosi: %f\n',Error);
        
        otherwise
            disp('Blad programu!');
    end    
end

function PlotGraph(x1,y1,x2,y2) % Rysowanie wykresu punktowego
        figure;
        hold on;
        grid on;
        plot(x1,y1); %Wykres funkcji aproksymujacej
        scatter(x2,y2,'filled');%Nalozenie zadanych punktow
        grid(gca,'minor');
end

function C = coefficients(x,y) % Wyznaczanie współczynników
        A = [x.^0; x.^1; x.^2];
        B = [y; x.*y];
        S = sum(A,2);
        Tp = sum(B,2);
        auxMatrix = [S(1) S(2) ; S(2) S(3)];
        C = linsolve(auxMatrix,Tp);
end

function result = MSE(x,y,C) % Wyznaczenie błędu średniokwadratowego
    result = 0;
    N = length(x);
    for i = 1:N
        auxResult = (y(i) - C(2) * x(i) - C(1))^2;
        result = result + auxResult;
    end
end

