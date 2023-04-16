clc
clear
close all

A=[1 1 1; 1 2 3; 1 3 6];
y0=[1;0;0];
n=3;
wektor=y0;
y=zeros(n,n+1);
C=zeros(n,n);

y(:,1)=y0;

for i=2:(n+1)
    b=A*wektor;
    y(:,i)=b;
    wektor=b;
end

d=-y(:,n+1);

for i=1:n
       C(:,i)=y(:,n+1-i);
end

p=C^-1*d;

krok_wykresu=1000;
x=linspace(-1,8,krok_wykresu);

f=x.^3+p(n-2).*x.^2+p(n-1).*x+p(n);

plot(x,f);
xlabel('Wartość lambda');
ylabel('Wartość funkcji');
title('Wykres funkcji utworzonej przez wartości własne macierzy A');
grid on;
grid("minor");

disp('Badana macierz');
disp(A);

disp('Wartości własne uzyskane za pomocą wbudowanej funkcji eigenvalues');
wartosci_wlasne = eig(A);
disp(wartosci_wlasne);

disp('Wartości własne uzyskane za pomocą wbudowanej funkcji eigenvectors');
[x,lambda] = eig(A);
disp(lambda);

disp('Wektory własne nieunormowane otrzymane za pomocą eigenvectors');
disp(x);

g = zeros(n,n);
wektor_wlasny = zeros(n,n);

for i = 1:n
    g(n,i) = 1; 
    for k=(n-1):-1:1
        g(k, i) = lambda(i,i) * g(k+1,i) + p(n-k) * g(n,i);
    end
end 

disp('Wektory własne macierzy A obliczone za pomocą metody Kryłowa');
for i = 1 : n 
    for j = 1 : n
        suma = 0;
        for k = 1 : n
            suma = suma + g(k,j) * y(i,k);
        end
        wektor_wlasny(i,j) = suma;
    end
end 

disp(wektor_wlasny);

disp('Unormowane wektory własne');
disp(norma_wektora(wektor_wlasny));


function wektor_unormowany = norma_wektora(wektor)
n = size(wektor);
wektor_unormowany = zeros(n(1),n(1));
for i = 1 : n 
    wektor_unormowany(:,i) = wektor(:,1)/norm(wektor(:,1));
end
end