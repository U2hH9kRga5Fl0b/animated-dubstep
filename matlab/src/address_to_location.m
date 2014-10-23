function [loc, status] = address_to_location(address, save)

[xmlstr, status] = urlread(['https://maps.googleapis.com/maps/api/geocode/xml?address=' strrep(address,' ', '+')]);

if ~status || size(strfind(xmlstr, 'ZERO_RESULTS'),1) >= 1
        warning('unable to open url for %s\n', address);
        loc = [-1 -1];
        return
end

[~,~,~,latm,~,~,~] = regexp(xmlstr, '<lat>(-?[0-9]+.*[0-9]+)</lat>', 'dotexceptnewline', 'once');
[~,~,~,lngm,~,~,~] = regexp(xmlstr, '<lng>(-?[0-9]+.*[0-9]+)</lng>', 'dotexceptnewline', 'once');
f=@(x)(str2num(substr(x, 6, size(x,2)-11)));
loc= [f(latm) f(lngm)];

if save
        fid = fopen([address '.xml'], 'w');
        fprintf(fid, '%s', xmlstr);
        fclose(fid);
end

end
