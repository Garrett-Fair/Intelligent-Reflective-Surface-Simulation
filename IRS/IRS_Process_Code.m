clear all, close all, clc;

f = 5e9; %5GHz
spd_light = 3e8; %m/s
k = 2*pi*f/spd_light; %constant

lambda = spd_light/f; %wavelength.  An ideal situation is where the points sources should be lambda/2 away from each other on the 
                      %IRS. .03m in our case. Assume 1mx1m IRS, so 1/.03 = 33 sources along x and y
delta=zeros(33,33);
delta(17,17)=1;


% lambda is wavelength. Ideally the point sources should be lambda/2 (here
% 0.03 m) away on the IRS. So if we assume the total length of IRS is 1 m x
% 1m then, we could have 1/0.03=33 sources along x and y directions


Nx = 33; %How many elements are in each x and y direction
Ny = 33;
%x, y, and z componenet of each element in the IRS
z_irs = 0;
x_irs = linspace(-0.5, 0.5, Nx);
y_irs = linspace(-0.5, 0.5, Ny);

%x, y, and z component of the observation surface 
z_obs = 5;
x_obs = linspace(-2, 2, 133);
y_obs = linspace(-1, 1, 66);

% Again we need to sample the observation plane every lambda/2 so that our Fourier transform would be accurate
% for a length of 4 m along the x axis we would need 4/.03= 133 samples and for a length of 2 along y axis we need
% 2/0.03=66 samples


subplot(2,1,1)
% mesh(abs(field))
% title('3D Representation of Field Distribution')
mesh(abs(delta))



%itterating over the observation surface
for ix = 1:length(x_obs)
    for iy = 1:length(y_obs)
        for iz = 1:length(z_obs)
            field(ix,iy,iz) = 0; %Creating a field and setting it to zero
            H(ix,iy) = 0;
            %start iterating over the IRS surface
            for iix = 1:length(x_irs)
                for iiy = 1:length(y_irs)
                    for iiz =1:length(z_irs)
                        %Add each contribution to the field
                        R = sqrt( (x_irs(iix) - x_obs(ix))^2 + (y_irs(iiy) - y_obs(iy))^2 + (z_irs(iiz) - z_obs(iz))^2 ); %Distance from element on IRS to element of Obs.
                        greenF = exp(-1j*k*R)/R;
                        field(ix,iy,iz) = field(ix,iy,iz) + greenF*delta(iix,iiy); 

                    end
                end
            end
        end
    end
end


%at the end of the loop we will have a field which will be an the impulse response
subplot(2,1,1)
% mesh(abs(field))
% title('3D Representation of Field Distribution')
mesh(abs(delta))

subplot(2,1,2)
imagesc(abs(field))
title('2D Representation of Field Distribution')



























