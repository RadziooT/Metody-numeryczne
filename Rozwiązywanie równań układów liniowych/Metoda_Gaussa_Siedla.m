clc
clear
close all

%N = input('Podaj wymiar macierzy A = ');
%
%A = zeros(N);
%b = zeros(N,1);
%
%disp('Podaj wartosci macierzy A wpisujac je wierszami od lewej do prawej');
%
%for i = 1:N
%    for j = 1:N
%    tmp = input('Podaj wartosc: ');
%    A(i,j) = tmp;
%    end
%end
%
%disp('Podaj wartosci macierzy b wpisujac je wierszami');
%
%for i = 1:N
%    tmp = input('Podaj wartosc: ');
%    b(i,:) = tmp;
%    end
%end
%X = zeros(N,1);
%Xn = zeros(N,1);
%g = zeros(height(b),1);
%h = zeros(size(A));
%k=1;
%eps = 1;
%Itmax = input('Podaj maksymalna liczbe iteracji = ');
%accuracy = input('Podaj wymagana dokladnosc = ');

%-------------Wartosci wpisane w celu przyspieszenia testowania kodu------------------
A = [-500, 100, 25; 4, 1100, 30; 10, 3, 200];
b = [15; 29; 7];
N = size(A);
Xn = zeros(N(1,1),1);
g = zeros(height(b),1);
h = zeros(size(A));
k=1;
eps = 1;
Itmax = 1000;
accuracy = 0.001;
%-------------Wartosci wpisane w celu przyspieszenia testowania kodu------------------

tic %rozpoczecie pomiaru czasu

for i = 1:size(A)
    g(i) = b(i)/A(i,i);
    for j = 1:size(A)
        if i == j
            h(i,j) = 0;
        else
            h(i,j) = -A(i,j)/A(i,i);
        end
    end
end

X = g;

while eps > accuracy

    for i = 1:N
        Xn(i) = g(i);
        %iteracja uzywajac elementow z tej samej iteracji ("Xn")
        if i ~= 1
            for j = 1:i-1
            Xn(i) = Xn(i) + h(i,j)*Xn(j);
            end
        end
        %iteracja uzywajac elementow z poprzedniej iteracji ("X")
        for j = i:N
            Xn(i) = Xn(i) + h(i,j)*X(j);
        end
    end

eps = check_accuracy(Xn,X);

X = Xn;

if(k > Itmax)
    break;
end
k = k+1;
end

t = toc; %koniec pomiaru czasu

disp(['Obliczenia zajely ',num2str(t),' s']);
disp(['Uzywajac dokladnosci rownej ',num2str(accuracy),' po ',num2str(k),' iteracjach wektor rozwiazan przybral wartosc rowna:']);
disp(X);
disp('Natomiast rozwiazanie uzywajac wbudowanej funkcji linsolve() wynosi:');
disp(linsolve(A, b));

function accuracy = check_accuracy(Xnew,X)
    MatrixDifference = Xnew - X;
    MatrixDifference = abs(MatrixDifference);
    accuracy = max(MatrixDifference);
end

