% Normalize File

folder = 'Skies 90';
file = 'Skies';


for i=1:5
    
    filename = sprintf('%s/%s%d.wav',folder,file,i-1);
    disp(sprintf('%s',filename));
    normalize(filename);
    
end