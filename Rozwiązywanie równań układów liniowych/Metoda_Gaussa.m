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

tic %rozpoczecie pomiaru czasu

%-------------Wartosci wpisane w celu przyspieszenia testowania kodu------------------
A = [-5, 100, 25; 4, 11, 30; 10, 3, 2];
b = [15; 29; 7] ;
%-------------Wartosci wpisane w celu przyspieszenia testowania kodu------------------

Answer = zeros(size(b));
k = 2;
QuitCondition = true;
Ab = [A b];
N = height(Ab);

[tmp,x] = max(Ab(:,1));

%sprawdzanie czy pierwsza kolumna posiada conajmniej jedna wartosc rozna od zera
for i = 1:N
    if A(i,1) ~= 0
        QuitCondition = false;
    end
end

if QuitCondition == true
    disp('Wartosci pierwszej kolumny sa rowne 0 wiec uklad nie posiada jednoznacznego rozwiazania');
    return
end

if x ~= 1
    Ab = swap_row(Ab,1,x);
end

for j=1:(size(Ab)-1)
    for i = k:height(Ab)
        multiplier = Ab(i, j) / Ab(j, j);
        Ab(i,:) = Ab(i, :) - multiplier * Ab(j, :);
    end
k = k+1;
end

i = N;
for j=N:-1:1
        if i == N
            Answer(i) = Ab(i,j+1)/Ab(i,j);
        else
            Answer(i) = Ab(i,N+1);
            for z = i+1:N
                Answer(i) = Answer(i) - Answer(z) * Ab(i,z);
            end
        Answer(i) = Answer(i)/Ab(i,j);
        end
    i = i-1;
end

t = toc; %koniec pomiaru czasu

disp(['Obliczenia zajely ',num2str(t),' s']);
disp('Podana macierz A:');
disp(A);
disp('Podana macierz b:');
disp(b);
disp('Podany uklad rownan ma rozwiazanie wynoszace:');
disp(Answer);
disp('Natomiast rozwiazanie uzywajac wbudowanej funkcji linsolve() wynosi:');
disp(linsolve(A, b));

function SwappedMatrix = swap_row(A,j,k)
tmp = zeros(length(A));
for i = 1:length(A)
    tmp(j,i) = A(j,i);
    A(j,i) = A(k,i);
    A(k,i) = tmp(j,i);
end
SwappedMatrix = A;
end