%Improving dtft process by adding phase
clear all, close all, clc;


f = 5e9; %5GHz
spd_light = 3e8; %m/s
k = 2*pi*f/spd_light; %constant
lambda = spd_light/f; %wavelength.  An ideal situation is where the points sources should be lambda/2 away from each other on the 
                      %IRS. .03m in our case. Assume 1mx1m IRS, so 1/.03 = 33 sources along x and y


%CREATING IRS AND OBSERVATION SURFACE
irs_Nx = 33; %How many elements are in each x and y direction
irs_Ny = 33;
%x, y, and z componenet of each element in the IRS
z_irs = 0;
x_irs = linspace(-0.5, 0.5, irs_Nx);
y_irs = linspace(-0.5, 0.5, irs_Ny);

%x, y, and z component of the observation surface 
obs_Nx = 133;
obs_Ny = 66;
z_obs = 5;
x_obs = linspace(-2, 2, obs_Nx);
y_obs = linspace(-1, 1, obs_Ny);


%Creating Delta Function to feed through IRS
delta=zeros(33,33);
delta(17,17)=1;



%top left 
s1(133,66) = 0;
s1(20:22, 10:15) = 1;

s1


%GETTING OUR IMPULSE RESPONSE
    %Iterating over the observation surface
for ix = 1:length(x_obs)
    for iy = 1:length(y_obs)
        for iz = 1:length(z_obs)
            imp_res(ix,iy,iz) = 0; %Creating a field and setting it to zero
            %Start iterating over the IRS surface
            for iix = 1:length(x_irs)
                for iiy = 1:length(y_irs)
                    for iiz =1:length(z_irs)        
                        %Add each contribution to the field
                        R = sqrt( (x_irs(iix) - x_obs(ix))^2 + (y_irs(iiy) - y_obs(iy))^2 + (z_irs(iiz) - z_obs(iz))^2 ); %Distance from element on IRS to element of Obs.
                        greenF = exp(-1j*k*R)/R;
                        imp_res(ix,iy,iz) = imp_res(ix,iy,iz) + greenF*delta(iix,iiy); 

                    end
                end
            end
        end
    end
end



kx=linspace(-.35*k,.35*k,125); %Changing the coefficients in front of k will drastically change your results
ky=kx;
%DTFT of h and s
for ikx=1:length(kx)
    for iky=1:length(ky)
        H(ikx,iky) = 0; %Impulse Response
        S1(ikx,iky) = 0;
        for ix=1:obs_Nx
            for iy=1:obs_Ny      
                H(ikx,iky) = H(ikx,iky) + imp_res(ix,iy)*exp(-1j*(kx(ikx)*x_obs(ix)+ky(iky)*y_obs(iy)) );
                S1(ikx,iky) = S1(ikx,iky) + s1(ix,iy)*exp(-1j*(kx(ikx)*x_obs(ix)+ky(iky)*y_obs(iy)) );
            end
        end
        
    end
end


%   subplot(4,1,1)
%   mesh(abs(S5))
%   title('S')
%   
%   subplot(4,1,2)
%   mesh(abs(H))
%   title('H')


%R = S/H according to our process
S1_OVER_H = S1./H;



%Inverse DTFT of S/H
for ix=1:irs_Nx
    for iy=1:irs_Ny
        r1(ix,iy) = 0;
        for ikx=1:length(kx)
            for iky=1:length(ky)
                r1(ix,iy) = r1(ix,iy) + S1_OVER_H(ikx,iky)*exp(1j*(kx(ikx)*x_irs(ix)+ky(iky)*y_irs(iy)) );
            end
        end
    end
end


