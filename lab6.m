clear all
clc  
close all

%przepisy = readtable('przepisy.csv', 'VariableNamingRule', 'preserve');
przepisy = load('przepZkropka.mat');
przepisy = przepisy.przepisy1;
skladniki = {'Maka', 'Mieso', 'bialko', 'zoltko', 'olej','sól','woda','cebula','czosnek','przyprawy/zioła','ser biały','ciastka/bułka tarta','masło','śmietana','cukier/miód','mleko','galaretka/budyń','orzechy/nasiona','owoce','proszek do pieczenia/soda','kakao','jogurt','cytryna','skrobia','warzywa','ser','czekolada','drożdże','kawa','makaron/ryż/kasza'};
wybrane = {'Maka','woda','warzywa','ser','owoce'};

% Iteracja przez kolumny tabeli
for i = 1:width(przepisy)
    if isnumeric(przepisy{:, i}) % Sprawdzenie, czy kolumna jest numeryczna
        przepisy{isnan(przepisy{:, i}), i} = 0; % Zamiana NaN na 0
    end
end
sklad = przepisy(:,3:32);
sklad = table2array(sklad);
sklad = double(sklad);

wielkoscPunktow = 30;

%% dane oryginalne
% h = heatmap(skladniki,przepisy.Nazwa, sklad{:,:});

figure
h = heatmap(skladniki,przepisy.Nazwa, sklad);

d = pdist(sklad);

Z = linkage(d,'ward');

figure
dendrogram(Z);

k = 4; 
[idx, C] = kmeans(sklad,k);
[coeff, score, ~] = pca(sklad);

figure
scatter(score(:,1),score(:,2),wielkoscPunktow,idx,'filled');
xlabel('PCA 1');
ylabel('PCA 2');
title('Klasteryzacja dane oryginalne');
grid on;

%% dane zbinaryzowane

zbinSklad = sklad>0;
zbinSklad = double(zbinSklad);
zbinPrzepisy = przepisy;
%zbinPrzepisy(:,3:32) = zbinSklad;

figure
hBin = heatmap(skladniki,przepisy.Nazwa, zbinSklad);

dBin = pdist(zbinSklad,'euclidean');

Zbin = linkage(dBin,'complete');

figure
dendrogram(Zbin);
title('Dendrogram dane zbinaryzowane')

[idxBin, Cbin] = kmeans(sklad,k);
[coeffBin, scoreBin, ~] = pca(zbinSklad);

figure
scatter(scoreBin(:,1),scoreBin(:,2),wielkoscPunktow,idxBin,'filled');
xlabel('PCA 1');
ylabel('PCA 2');
title('Klasteryzacja dane zbinaryzowane');
grid on;

%% 5 składników

sklad5 = [sklad(:,1), sklad(:,2), sklad(:,19), sklad(:,25), sklad(:,26)];
przepisy5 = [przepisy(:,1), przepisy(:,2),przepisy(:,3), przepisy(:,4), przepisy(:,21), przepisy(:,27), przepisy(:,28)];
figure
h5 = heatmap(wybrane,przepisy.Nazwa, sklad5);

d5 = pdist(sklad5,'euclidean');

Z5 = linkage(d5,'complete');

figure
dendrogram(Z5);
title('Dendrogram dane dla 5 składników')

[idx5, C5] = kmeans(sklad5,k);
[coeff5, score5, ~] = pca(sklad5);

figure
scatter(score5(:,1),score5(:,2),wielkoscPunktow,idx5,'filled');
xlabel('PCA 1');
ylabel('PCA 2');
title('Klasteryzacja dane dla 5 składników');
grid on;

% Zad3 

%% a
de = pdist(sklad,'euclidean');
Ze = linkage(de,'complete');

dM = pdist(sklad,'cityblock');
ZM = linkage(dM,'complete');

figure
dendrogram(Ze);
title('Dendrogram odległość euklidesowa')

figure
dendrogram(ZM);
title('Dendrogram odległość Manhattan')

%% b

Zupgma = linkage(de,'average');
Zsingle = linkage(de,'single');
Zupgmc = linkage(de,'centroid'); 


figure
dendrogram(Ze)
title('Dendrogram połączenie complete')


figure
dendrogram(Zupgma)
title('Dendrogram połączenie UPGMA')

figure
dendrogram(Zsingle)
title('Dendrogram połączenie single')

figure
dendrogram(Zupgmc)
title('Dendrogram połączenie UPGMC')





