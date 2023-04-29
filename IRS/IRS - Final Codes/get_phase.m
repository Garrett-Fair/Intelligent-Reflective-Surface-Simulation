%get_phase

function a = get_phase(sanity, s, obs_Nx, obs_Ny)

    phase(obs_Nx,obs_Ny) = 0;
    blue = s;

    for i = 1:obs_Nx
        for j = 1:obs_Ny
            phase(i,j) = angle(sanity(i,j));
        end
    end
     

    
    for i=1:obs_Nx
        for j=1:obs_Ny
            blue(i,j) = blue(i,j)*exp(phase(i,j)*1i);
        end
    end
   
a = blue;

end



