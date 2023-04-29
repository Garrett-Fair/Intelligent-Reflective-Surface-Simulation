%The goal of this code is to find the phase and magnitude of the complex
%values given to us by r(x,y).  Then, since we will only have limited
%control of phase and magnitude via our varactor diodes we quantize them
%into a certain amount of groups


mag(irs_Nx,irs_Ny) = 0;
phase(irs_Nx,irs_Ny) = 0;

%Going through r1 and figuring out the magnitude and phase of each element
%by using abs() and angle()
for i = 1:irs_Nx
    for j = 1:irs_Ny
        mag(i,j) = abs(r(i,j));
        phase(i,j) = angle(r(i,j));
    end
end


%QUANTIZING OUR PHASE AND MAGNITUDE

%THE GENERAL OUTLINE OF THE CODE IS AS FOLLOWS.  FIRST WE SET A NUMBER OF QUANTIZATION LEVELS FOR OUR PHASE AND MAGNITUDE, WE THEN GO THROUGH
%EVERY MAG AND PHASE VALUE AND CHECK WHICH QUANTIZATION LEVEL IT IS CLOSEST TO. FROM THERE WE REPLACE THE VALUE WITH THE QUANTIZED ONE IN
%ANOTHER MATRIX



%quantizes phase and magnitude into certain number of groups
mag_levels = 8;
phase_levels = 8;

discrete_magnitude = linspace(min(mag, [], 'all'), max(mag, [], 'all'), mag_levels); %makes a 1 by N matrix, min to max values of mag or phase, quantizes into groups
discrete_phase = linspace(min(phase, [], 'all'), max(phase, [], 'all'), phase_levels);

% subtract each magnitude or phase value from one of the N discrete
% values, then which ever subtraction from the 16 values is closest to zero
% gets lumped in with that group.

closeto0_mag(mag_levels) = 0; 
closeto0_phase(phase_levels) = 0;
mag_quantized(irs_Nx,irs_Ny) = 0;
phase_quantized(irs_Nx,irs_Ny) = 0;

%iterating through every mag and phase value
for i = 1:irs_Nx
    for j = 1:irs_Ny
        %iterating through every quantization level of mag and phase
        for ii = 1:mag_levels
            for jj = 1:phase_levels
                %Subtracts the first magnitude element from the N number of
                %discrete values
                closeto0_mag(ii) = abs(mag(i,j) - discrete_magnitude(ii)); %Take abs() so we can ignore negative values
                closeto0_phase(jj) = abs(phase(i,j) - discrete_phase(jj));


            end
        end
        %This func finds the indicie [c,r] of the minimum value in a
        %matrix. This indicie will coorespond to which discrete value it
        %should be lumped into, which I set magnitude equal to here.
        [C,R] = find(closeto0_mag==min(closeto0_mag(:)));
        mag_quantized(i,j) = discrete_magnitude(C,R);

        [A,B] = find(closeto0_phase==min(closeto0_phase(:)));
        phase_quantized(i,j) = discrete_phase(A,B);

    end
end


%Convertion back to Complex.
%a(irs_Nx,irs_Ny) = 0;
%b(irs_Nx,irs_Ny) = 0;

%z(irs_Nx,irs_Ny) = 0;
quantized_r(irs_Nx,irs_Ny) = 0;
for i = 1:irs_Nx
    for j = 1:irs_Ny
        %a = mag(i,j)*cos(phase(i,j));
        %b = mag(i,j)*sin(phase(i,j))*1i;
        %quantized_r = a + b;
        quantized_r(i,j) = mag_quantized(i,j)*exp(phase_quantized(i,j)*1i);
        
    end
end
 
subplot(2,1,1)
imagesc(abs(r))
title('orginal r')

subplot(2,1,2)
imagesc(abs(quantized_r))
title('quantized r')


sr = feed_signal_into_IRS(x_obs,y_obs,z_obs,x_irs,y_irs,z_irs,k,quantized_r);






