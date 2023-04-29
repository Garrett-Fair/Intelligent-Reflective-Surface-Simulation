%FINAL PROCESS (ANTENNA THEORY-ISH)
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

%CREATING OUR FINAL FIELD r(x,y)
%One Pixel Field
s1(133,66) = 0;
s1(44, 40) = 1;

%Adding Spot
s2(133,66) = 0;
s2(44, 40) = 1;
s2(10:30, 5:12) = 1;

%Final Field
s3(133,66) = 0;
s3(44, 40) = 1;
s3(10:30, 5:12) = 1;
s3(100:120, 40:52) = 1;




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



%FOURIER TRANSFORMS OF h->H(impulse response) and s->S(final field)
for ikx = 1:obs_Nx
    for iky = 1:obs_Ny
        H(ikx,iky) = 0;
        %R1(ikx,iky) = 0;
        %R2(ikx,iky) = 0;
        S3(ikx,iky) = 0;
        for ix = 1:obs_Nx
            for iy = 1:obs_Ny
                H(ikx,iky) = H(ikx,iky)+imp_res(ix,iy,iz)*exp(-1j*2*pi*( (ikx-1)*(ix-1)/obs_Nx + (iky-1)*(iy-1)/obs_Ny ) );
                %S1(ikx,iky) = S1(ikx,iky) + s1(ix,iy)*exp(-1j*2*pi*( (ikx-1)*(ix-1)/Nx + (iky-1)*(iy-1)/Ny ) );
                %S2(ikx,iky) = S2(ikx,iky) + s2(ix,iy)*exp(-1j*2*pi*( (ikx-1)*(ix-1)/Nx + (iky-1)*(iy-1)/Ny ) );
                S3(ikx,iky) = S3(ikx,iky) + s3(ix,iy)*exp(-1j*2*pi*( (ikx-1)*(ix-1)/obs_Nx + (iky-1)*(iy-1)/obs_Ny ) );
                
            end
        end
    end
end



% R = S/H, according to our process
S_OVER_H = S3/H;
subplot(4,1,1)
mesh(abs(S_OVER_H))
title('S/H Plot')

%Nx = 33;
%Ny = 33;
%Inverse FT of Transformed impulse response
for ix = 1:irs_Nx
    for iy = 1:irs_Ny
        r(ix,iy) = 0;
        for ikx = 1:irs_Nx
            for iky = 1:irs_Ny
                 r(ix,iy) = r(ix,iy) + S_OVER_H(ikx,iky)*exp(1j*2*pi*( (ikx-1)*(ix-1)/irs_Nx + (iky-1)*(iy-1)/irs_Ny ) ); 
            end
        end
    end
end
subplot(4,1,2)
mesh(abs(r))
title('Initial wave r(x,y)')


%sanity check
% putting r(x,y) back into my system should give me back my s(x,y)
for ix = 1:length(x_obs)
    for iy = 1:length(y_obs)
        for iz = 1:length(z_obs)
            sanity(ix,iy,iz) = 0; %Creating a field and setting it to zero
            %start iterating over the IRS surface
            for iix = 1:length(x_irs)
                for iiy = 1:length(y_irs)
                    for iiz =1:length(z_irs)
                        %Add each contribution to the field
                        R = sqrt( (x_irs(iix) - x_obs(ix))^2 + (y_irs(iiy) - y_obs(iy))^2 + (z_irs(iiz) - z_obs(iz))^2 ); %Distance from element on IRS to element of Obs.
                        greenF = exp(-1j*k*R)/R;
                        sanity(ix,iy,iz) = sanity(ix,iy,iz) + greenF*r(iix,iiy); 

                    end
                end
            end
        end
    end
end

subplot(4,1,3)
mesh(abs(sanity))
title('Sanity Check: Should give back s(x,y)')

subplot(4,1,4)
mesh(s3)
title('Actual s(x,y)')





















