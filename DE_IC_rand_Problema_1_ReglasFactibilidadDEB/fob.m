function [objf sumpen grestr]=fob(x) 
  
% Función Objetivo (Minimizacion) 
of=((x(1))+2)*((x(2))*((x(3))^2)) ;

  
% Restricciones
c0=[]; 
c0(1)=1-((((x(2))^3)*(x(1)))/(71785*((x(3))^4))); %g1
c0(2)=(((4*((x(2))^2))-((x(3))*(x(2))))/(12566*(((x(2))*((x(3))^3))-(((x(3))^4)))))+(1/(5108*((x(3))^2)))-1; %g2
c0(3)=1-((140.45*(x(3)))/((((x(2))^2))*(x(1)))); %g3
c0(4)=(((x(2))+((x(3))))/(1.5))-1; %g4

% Definiendo Penalizacion para cada restriccion 
for i=1:length(c0) 
    if c0(i)>0 
        c(i)=1; 
    else 
        c(i)=0; 
    end 
end 
objf=of;
sumpen=sum(c);
grestr=c0;

% penalty=10000;           % Penalizacion por cada restriccion violada
% f=of+penalty*sum(c);     % Funcion de fitness con suma de penalizaciones