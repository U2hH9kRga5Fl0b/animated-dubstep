function [ num_lines ] = get_num_lines( filename )

line = 0;
fid=fopen(filename, 'r');
if fid < 0
    error('Unable to open file %s\n', filename);
end
tline=fgetl(fid);
while ischar(tline)
    line = line + 1;
    tline=fgetl(fid);
end

num_lines = line;