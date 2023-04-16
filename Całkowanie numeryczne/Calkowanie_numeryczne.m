clc
clear
close all

%-----------
%ilosc przedzialow
n = 124;
%-----------

%---------------------------------------------------------------
%calka liczona dokladnie metoda symboliczna
syms x;
f = [cos(x),1/(1+x^2),8/x];
granice = [pi/2,pi/6;1,0;-3,-15];
for i = 1:3
   intf = int(f(i));
   fprintf('Zadana zostala funkcja o wzorze f(x) = %s\n',f(i));
   fprintf('Jej calka obliczona metoda symboliczna posiada wzor: %s\n',intf);
   fprintf('Jej granice wynosza odpowiednio gorna: %f, dolna: %f\n',granice(i,1),granice(i,2));
   fprintf('A wartosc calki wynosi %f\n\n',int(f(i),granice(i,2),granice(i,1)));
end


%---------------------------------------------------------------
%liczenie calki metoda prostokatow
fprintf('\nMetoda prostokatow:\n');
for j = 1:3
   funkcja = f(j);
   funkcja = matlabFunction(funkcja);
   dx = (granice(j,1)-granice(j,2))/n;
   wartosc = 0;
   for i = 1:n
      wartosc = wartosc + funkcja(granice(j,2)+i*dx);
   end
   wartosc = dx*wartosc;
   dokladnosc = abs((wartosc-(int(f(j),granice(j,2),granice(j,1))))/(int(f(j),granice(j,2),granice(j,1))))*100;
   bezwgledny = abs(wartosc-(int(f(j),granice(j,2),granice(j,1))));
   fprintf('Wartosc funkcji nr %i wynosi %f\n',j,wartosc);
   fprintf('Blad wzgledny wynosi %f%% a blad bezwgledny wynosi %f\n\n',dokladnosc,bezwgledny);
end


%---------------------------------------------------------------
%liczenie calki metoda trapezow
fprintf('\nMetoda trapezow:\n');
for j = 1:3
   funkcja = f(j);
   funkcja = matlabFunction(funkcja);
   dx = (granice(j,1)-granice(j,2))/n;
   wartosc = (funkcja(granice(j,2)) + funkcja(granice(j,1)))/2;
   for i = 1:n-1
      wartosc = wartosc + funkcja(granice(j,2)+i*dx);
   end
   wartosc = dx*wartosc;
   dokladnosc = abs((wartosc-(int(f(j),granice(j,2),granice(j,1))))/(int(f(j),granice(j,2),granice(j,1))))*100;
   bezwgledny = abs(wartosc-(int(f(j),granice(j,2),granice(j,1))));
   fprintf('Wartosc funkcji nr %i wynosi %f\n',j,wartosc);
   fprintf('Blad wzgledny wynosi %f%% a blad bezwgledny wynosi %f\n\n',dokladnosc,bezwgledny);
end


%-------------------------------------------------------------------
%liczenie calki metoda Simpsona
fprintf('\nMetoda Simpsona:\n');
for j = 1:3
   funkcja = f(j);
   funkcja = matlabFunction(funkcja);
   dx = (granice(j,1)-granice(j,2))/n;
   wartosc = funkcja(granice(j,2)) + funkcja(granice(j,1));
   parzyste = 0;
   nieparzyste = 0;
   for i = 1:n-1
      xi=granice(j,2)+(i*dx);
      if (mod(i,2) == 0)
         parzyste = parzyste + funkcja(xi);
      else
         nieparzyste = nieparzyste + funkcja(xi);
      end
   end
   wartosc = wartosc + 4*nieparzyste + 2*parzyste;
   wartosc = (dx/3)*wartosc;
   dokladnosc = abs((wartosc-(int(f(j),granice(j,2),granice(j,1))))/(int(f(j),granice(j,2),granice(j,1))))*100;
   bezwgledny = abs(wartosc-(int(f(j),granice(j,2),granice(j,1))));
   fprintf('Wartosc funkcji nr %i wynosi %f\n',j,wartosc);
   fprintf('Blad wzgledny wynosi %f%% a blad bezwgledny wynosi %f\n\n',dokladnosc,bezwgledny);
end


%-------------------------------------------------------------------
%liczenie calki metoda prostokatow uzywajac kryterium dokladnosci
fprintf('\nMetoda prostokatow:\n');
for j = 1:3
   dokladnosc = 1;
   wartosc = 0;
   n = 1;
   while dokladnosc > 0.1
   funkcja = f(j);
   funkcja = matlabFunction(funkcja);
   dx = (granice(j,1)-granice(j,2))/n;
   wartosc = 0;
   for i = 1:n
      wartosc = wartosc + funkcja(granice(j,2)+i*dx);
   end
   wartosc = dx*wartosc;
   n = n+1;
   dokladnosc = abs((wartosc-(int(f(j),granice(j,2),granice(j,1))))/(int(f(j),granice(j,2),granice(j,1))))*100;
   end
   fprintf('Wartosc funkcji nr %i wynosi %f osiagajac zadana dokladnosc w %d przedzialach\n',j,wartosc,n-1);
end


%-------------------------------------------------------------------
%liczenie calki metoda trapezow uzywajac kryterium dokladnosci
fprintf('\nMetoda trapezow:\n');
for j = 1:3
   dokladnosc = 1;
   n = 1;
   funkcja = f(j);
   funkcja = matlabFunction(funkcja);
   while dokladnosc > 0.1
   dx = (granice(j,1)-granice(j,2))/n;
   wartosc = (funkcja(granice(j,2)) + funkcja(granice(j,1)))/2;
   for i = 1:n-1
      wartosc = wartosc + funkcja(granice(j,2)+i*dx);
   end
   wartosc = dx*wartosc;
   n = n+1;
   dokladnosc = abs(abs(int(f(j),granice(j,2),granice(j,1))-wartosc)/int(f(j),granice(j,2),granice(j,1))*100);
   end
   fprintf('Wartosc funkcji nr %i wynosi %f osiagajac zadana dokladnosc w %d przedzialach\n',j,wartosc,n-1);
end


%-------------------------------------------------------------------
%liczenie calki metoda Simpsona uzywajac kryterium dokladnosci
fprintf('\nMetoda Simpsona:\n');
for j = 1:3
   dokladnosc = 1;
   n = 2;
   funkcja = f(j);
   funkcja = matlabFunction(funkcja);
   while dokladnosc > 0.1
   dx = (granice(j,1)-granice(j,2))/n;
   wartosc = funkcja(granice(j,2)) + funkcja(granice(j,1));
   parzyste = 0;
   nieparzyste = 0;
   for i = 1:n-1
      xi=granice(j,2)+(i*dx);
      if (mod(i,2) == 0)
         parzyste = parzyste + funkcja(xi);
      else
         nieparzyste = nieparzyste + funkcja(xi);
      end
   end
   wartosc = wartosc + 4*nieparzyste + 2*parzyste;
   wartosc = (dx/3)*wartosc;
   n = n+2;
   dokladnosc = abs(abs(int(f(j),granice(j,2),granice(j,1))-wartosc)/int(f(j),granice(j,2),granice(j,1))*100);
   end
   fprintf('Wartosc funkcji nr %i wynosi %f osiagajac zadana dokladnosc w %d przedzialach\n',j,wartosc,n-2);
end