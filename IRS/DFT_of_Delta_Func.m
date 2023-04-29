%DFT of Delta Func

clear all
clc
close all

Nx=33;
Ny=33;

x=linspace(-0.5,0.5,Nx);
y=linspace(-0.5,0.5,Ny);

func=zeros(Nx,Ny);
func(17,17)=1;


for ikx=1:Nx
    for iky=1:Ny
        
        FUNC(ikx,iky)=0;
        
        for ix=1:Nx
            for iy=1:Ny
                
                FUNC(ikx,iky)=FUNC(ikx,iky)+func(ix,iy)*exp(-j*2*pi*( (ikx-1)*(ix-1)/Nx + (iky-1)*(iy-1)/Ny ) );
                
            end
        end
        
    end
end

subplot(2,1,1)
mesh(abs(func))
title('original function')

subplot(2,1,2)
mesh(abs(FUNC))
title('DFT of function')