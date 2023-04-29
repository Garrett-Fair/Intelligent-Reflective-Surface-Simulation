Notes-On-Code

Final Working code is under the folder "Final Codes"

1. How I ran the code 
- After opening the file "iteration_process" you should make some decisions.  How many phase iterations do you want to 
run?  What Field Distribution do you want to replicate (denoted "s" in the code)?

- Secondly, click run.  The variable "sanity" will give the final field distribution, as it is a sort of
sanity check to make sure the system replicating your desired field.

- If you desire to quantize magnitude and phase, open the file "mag_phase_quantization". 

- From this point scroll through the code and choose your desired levels of quantization.  You can do this
by changing the variable "mag_levels" and "phase_levels".

- click run.  "sr" is the final field distribution where r has been quantized.



2. When doing the Discrete Time Fourier Transform, we must create variables kx, and ky.  There are 
coefficients in front of them.  Changing these could drastically change your results, although it may be 
necessary if you change the size of the IRS or observation surface from its default 1mx1m, 33x33 elements,
and 2mx4m respectively.

please reach out to my email: garrfair@iu.edu with any questions, or you can try grrbanks17@gmail.com

:)
