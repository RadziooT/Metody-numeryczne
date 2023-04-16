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

%-------------Wartosci wpisane w celu przyspieszenia testowania kodu------------------
A = [1, 2, -1, -5; 50, 2, 1, 0; 0, 0, 10,0;1, 1, 1, 10];
b = [15; 29; 7; 1] ;
%-------------Wartosci wpisane w celu przyspieszenia testowania kodu------------------

tic %rozpoczecie pomiaru czasu

Adt = transposition(complement_matrix(A));
Det = determinant(A);
tmp = Adt/Det;
Result = tmp * b;

t = toc; %koniec pomiaru czasu

disp(['Obliczenia zajely ',num2str(t),' s']);
disp('Rozwiazaniem rownania jest wektor');
disp(Result);
disp('Natomiast rozwiazanie uzywajac wbudowanej funkcji linsolve() wynosi:');
disp(linsolve(A, b));

function Ad = complement_matrix(A)
n = size(A);
k = height(A);
Ad = zeros(n);
for i = 1:n
    for j = 1:k
        Atmp = A;
        Atmp(i,:) = [];
        Atmp(:,j) = [];
        Ad(i,j) = (-1)^(i+j)*determinant(Atmp);
    end
end
end

function A = transposition(A)
n = size(A);
k = height(A);
B = zeros(n);
for i = 1:n
    for j = 1:k
        if (i > j)
            B(i,j) = A(j,i);
            A(j,i) = A(i,j);
            A(i,j) = B(i,j);
        end
    end
end
end

function det = determinant(A)
det = 0;
N = size(A);
if N(1,1) == 2
    det = determinant2by2(A);
else
for i = 1:1
    for j = 1:N
        B = A;
        B(i,:) = [];
        B(:,j) = [];
        det = det + A(i,j) * (-1)^(i+j) * determinant(B);
    end
end
end
end

function det = determinant2by2(A)
det = A(1,1)*A(2,2)-A(1,2)*A(2,1);
end