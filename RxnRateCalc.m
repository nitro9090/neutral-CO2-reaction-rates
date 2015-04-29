function [RxnRateVal] = RxnRateCalc(T,Tmin,Tmax,A,B,C,species1,species2,species3,Pos)
%This equation calculates the reaction rate based on the reaction rate
%constants listed in the neutralXsec file.
[~,X] = size(T);

    for Z = 1:X
        if T(Z) < Tmin(Pos) || T(Z) > Tmax(Pos)
            RxnRateVal(1,Z) = 0;
        else
            RxnRateVal(1,Z) = A(Pos)*(T(Z)/300)^B(Pos)*exp(-1*(C(Pos)/T(Z)))*species1*species2*species3;
        end
    end
end