%sanity check
%putting r(x,y) back into my system should give me back my s(x,y)
for ix = 1:length(x_obs)
    for iy = 1:length(y_obs)
        for iz = 1:length(z_obs)
            sanity1(ix,iy,iz) = 0; %Creating a field and setting it to zero
            %start iterating over the IRS surface
            for iix = 1:length(x_irs)
                for iiy = 1:length(y_irs)
                    for iiz =1:length(z_irs)
                        %Add each contribution to the field
                        R = sqrt( (x_irs(iix) - x_obs(ix))^2 + (y_irs(iiy) - y_obs(iy))^2 + (z_irs(iiz) - z_obs(iz))^2 ); %Distance from element on IRS to element of Obs.
                        greenF = exp(-1j*k*R)/R;
                        sanity1(ix,iy,iz) = sanity1(ix,iy,iz) + greenF*r1(iix,iiy); 

                    end
                end
            end
        end
    end
end

 subplot(3,1,1)
 imagesc(abs(sanity1))
 title('Sanity Check1: s1(x,y)')













%START GETTING THE PHASE IN OUR s1 prediction

%mag(irs_Nx,irs_Ny) = 0;
phase(irs_Nx,irs_Ny) = 0;

%Going through r1 and figuring out the phase of each element
%by using angle()
for i = 1:irs_Nx
    for j = 1:irs_Ny
        %mag(i,j) = abs(r1(i,j));
        phase(i,j) = angle(r1(i,j));
    end
end
 
%Now we have magnitude of predicted r1 and phase of the output of r1

for i=1:irs_Nx
    for j=1:irs_Ny
        s1(i,j) = s1(i,j)*exp(phase(i,j)*1i);
    end
end

subplot(3,1,2)
imagesc(abs(s1))
title('s1 after phase is added')















kx=linspace(-.35*k,.35*k,125); %Changing the coefficients in front of k will drastically change your results
ky=kx;
%DTFT of h and s
for ikx=1:length(kx)
    for iky=1:length(ky)
        H(ikx,iky) = 0; %Impulse Response
        S1(ikx,iky) = 0;
        for ix=1:obs_Nx
            for iy=1:obs_Ny      
                H(ikx,iky) = H(ikx,iky) + imp_res(ix,iy)*exp(-1j*(kx(ikx)*x_obs(ix)+ky(iky)*y_obs(iy)) );
                S1(ikx,iky) = S1(ikx,iky) + s1(ix,iy)*exp(-1j*(kx(ikx)*x_obs(ix)+ky(iky)*y_obs(iy)) );
            end
        end
        
    end
end


%   subplot(4,1,1)
%   mesh(abs(S5))
%   title('S')
%   
%   subplot(4,1,2)
%   mesh(abs(H))
%   title('H')


%R = S/H according to our process
S1_OVER_H = S1./H;



%Inverse DTFT of S/H
for ix=1:irs_Nx
    for iy=1:irs_Ny
        r1(ix,iy) = 0;
        for ikx=1:length(kx)
            for iky=1:length(ky)
                r1(ix,iy) = r1(ix,iy) + S1_OVER_H(ikx,iky)*exp(1j*(kx(ikx)*x_irs(ix)+ky(iky)*y_irs(iy)) );
            end
        end
    end
end


%sanity check
%putting r(x,y) back into my system should give me back my s(x,y)
for ix = 1:length(x_obs)
    for iy = 1:length(y_obs)
        for iz = 1:length(z_obs)
            sanity1(ix,iy,iz) = 0; %Creating a field and setting it to zero
            %start iterating over the IRS surface
            for iix = 1:length(x_irs)
                for iiy = 1:length(y_irs)
                    for iiz =1:length(z_irs)
                        %Add each contribution to the field
                        R = sqrt( (x_irs(iix) - x_obs(ix))^2 + (y_irs(iiy) - y_obs(iy))^2 + (z_irs(iiz) - z_obs(iz))^2 ); %Distance from element on IRS to element of Obs.
                        greenF = exp(-1j*k*R)/R;
                        sanity1(ix,iy,iz) = sanity1(ix,iy,iz) + greenF*r1(iix,iiy); 

                    end
                end
            end
        end
    end
end

 subplot(3,1,3)
 imagesc(abs(sanity1))
 title('Sanity1 check after adding phase to our process: s1(x,y)')



















