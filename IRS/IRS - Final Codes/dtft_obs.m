%dtft of surface

%kx=linspace(-.35*k,.35*k,125);
%ky=kx;
%DTFT of h and s

function a = dtft_obs(original_func, x_o, y_o, kx, ky, obs_Nx, obs_Ny)

    dtft_func(length(kx), length(ky)) = 0; %define outside the for loops to make it a bit quicker

    for ikx=1:length(kx)
        for iky=1:length(ky) 
            for ix=1:obs_Nx
                for iy=1:obs_Ny      
                    dtft_func(ikx,iky) = dtft_func(ikx,iky) + original_func(ix,iy)*exp(-1j*(kx(ikx)*x_o(ix)+ky(iky)*y_o(iy)) );
                end
            end
        end
    end
    a = dtft_func;
end

