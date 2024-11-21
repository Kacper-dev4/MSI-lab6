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

scatter(score(:,1),score(:,2),50,idx,'filled');
xlabel('PCA 1');
ylabel('PCA 2');
title('Klasteryzacja k-means na PCA');
grid on;

%% dane zbinaryzowane

zbinSklad = sklad>0;
zbinSklad = double(zbinSklad);
zbinPrzepisy = przepisy;
%zbinPrzepisy(:,3:32) = zbinSklad;

figure
hBin = heatmap(skladniki,przepisy.Nazwa, zbinSklad);

dBin = pdist(zbinSklad);

Zbin = linkage(dBin,'ward');

figure
dendrogram(Zbin);

[idxBin, Cbin] = kmeans(sklad,k);
[coeffBin, scoreBin, ~] = pca(zbinSklad);

scatter(scoreBin(:,1),scoreBin(:,2),50,idxBin,'filled');
xlabel('PCA 1');
ylabel('PCA 2');
title('Klasteryzacja k-means na PCA');
grid on;

%% 5 składników

sklad5 = [sklad(:,1), sklad(:,2), sklad(:,19), sklad(:,25), sklad(:,26)];

figure
h5 = heatmap(wybrane,przepisy.Nazwa, sklad5);

d5 = pdist(sklad5);

Z5 = linkage(d5,'ward');

figure
dendrogram(Z5);


[idx5, C5] = kmeans(sklad5,k);
[coeff5, score5, ~] = pca(sklad5);

scatter(score5(:,1),score5(:,2),50,idx5,'filled');
xlabel('PCA 1');
ylabel('PCA 2');
title('Klasteryzacja k-means na PCA');
grid on;



