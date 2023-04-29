clear all, close all, clc;

f = 5*10^(9); %5GHz
spd_light = 299792458; %meters/second
k = 2*pi*f/spd_light; %constant
d = 5; %distance in meters the surfaces are seperated

delta = zeros(6, 6); 
delta(3,3) = 1;

%Need an x, y, and z componenet of each element in the IRS
z_irs = 0;
x_irs = linspace(-0.5, 0.5, 6);
y_irs = linspace(-0.5, 0.5, 6);

%Now we need the coordinate space of the observation surface 
z_obs = 5;
x_obs = linspace(-2, 2, 10);
y_obs = linspace(-1, 1, 10);



%write a for loop to add all the contributions from the IRS start
%itterating over the observation surface
for ix = 1:length(x_obs)
    for iy = 1:length(y_obs)
        for iz = 1:length(z_obs)
            field(ix,iy,iz) = 0;
            %start iterating over the IRS surface
            for iix = 1:length(x_irs)
                for iiy = 1:length(x_irs)
                    for iiz =1:length(x_irs)
                        %Add each contribution to the field
                        R = sqrt((d*iix - ix).^2 + (iiy - iy).^2 + (d*iiz - iz).^2);
                        greenF = exp(-1i*k*R)/R;
                        field(ix,iy,iz) = field(ix,iy,iz) + greenF; 

                    end
                end
            end
        end
    end
end


%at the end of the loop we will have a field which will be an the impulse response

subplot(2,1,1)
mesh(abs(field))

subplot(2,1,2)
imagesc(abs(field))