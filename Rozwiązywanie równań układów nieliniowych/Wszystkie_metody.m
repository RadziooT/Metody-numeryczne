clc
clear
close all

%---------------------------------------------------
%-----------Radosław Tchórzewski grupa 6------------
%-----Rozwiązywanie układów równań nieliniowych-----
%---------------------------------------------------


syms x;
%----------Funkcja--------
f = 5 * sin(x) - cosh(x/pi) + log(10) - x^3 + exp(x);
%----------Granice przedzialu--------
a = 3.5;
b = 6;
%----------Dokladnosc--------
eps = 0.001;
%----------Maksymalna ilosc iteracji--------
itmax = 50;

%W glownym programie wywoluje dwie funkcje odpowiedzialne za obliczanie wynikow
%metod oraz formatowanie odpowiedzi w celu zwiekszenia jej czytelnosci
print(f,a,b,eps,itmax);
plot_graphs(f,a,b,eps,itmax);

%----------------------WYPISYWANIE WARTOSCI METOD-------------------
function print(funkcja,a,b,dokladnosc,itmax)
[wynik,n]=polowki_przedzialow(funkcja,a,b,dokladnosc,itmax);
fprintf('Szukana wartosc uzywajac metody polowienia przedzialow wynosi %f oraz zostala osiagnieta w %d iteracjach\n',wynik(length(wynik)),n);

[wynik,n]=sieczne(funkcja,a,b,dokladnosc,itmax);
fprintf('Szukana wartosc uzywajac metody siecznych wynosi %f oraz zostala osiagnieta w %d iteracjach\n',wynik(length(wynik)),n);

[wynik,n]=newton(funkcja,a,b,dokladnosc,itmax);
fprintf('Szukana wartosc uzywajac metody Newtona wynosi %f oraz zostala osiagnieta w %d iteracjach\n',wynik(length(wynik)),n);
end

%----TWORZENIE WYKRESOW WYZUALIZUJACYCH PRZEBIEG METODY----
function plot_graphs(funkcja,a,b,dokladnosc,itmax)
    figure
    [wynik, ~]=polowki_przedzialow(funkcja,a,b,dokladnosc,itmax);
    x = linspace(a, b);
    ftemp = matlabFunction(funkcja);
    plot(x,ftemp(x));
    hold on;
    grid on;
    scatter(wynik,ftemp(wynik),'s','filled');
    legend('Badana funkcja f(x)','Kolejne przybliżenia metody');
    title('Metoda polowienia przedzialow');

    figure
    [wynik, ~]=sieczne(funkcja,a,b,dokladnosc,itmax);
    x = linspace(a, b);
    plot(x,ftemp(x));
    hold on;
    grid on;
    scatter(wynik,ftemp(wynik),'s','filled');
    legend('Badana funkcja f(x)','Kolejne przybliżenia metody');
    title('Metoda siecznych');

    figure
    [wynik, ~]=newton(funkcja,a,b,dokladnosc,itmax);
    x = linspace(a, b);
    plot(x,ftemp(x));
    hold on;
    grid on;
    scatter(wynik,ftemp(wynik),'s','filled');
    legend('Badana funkcja f(x)','Kolejne przybliżenia metody');
    title('Metoda Newtona');

end

%----------------------METODA POLOWIENIA PRZEDZIALOW-------------------
function [wektorX,n] = polowki_przedzialow(funkcja,a,b,eps,itmax)
    funkcja = matlabFunction(funkcja);
    n = 1;
    
%pierwsza wartosc zmiennej x z poprzedniej iteracji zostaje wpisana 
%"na sztywno" w celu wykonania conajmniej jednej iteracji
    x = (a+b)/2;
    xlast = x + 10;
    
    while (n<itmax)%kryterium maksymalnej ilosci iteracji
        x = (a+b)/2;%aktualnie badany punkt
        wektorX(n)=x;%zapisywanie w wektorze w celu stworzenia wykresu
        if (abs(x - xlast)<eps)%kryterium dokladnosci
            break;
        elseif(funkcja(a)*funkcja(x)<0)
            b = x;
        else
            a = x;
        end
        xlast = x;
        n = n + 1;
    end
    end

%----------------------METODA SIECZNYCH-------------------
function [wektorX,n]=sieczne(f,a,b,eps,itmax)
    fbis = diff(f,2);
    f = matlabFunction(f);
    fbis = matlabFunction(fbis);
    n = 1;

%pierwsza wartosc zmiennej x z poprzedniej iteracji zostaje wpisana "na
%sztywno" w celu wykonania conajmniej jednej iteracji
    x = a - (f(a)/(f(b)-f(a)))*(b-a);
    xlast = x + 10;

    if((f(a)*fbis(a))>0)
        x = a - (f(a)/(f(b)-f(a)))*(b-a);
        if(abs(x - xlast)<eps)%kryterium dokladnosci
            wektorX(n)=x;
            return;
        end
        b = x;
        while (n<itmax)%kryterium maksymalnej ilosci iteracji
            x = a - (f(a)/(f(b)-f(a)))*(b-a);
            wektorX(n)=x;%zapisywanie w wektorze w celu stworzenia wykresu
            if(abs(x - xlast)<eps)%kryterium dokladnosci
                break;
            end
            b = x;
            xlast = x;
            n = n + 1;
        end
    else
        x = a - (f(a)/(f(b)-f(a)))*(b-a);
        if(abs(x - xlast)<eps)%kryterium dokladnosci
            wektorX(n)=x;
            return;
        end
        a = x;
        while (n<itmax)%kryterium maksymalnej ilosci iteracji
            x = a - (f(a)/(f(b)-f(a)))*(b-a);
            wektorX(n)=x;%zapisywanie w wektorze w celu stworzenia wykresu
            if(abs(x - xlast)<eps)%kryterium dokladnosci
                break;
            end
            a = x;
            xlast = x;
            n = n + 1;
        end
    end
    end

%----------------------METODA NEWTONA-------------------
function [wektorX,n]=newton(funkcja,a,b,eps,itmax)
fprim = diff(funkcja,1);
fbis = diff(funkcja,2);
f = matlabFunction(funkcja);
fprim = matlabFunction(fprim);
fbis = matlabFunction(fbis);
n = 1;

if (f(a)*fbis(a)>0)
    xlast = a;
elseif (f(b)*fbis(b)>0)
    xlast = b;
end

x = xlast - f(xlast)/fprim(xlast);
    if(abs(x - xlast)<eps)%kryterium dokladnosci
        wektorX(n)=x;
        return;
    end

    while(n<itmax)%kryterium maksymalnej ilosci iteracji
        x = xlast - f(xlast)/fprim(xlast);
        wektorX(n)=x;%zapisywanie w wektorze w celu stworzenia wykresu
        if(abs(x - xlast)<eps)%kryterium dokladnosci
            break;
        end
        xlast = x;
        n = n + 1;
    end
end