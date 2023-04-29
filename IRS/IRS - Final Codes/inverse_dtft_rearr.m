%Rearrange and inverse dtft

%R = S/H according to our process

function a = inverse_dtft_rearr(S_OVER_H, irs_Nx, irs_Ny, x_irs, y_irs, kx, ky) 

    %S_OVER_H = dtft_of_desired_field./dtft_of_impulse_response; %denoted as S over H because in our process you get r = S/H, and this step is replicating that
    
    incoming_wave(irs_Nx, irs_Ny) = 0; %in our process this is commonly denoted as r.

    %Inverse DTFT of S/H
    for ix=1:irs_Nx
        for iy=1:irs_Ny
            for ikx=1:length(kx)
                for iky=1:length(ky)
                    incoming_wave(ix,iy) = incoming_wave(ix,iy) + S_OVER_H(ikx,iky)*exp(1j*(kx(ikx)*x_irs(ix)+ky(iky)*y_irs(iy)) );
                end
            end
        end
    end
    a = incoming_wave;
end

















