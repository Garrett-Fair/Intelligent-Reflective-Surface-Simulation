%impulse response function

function a = find_impulse_response(x_o,y_o,z_o, x_i, y_i, z_i,konstant,delta_func)

    for ix = 1:length(x_o)
        for iy = 1:length(y_o)
            for iz = 1:length(z_o)
                imp_res(ix,iy,iz) = 0; %Creating a field and setting it to zero
                %Start iterating over the IRS surface
                for iix = 1:length(x_i)
                    for iiy = 1:length(y_i)
                        for iiz =1:length(z_i)        
                            %Add each contribution to the field
                            R = sqrt( (x_i(iix) - x_o(ix))^2 + (y_i(iiy) - y_o(iy))^2 + (z_i(iiz) - z_o(iz))^2 ); %Distance from element on IRS to element of Obs.
                            greenF = exp(-1j*konstant*R)/R;
                            imp_res(ix,iy,iz) = imp_res(ix,iy,iz) + greenF*delta_func(iix,iiy); 
                        end
                    end
                end
            end
        end
    end

a = imp_res;

end














