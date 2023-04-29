%implementing funcitons for our process
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

% 1 Spot Field - ONLY MAGNITUDE
% s(133,66) = 0;
% s(90:110, 44:50) = 1;


% Testing Middle Cancelling Field
% s(133,66) = 0;
% s(62:72, 28:38) = 1; %middle
% s(10:20, 7:17) = 1; %top left
% s(10:20, 50:60) = 1; %top right


% Large Field
% s(133,66) = 0;
% s(52:82, 18:48) = 1;

% Small Field
s(133,66) = 0;
s(64:68, 31:35) = 1;


%INITIAL PROCESS THAT WILL GIVE US A FINAL DISTRIBUTION s(x,y), denoted as
%sanity

imp_res = find_impulse_response(x_obs,y_obs,z_obs,x_irs,y_irs,z_irs,k, delta); %Feeds delta into our system giving us an impulse response


%Fourier Transform H and S according to the process.  Specifically doing
%discrete time FT so we can have our own domain and avoid matching the
%specific sizes of our IRS or observation surface

kx=linspace(-.35*k,.35*k,125); %If you graph H and S and there is not enough/too much of the wave behavior showing, change coefficients in front of k to show
ky=kx;                         %desired amount, 0.35 gives best results 

H = dtft_obs(imp_res ,x_obs, y_obs, kx, ky, obs_Nx, obs_Ny); 
S = dtft_obs(s,x_obs,y_obs,kx,ky,obs_Nx,obs_Ny);

S_OVER_H = S./H; %Dividing S and H according to our process
r = inverse_dtft_rearr(S_OVER_H, irs_Nx, irs_Ny, x_irs, y_irs, kx, ky); %Doing final step in our process to get incoming wave r

sanity = feed_signal_into_IRS(x_obs,y_obs,z_obs,x_irs,y_irs,z_irs,k,r); %feeding that wave through our IRS and make sure it gives good results - sanity check

subplot(2,1,1)
imagesc(abs(sanity))
title('final signal where s has only magnitude')




new_s = get_phase(sanity, s, obs_Nx, obs_Ny); %Extracting phase from our result and putting into our initial field s

%redoing the process with a magnitude and phase component
S = dtft_obs(new_s,x_obs,y_obs,kx,ky,obs_Nx,obs_Ny);
S_OVER_H = S./H;
r = inverse_dtft_rearr(S_OVER_H, irs_Nx, irs_Ny, x_irs, y_irs, kx, ky);
sanity = feed_signal_into_IRS(x_obs,y_obs,z_obs,x_irs,y_irs,z_irs,k,r);

subplot(2,1,2)
imagesc(abs(sanity))
title('final signal where s has magnitude AND phase')













