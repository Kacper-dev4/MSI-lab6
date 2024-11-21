clear all
clc

przepisy = readtable('przepisy.csv', 'VariableNamingRule', 'preserve');
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

%% dane zbinaryzowane

zbinSklad = sklad>0;
zbinSklad = double(zbinSklad);
zbinPrzepisy = przepisy;
%zbinPrzepisy(:,3:32) = zbinSklad;

figure
hBin = heatmap(skladniki,przepisy.Nazwa, zbinSklad);

%% 5 składników




