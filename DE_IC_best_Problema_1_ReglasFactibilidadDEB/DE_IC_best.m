close all ;
clc;
%rng default;

% PROBLEMA #1
%DE tipo DE/best/1/bin 

%Matriz para graficar factibles
MatGraFac=[];

% 3 variables
%   x1    x2   x3  
%    N    D    d 
lb=[2.00 0.25 0.05];      %Cota inferior de las variables 
ub=[15.0 1.30 2.00];      %Cota superior de las variables 

% Valores de los parametros DE
n = 100;            % numero de individuos
d = 3;              % numero de variables
cr = 0.9;           % tasa de cruzamiento
F = 0.5;            
maxeval=35000;      % Numero maximo de evaluaciones
counteval=0;        % Contador de evaluaciones

% Inicializacion de la poblacion y evaluacion de su fitness
x = zeros(n,d);
fitness = zeros(n,3);
for i=1:n
    x(i,:) = lb + (ub-lb).*rand(1,d);
    %fitness(i) = fob(x(i,:));
    % objf        sumpen       restriccionesg g1 g2 g3 g4
    [fitness(i,1) fitness(i,2) fitness(i,4:7)]=fob(x(i,:));
    %indice de x
    fitness(i,3)=i;
    counteval=counteval+1;
end

% Extraccion de factibles e infactibles
matfac=[];
matinfac=[];
for i=1:n
    if fitness(i,2)>0 %infactibles
        matinfac=[matinfac; fitness(i,:)];
    else %factibles
        matfac=[matfac; fitness(i,:)];
    end
end 

% Evaluacion del minimo
[fmf cmf]=size(matfac); %tamaño matriz factible
[fmi cmi]=size(matinfac); %tamaño matriz factible
if fmf>0
    [minim indexmin]=min(matfac(:,1));
    fmin=matfac(indexmin,1);
    index=matfac(indexmin,3);
else
    [minimr indexmi]=min(matinfac(:,2)); % con el menor numero de restricciones
    Mmatinfac=[]; %matriz para vaciar los de menores restricciones
    for i=1:fmi %extrae todos los de menores restricciones 
        if matinfac(i,2)==minimr 
            Mmatinfac=[Mmatinfac; matinfac(i,:)];
        end
    end 
    [minim indexmin]=min(Mmatinfac(:,1)); % obtiene aquel con el minimo de la funcion objetivo
    fmin=Mmatinfac(indexmin,1);
    index=Mmatinfac(indexmin,3);
end

% Mejor Individuo
best = x(index,:);

t=1;
while counteval <= maxeval
    for i=1:n
        % Mutacion
        % Seleccion de tres vectores aleatorios de la poblacion
        x1 = best;   
        x2 = x(randi(n,1),:);   
        x3 = x(randi(n,1),:);

        % Calculo del vector mutante
        v = x1 + F*(x2-x3);

        % Acotar el vector mutante dentro de los limites
        for j=1:d
            if v(j) < lb(j)
                v(j) = lb(j);
            end
            if v(j) > ub(j)
                v(j) = ub(j);
            end
        end

        % Cruza
        % Prueba de probabilidades de ocurrencia de cruzamiento
        Kcr = rand(1,d) < cr;   

        % Calcula el Trial
        u = x(i,:).*(1-Kcr) + v.*Kcr;

        % Seleccion
        % Evalua el trial
        %fnew = fob(u);
        [fnew(1,1) fnew(1,2) fnew(1,4:7)]=fob(u);
        %indice de x
        fnew(1,3)=i; 
        counteval=counteval+1;

        % Prueba si el vector trial es mas apto que el individuo
        [faux(1,1) faux(1,2) faux(1,4:7)]=fob(x(i,:));
        %indice de x
        faux(1,3)=i; 
        if fnew(1,2) <= faux(1,2)%Evalua numero restricciones
            if fnew(1,1) < faux(1,1) % Evalua Fitness
                x(i,:) = u;
                fitness(i,:) = fnew(1,:);
            end
        end
        counteval=counteval+1;
    end

    % Actualiza el mejor individuo
    % Extraccion de factibles e infactibles
    matfac=[];
    matinfac=[];
    for i=1:n
        if fitness(i,2)>0 %infactibles
            matinfac=[matinfac; fitness(i,:)];
        else %factibles
            matfac=[matfac; fitness(i,:)];
        end
    end 

    % Evaluacion del minimo
    [fmf cmf]=size(matfac); %tamaño matriz factible
    [fmi cmi]=size(matinfac); %tamaño matriz factible
    if fmf>0
        [minim indexmin]=min(matfac(:,1));
        fmin=matfac(indexmin,1);
        index=matfac(indexmin,3);
    else
        [minimr indexmi]=min(matinfac(:,2)); % con el menor numero de restricciones
        Mmatinfac=[]; %matriz para vaciar los de menores restricciones
        for i=1:fmi %extrae todos los de menores restricciones 
            if matinfac(i,2)==minimr 
                Mmatinfac=[Mmatinfac; matinfac(i,:)];
            end
        end 
        [minim indexmin]=min(Mmatinfac(:,1)); % obtiene aquel con el minimo de la funcion objetivo
        fmin=Mmatinfac(indexmin,1);
        index=Mmatinfac(indexmin,3);
    end
    best = x(index,:);    

    % Guarda iteracion y datos desde que se encontro un mejor factible
    if fmf>0 %Si las filas de la matriz factible son mayores a 0
        MatGraFac=[MatGraFac; t fmin];
    end
    
    % Resultados de cada iteracion 
    if t==1 
        disp(sprintf('Iteración    Mejor Particula    Función Objetivo')); 
    end 
    disp(sprintf('%8g    %8g              %8.6f       %8g',t,index,fmin));
    t=t+1; %actualiza la iteracion
end  