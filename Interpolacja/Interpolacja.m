clc
clear
close all

%%
% Zadanie 1
% a) Dla punktów o współrzędnych x = [1 1.5 2 2.5] i y = [2 2.5 3.5 4.0] przygotować skrypt w programie 
% MATLAB umożliwiający znalezienie przybliżonej wartości funkcji w punkcie x0 = 1.75 korzystając z 
% wielomianu interpolacyjnego Lagrange’a.
% b) Dla wspomnianych punktów znaleźć wielomian interpolacyjny Lagrange’a (można skorzystać z 
% obliczeń symbolicznych syms)
% c) Sporządzić wykres f(x) dla zadanych punktów x = [1 1.5 2 2.5] i y = [2 2.5 3.5 4.0]
% d) Sporządzić wykres W(x) dla wielomianu interpolacyjnego Lagrange’a w przedziale [1,2.5].
% e) Korzystając z przygotowanego pliku skryptowego sporządzić wykres dla funkcji zadanej wektorami 
% y = [1 1 1 1 2 2 2 2], x = [1 2 3 4 5 6 7 8] i nanieść wielomian interpolacyjny Lagrange’a. Czy wielomian 
% interpolacyjny dobrze przybliża zadaną funkcję?

%Wielomian interpolacyjny po analizie wynikow dobrze przybliza
%zadana funkcje


%podanie wartosci
xinput = [1, 1.5, 2, 2.5];
yinput = [2, 2.5, 3.5, 4.0];
x0 = 1.75;

%Obliczenia dla pierwszego zbioru punktow
polynomialresult = interpolation(xinput,yinput);

fprintf('Podany wielomian: %s\n', char(polynomialresult))
polynomialvalue = polynomialresult(x0);
fprintf('Wartosc podanego wielomianu: %f\n',polynomialvalue)

%Tworzenie wykresu zawierajacego wielomian interpolacyjny Lagrange'a z
%zadanym krokiem oraz zadane punkty f(x)
xgraph = linspace(1,2.5);
ygraph = polynomialresult(xgraph);
figure(1);
plot(xgraph,ygraph);
hold on;
grid on;
scatter(xinput,yinput);
legend('Wykres wielomianu Lagrange''a','Naniesione punkty f(x)');

%Obliczenia dla drugiego zbioru punktow
xinput2 = [1,2,3,4,5,6,7,8];
yinput2 = [1,1,1,1,2,2,2,2];

polynomialresult2 = interpolation(xinput2,yinput2);

%Tworzenie wykresu zawierajacego wielomian interpolacyjny Lagrange'a z
%zadanym krokiem oraz zadane punkty f(x)
xgraph2 = linspace(1,8);
ygraph2 = polynomialresult2(xgraph2);
figure(2);
plot(xgraph2,ygraph2);
hold on;
grid on;
scatter(xinput2,yinput2);
legend('Wykres wielomianu Lagrange''a','Naniesione punkty f(x)');

%%
% Zadanie 2
% a. Korzystając z tablicy ilorazów różnicowych i ze wzoru interpolacyjnego Newtona wyznaczyć 
% wartość funkcji znając następujące węzły interpolacji: y = [7.3891 8.1662 9.0250 9.9742], x = [2.0 
% 2.1 2.2 2.3] w punkcie x = 2.25.
% b. Sporządzić wykresy funkcji f(x) i wielomianu interpolacyjnego Newtona W(x).
% c. Oszacować błąd interpolacji dla funkcji y = ex
% przyjmującej wartości przedstawione w punkcie 2a
% – zgodnie z pierwszym wzorem interpolacyjnym Newtona.

%podanie wartosci
xinput = [2.0, 2.1, 2.2, 2.3];
yinput = [7.3891, 8.1662, 9.0250, 9.9742];
x0 = 2.25;

%Obliczenia dla pierwszego zbioru punktow
polynomialvalue = interpolationNewton(xinput, yinput);
fprintf('Podany wielomian: %s\n', char(polynomialvalue))
fprintf('Wartosc funkcji w punkcie %f = %f \n',x0,polynomialvalue(x0));

%Tworzenie wykresu zawierajacego wielomian interpolacyjny Newtona
%oraz zadane punkty f(x)
Wxgraph = linspace(2.0,2.3);
Wygraph = polynomialvalue(Wxgraph);
figure;
plot(Wxgraph,Wygraph);
hold on;
grid on;
scatter(xinput,yinput);
legend('Wykres wielomianu Newtona','Naniesione punkty f(x)');

%fragment dotyczacy bledu interpolacji
h = xinput(2)-xinput(1);
t = (x0 - xinput(1))/h;
n = length(xinput);
Errortmp = 1;
polynomialError = 0;
for i = 1:n
   Errortmp = Errortmp*(t-i);
end
Errortmp = Errortmp*t*h^(n)/factorial(n);
syms x;
%podanie wzoru funkcji w celu rozszerzenia zakresu programu
fx = exp(x);
dx = diff(fx,n);
Errortmp = Errortmp*dx;
Errortmp = matlabFunction(Errortmp);
%sprawdzenie wartosci maksymalnej bledu
for i = 1:n
   tmp = abs(Errortmp(xinput(i)));
   if (tmp > polynomialError)
        polynomialError = tmp;
   end
end

fprintf('Oszacowany blad interpolacji wynosi: %f\n', polynomialError)


function polynomialresult = interpolation(xin,yin)
%funkcja zwraca obliczony wielomian interpolacyjny Lagrange'a ktory jest juz przygotowany pod obliczenia
%oraz nie jest typu obliczen symbolicznych
    syms x;
    polynomialresult=0;
    
    for i=1:length(yin)
        nominator=1;
        denominator=1;
            for j = 1:length(yin)
                if j ~= i
                   nominator = nominator * (x - xin(j));
                   denominator = denominator * (xin(i) - xin(j));
                end
            end
            polynomialresult = polynomialresult + yin(i) * nominator/denominator;
    end
    polynomialresult = simplify(polynomialresult);
    polynomialresult = matlabFunction(polynomialresult); 
end

function polynomial = interpolationNewton(xinput,yinput)
%funkcja ta oblicza szukany wielomian za pomoca
%wzoru interpolacyjnego newtona 
    n = length(xinput)-1;
    Matrix = zeros(n);
    
    z = n;
    for j = 1:n
        for i = 1:z
            if j == 1
                Matrix(i,j) = (yinput(i+1)-yinput(i))/(xinput(1+i)-xinput(i));
            else
                Matrix(i,j) = (Matrix(i+1,j-1)-Matrix(i,j-1))/(xinput(j+i)-xinput(i));
            end
        end
        z = z-1;
    end
    
    syms x;
    polynomial = 0;
    
    for i = 1:n
        tmp = 1;
            for j = 1:i
                tmp = tmp * (x - xinput(j));
            end
            polynomial = polynomial + Matrix(1,i)*tmp;
    end
    
    polynomial = polynomial + yinput(1);
    polynomial = simplify(polynomial);
    polynomial = matlabFunction(polynomial);
end