function [corr, x, corr2, x2] = calcOrient(dataz,datan,datae,baz)
% Calculate the normalized cross correlation and determine the orientation.
% original version was written by Dr. Ba Manh Le.
%
% x     = unknown orientation from the north determined by corr.
% corr  = normalized cross correlation.
% x2    = unknown orientation from the north determined by corr2.
% corr2 = second normalized cross correlation.
%
% Reference:
% J. C. Stachnik, A. F. Sheehan, D. W. Zietlow, Z. Yang, J. Collins, 
% A. Ferris (2012). Determination of New Zealand ocean bottom seismometer 
% orientation via Rayleigh-wave polarization. Seismological Research Letters,
% 83(4): 704–713. https://doi.org/10.1785/0220110128
%
% The speed is increased through two steps of circulation. The first step 
% is to find a coarse angle, and the second step is to get a precise angle.
% Updated 2022-10-25
% Yuechu Wu
% 12131066@mail.sustech.edu.cn


i = 0;
for ang_temp = 0:10:360
        rad_temp  = ang_temp * pi / 180;
        datar = cos(rad_temp) * datan + sin(rad_temp) * datae;
        i = i + 1;
        % second normalized cross correlation
        corrs2_temp(i)  = sum(datar .* dataz) / sum(dataz.^2);        
%         corrs_temp(i) = sum(datar .* dataz) / sqrt(sum(dataz.^2) * sum(datar.^2)); % normalized cross correlation
        angs_temp(i)  = ang_temp;
end

[~,ida_temp] = max(corrs2_temp); 
theta_coarse = angs_temp(ida_temp);

j = 0;
for ang = theta_coarse - 9 : theta_coarse + 9
        rad  = ang * pi / 180;
        datar = cos(rad) * datan + sin(rad) * datae;

        j = j + 1;

        % normalized cross correlation
        corrs(j) = sum(datar .* dataz) / sqrt(sum(dataz.^2) * sum(datar.^2)); 
        % second normalized cross correlation
        corrs2(j)  = sum(datar .* dataz) / sum(dataz.^2); 
        angs(j)  = ang;
end

[corr,ida] = max(corrs); 
x = baz-angs(ida);
if x < 0
    x = 360 + x;
end

[corr2, ida2]= max(corrs2); 
% second normalized cross correlation may < 1
if corr2 > 1
    corr2 = 1 / corr2;
end

x2 = baz-angs(ida2);
if x2 < 0
    x2 = 360 + x2;
end

return