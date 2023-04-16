clc
clear
close all

A = [9 9 9; 26 2 3; -15 3 6];
y = [1,0,0];
y = y';
yn = y;

%----Ilosc iteracji--------
n = 8;
%--------------------------

for i = 1 : n
    if(i ~= n)
        yn = A*y;
        y = yn;
    else
        yn = A*y;
    end
end

for i = 1 : height(yn)
    yn(i,:) = yn(i,:)/y(i,:);
end

disp('Analizowana macierz')
disp(A);

disp('Nieunormowana wartość wektora własnego dla znalezionej wartości własnej')
disp(yn);

disp('Unormowana wartość wektora(norma długości) własnego dla znalezionej wartości własnej')
disp(norma_wektora(yn));

k = height(yn);
wektor_wlasny_normowany = zeros(k,1);
dzielnik = max(abs(yn));
for i = 1 : k
    wektor_wlasny_normowany(i,:) = 1/dzielnik .* yn(i,:);
end

disp('Unormowana wartość wektora(norma jedynki) własnego dla znalezionej wartości własnej')
disp(wektor_wlasny_normowany);


function wektor_unormowany = norma_wektora(wektor)
n = size(wektor);
wektor_unormowany = zeros(n(1),1);
for i = 1 : n 
    wektor_unormowany(i,:) = wektor(i,:)/norm(wektor);
end
end