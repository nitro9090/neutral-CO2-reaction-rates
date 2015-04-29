function [ SpeciesDens ] = SpeciesSort(Species)

global eDens CO2IonDens ArDens CO2Dens MDens O3Dens CODens O2Dens ODens O2IonDens COIonDens

if isempty(Species) == 1
    SpeciesDens = 1;
elseif strcmp(Species,'O') == 1
    SpeciesDens = ODens;
elseif strcmp(Species,'M') == 1
    SpeciesDens = MDens;
elseif strcmp(Species,'CO') == 1
    SpeciesDens = CODens;
elseif strcmp(Species,'CO2') == 1
    SpeciesDens = CO2Dens;
elseif strcmp(Species,'O2') == 1
    SpeciesDens = O2Dens;
elseif strcmp(Species,'CO2plus') == 1
    SpeciesDens = CO2IonDens;
elseif strcmp(Species,'e') == 1
    SpeciesDens = eDens ;
elseif strcmp(Species,'O3') == 1
    SpeciesDens = O3Dens;
elseif strcmp(Species,'O2plus') == 1
    SpeciesDens = O2IonDens;
elseif strcmp(Species,'COplus') == 1
    SpeciesDens = COIonDens;
else
    SpeciesDens = 1;
    fprintf('%s is missing from the species sort function\n',Species)
end

end

