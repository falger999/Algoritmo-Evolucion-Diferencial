clear all; 
MatMejor=[];% indice_1,FitnessBest_2,best_3_5,Restricciones_6_9,SumaRestricciones_10,MediaFitness_11,DesviacionEstFitness_12   
arcellMatGra={}; %Matriz de celdas para guardar datos para graficar: corrida_1,matrizdatosgraficar_2 

for ic=1:31 % 30corridas
    %-------------------------INICIA CORRIDA----------------------------
    DE_IC_best;
    %-------------------------FIN CORRIDA---------------------------
    Bestc=best; % El Mejor de esa corrida
    format long;
    FitnessBestc=fmin; % El fitness del mejor individuo
    grestricBest=fitness(index,4:7); %g restricciones del mejor
    sumrestricBest=fitness(index,2); %Cuantas restricciones cumplio/incumplio el mejor
    MediaFitness=mean(fitness(:,1)); % La media de los fitness de la poblacion
    DSFitness=std(fitness(:,1)); % La Desviacion Estandar de los fitness de la poblacion
    MatMejor=[MatMejor; ic FitnessBestc Bestc grestricBest sumrestricBest MediaFitness DSFitness];
    arcellMatGra(ic,:)={ic MatGraFac};
end
save('MatrizCorridas.mat','MatMejor'); %Guardar datos
Mediana = median(MatMejor(:,2)); %obtener la mediana
for ix=1:31
    if MatMejor(ix,2)== Mediana
        indiceMediana=MatMejor(ix,1);
        break;
    end
end

%Datos del mejor de las 30 corridas
[min30corr indexm30c]= min(MatMejor(:,2)); %obtener el mejor
datosMejor30cor=MatMejor(indexm30c,:);% indice_1,FitnessBest_2,best_3_5,Restricciones_6_9,SumaRestricciones_10,MediaFitness_11,DesviacionEstFitness_12
save('datosMejor30cor.mat','datosMejor30cor'); %Guarda esos datos

%Graficar la mediana
 datosCorMed = cell2mat(arcellMatGra(indiceMediana,2)); %Datos de la corrida que se encuentra en la mediana
 save('CorridaMedia.mat','datosCorMed'); %Guarda esos datos
 x=datosCorMed(:,1);
 y=datosCorMed(:,2);
 plot(x,y);
 

