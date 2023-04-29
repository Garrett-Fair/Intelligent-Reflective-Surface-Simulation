%Playing with fields to see how they interact with each other
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


%starting clockwise, original directions

%top left 
s1(133,66) = 0;
%s1(15:25, 5:15) = 1;

%top right
%s1(15:25, 50:60) = 1;

%middle
s1(20:22, 10:15) = 1;





s2(133,66) = 0;
s3(133,66) = 0;
% s3(115:125, 30:40) = 1;

s4(133,66) = 0;


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



kx=linspace(-.35*k,.35*k,125);
ky=kx;
%DTFT of h and s
for ikx=1:length(kx)
    for iky=1:length(ky)
        H(ikx,iky) = 0; %Impulse Response
        S1(ikx,iky) = 0;
        S2(ikx,iky) = 0; 
        S3(ikx,iky) = 0;
        S4(ikx,iky) = 0;
        for ix=1:obs_Nx
            for iy=1:obs_Ny      
                H(ikx,iky) = H(ikx,iky) + imp_res(ix,iy)*exp(-1j*(kx(ikx)*x_obs(ix)+ky(iky)*y_obs(iy)) );
                S1(ikx,iky) = S1(ikx,iky) + s1(ix,iy)*exp(-1j*(kx(ikx)*x_obs(ix)+ky(iky)*y_obs(iy)) );
                S2(ikx,iky) = S2(ikx,iky) + s2(ix,iy)*exp(-1j*(kx(ikx)*x_obs(ix)+ky(iky)*y_obs(iy)) );
                S3(ikx,iky) = S3(ikx,iky) + s3(ix,iy)*exp(-1j*(kx(ikx)*x_obs(ix)+ky(iky)*y_obs(iy)) );
                S4(ikx,iky) = S4(ikx,iky) + s4(ix,iy)*exp(-1j*(kx(ikx)*x_obs(ix)+ky(iky)*y_obs(iy)) );
                
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
% subplot(4,1,1)
% mesh(abs(S_OVER_H))
% title('S/H Plot')

S2_OVER_H = S2./H;
% subplot(4,1,1)
% mesh(abs(S_OVER_H))
% title('Q1/H Plot')

S3_OVER_H = S3./H;
% subplot(4,1,1)
% mesh(abs(S_OVER_H))
% title('Q4/H Plot')

S4_OVER_H = S4./H;

%Inverse DTFT of S/H
for ix=1:irs_Nx
    for iy=1:irs_Ny
        r1(ix,iy) = 0;
        r2(ix,iy) = 0;
        r3(ix,iy) = 0;
        r4(ix,iy) = 0;
        for ikx=1:length(kx)
            for iky=1:length(ky)
                r1(ix,iy) = r1(ix,iy) + S1_OVER_H(ikx,iky)*exp(1j*(kx(ikx)*x_irs(ix)+ky(iky)*y_irs(iy)) );
                r2(ix,iy) = r2(ix,iy) + S2_OVER_H(ikx,iky)*exp(1j*(kx(ikx)*x_irs(ix)+ky(iky)*y_irs(iy)) );
                r3(ix,iy) = r3(ix,iy) + S3_OVER_H(ikx,iky)*exp(1j*(kx(ikx)*x_irs(ix)+ky(iky)*y_irs(iy)) );
                r4(ix,iy) = r4(ix,iy) + S4_OVER_H(ikx,iky)*exp(1j*(kx(ikx)*x_irs(ix)+ky(iky)*y_irs(iy)) );
            end
        end
    end
end

% subplot(4,1,2)
% mesh(abs(r))
% title('Recieved Initial wave r(x,y)')

%sanity check
%putting r(x,y) back into my system should give me back my s(x,y)
for ix = 1:length(x_obs)
    for iy = 1:length(y_obs)
        for iz = 1:length(z_obs)
            sanity1(ix,iy,iz) = 0; %Creating a field and setting it to zero
            sanity2(ix,iy,iz) = 0;
            sanity3(ix,iy,iz) = 0;
            sanity4(ix,iy,iz) = 0;
            %start iterating over the IRS surface
            for iix = 1:length(x_irs)
                for iiy = 1:length(y_irs)
                    for iiz =1:length(z_irs)
                        %Add each contribution to the field
                        R = sqrt( (x_irs(iix) - x_obs(ix))^2 + (y_irs(iiy) - y_obs(iy))^2 + (z_irs(iiz) - z_obs(iz))^2 ); %Distance from element on IRS to element of Obs.
                        greenF = exp(-1j*k*R)/R;
                        sanity1(ix,iy,iz) = sanity1(ix,iy,iz) + greenF*r1(iix,iiy); 
                        sanity2(ix,iy,iz) = sanity2(ix,iy,iz) + greenF*r2(iix,iiy);
                        sanity3(ix,iy,iz) = sanity3(ix,iy,iz) + greenF*r3(iix,iiy);
                        sanity4(ix,iy,iz) = sanity4(ix,iy,iz) + greenF*r4(iix,iiy);

                    end
                end
            end
        end
    end
end

 %subplot(2,1,1)
 imagesc(abs(sanity1))
 title('Sanity Check1: s1(x,y)')
 
%  subplot(2,1,2)
%  imagesc(abs(sanity3))
%  title('Sanity Check2: s3(x,y)')

%  subplot(4,1,3)
%  imagesc(abs(sanity3))
%  title('Sanity Check3: s3(x,y)')
% 
%  subplot(4,1,4)
%  imagesc(abs(sanity4))
%  title('Sanity Check4 s4(x,y)')
