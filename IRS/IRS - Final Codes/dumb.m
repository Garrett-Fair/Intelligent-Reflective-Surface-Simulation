clear all, close all, clc;
i=1;
rng default
ibi = randi(5,5);

specific_number = 2;
end_number = 3;

for i=1:5
    if i == ibi(specific_number, 2)
        indicy_start = i;
    end
    if i == ibi(end_number, 2)
        indicy_end = i;
    end
    i = i+1;
end
pri
