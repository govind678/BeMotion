function [ ] = normalize( filename )

[y,Fs,n] = wavread(filename);
channels = size(y,2);

out = zeros(size(y));

m = max(abs(y));

for c = 1:channels
    out(:,c) = (y(:,c) / max(m)) * 0.9999;
end

wavwrite(out, Fs, n, filename);

end

