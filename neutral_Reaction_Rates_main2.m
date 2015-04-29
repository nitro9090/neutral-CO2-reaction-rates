clc
clear

[~,Names,~] = xlsread('neutralXsec.xlsx','A2:A16');
[~,Species,~] = xlsread('neutralXsec.xlsx','B2:D16');
[rateconstants,~,~] = xlsread('neutralXsec.xlsx','F2:J16');

% Variables
Tmin = 300; % K, minimum temperature range
Tmax = 3000; % K, max of temperature range
Tstep = 50; % K, step size for temperature range
ArCO2ratio = 60; % 1 is 100% CO2
COPerc = .05; % percent, percent of neutral gas which is CO, divide by 2 to get the percent O2

%Density values, currently setup for an atmospheric DBD plasma
global eDens CO2IonDens ArDens CO2Dens MDens O3Dens CODens O2Dens ODens O2IonDens COIonDens

MDens = 2.44626702576664e19/(6.022*10^23);  % neutral density
eDens = 10^12/(6.022*10^23); %mol/cm^-3

ArDens = MDens*(1-ArCO2ratio); % mol/cm^-3
CO2Dens = MDens*ArCO2ratio*(1-COPerc);

O3Dens = 1.67*10^-11;  % Max value of 1.67*10^-11, based on the O3 production rate
CODens = COPerc*MDens*ArCO2ratio;  %  3.43*10^14/(6.022*10^23)  
O2Dens = CODens/2; %CODens/2

ODens = 5.7*10^-10;  % mol/cm^-3 the density of O needed for 5% conversion at 200 SCCM and 30 kHz in VADER 5.7*10^-10 

CO2IonDens = (CO2Dens+ArDens)/MDens*eDens; % CO2+
O2IonDens = O2Dens/MDens*eDens; % O2+
COIonDens = CODens/MDens*eDens; % CO+

RxnTime = 1;  % s, percentage of time within 1sec during which the neutral reactions are occurring 1=100% of the time

Ylimit = [10^-12,10^-2];

iDens = eDens; %cm^-3
nDens = 2.4462670257666400000e19; % cm^-3
T = Tmin:Tstep:Tmax;

% Constants (don't change)
A = rateconstants(:,3);
B = rateconstants(:,4);
C = rateconstants(:,5);
Tmin = rateconstants(:,1);
Tmax = rateconstants(:,2);

[~,numpts] = size(T);
[dataset,~] = size(Names);

X = 1;
Y = 1;
Z = 1;
Q = 0;

% walks through each of the reactions to determine their reaction rates 
while Q == 0
    % determines which species are reacting
    Species1 = SpeciesSort(char(Species(Y,1)));
    Species2 = SpeciesSort(char(Species(Y,2)));
    Species3 = SpeciesSort(char(Species(Y,3)));
    
    % Calculating the reaction rate if it is a charged particle reaction
    if strcmp(char(Species(Y,1)),'CO2plus') == 1 || strcmp(char(Species(Y,1)),'COplus') == 1 || strcmp(char(Species(Y,1)),'O2plus') == 1
        RxnRateVal1(:,Z) = RxnTime*RxnRateCalc(T,Tmin,Tmax,A,B,C,Species1,Species2,Species3,Y);
        if sum(RxnRateVal1(:,Z)) < Ylimit(1)
            RxnRateVal1(:,Z) = [];
            [dataset,~] = size(Names);
        else
            Names1(Z) = Names(Y);
            Z=Z+1;
        end
    % Calculating the reaction rate if the equation is a neutral reaction.
    else
        RxnRateVal2(:,X) = RxnTime*RxnRateCalc(T,Tmin,Tmax,A,B,C,Species1,Species2,Species3,Y);
        if sum(RxnRateVal2(:,X)) < Ylimit(1)
            RxnRateVal2(:,X) = [];
            Names(X) = [];
            [dataset,~] = size(Names);
        else
            Names2(X) = Names(Y);
            X=X+1;
        end
    end
    Y=Y+1;
    if Y > dataset
        Q = 1;
    end
end

%plots the data
set(0,'DefaultAxesColorOrder',[1 0 0;0 0 1;1 0 1;0 0 0],'DefaultAxesLineStyleOrder','-|--|:')

subplot(1,2,1)
semilogy(T,RxnRateVal1)
ylim(Ylimit)
legend(Names1)
subplot(1,2,2)
semilogy(T,RxnRateVal2)
legend(Names2)
%hold on
%semilogy(T,RxnRateVal(dataset,:),'+b','MarkerSize',2)
%hold off
ylim(Ylimit)

%saves the data to a file
Exporttxt( strcat('../neutral_gnuplotdata/neutralplots1.txt'), Names1,'T (K)',T,RxnRateVal1);
Exporttxt( strcat('../neutral_gnuplotdata/neutralplots2.txt'), Names2,'T (K)',T,RxnRateVal2);

