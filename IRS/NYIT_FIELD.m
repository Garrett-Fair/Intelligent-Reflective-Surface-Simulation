clear all, close all, clc;

%Creating NYIT FIELD
nyit(133,66) = 0;
i=1;
j = 18;

%Diag of N
for i=1:29 
    j=j+1; 
    nyit(i,j) = 1; 
end

%Bars of the N
nyit(1:29, 18) = 1;
nyit(1:29, 48) = 1;

%-------------------------------

%Y

%Creating diags of Y
j = 19; 

for i=33:46 
    j=j+1; 
    nyit(i,j) = 1; 
end

j = 47; 
for i=33:46 
    j=j-1; 
    nyit(i,j) = 1; 
end

%Creating bar of Y
nyit(46:66, 33) = 1;

%------------------------------

%I
nyit(70:97, 33) = 1;

nyit(70, (33-12):(33+12)) = 1;
nyit(97, (33-12):(33+12)) = 1;

%--------------------------

%T
%bar
nyit(105:132, 33) = 1;

%top
nyit(105, (33-13):(33+13)) = 1;

