function [loc, status] = address_to_location(address, save)

[xmlstr, status] = urlread(['https://maps.googleapis.com/maps/api/geocode/xml?address=' strrep(address,' ', '+')]);

if ~status || size(strfind(xmlstr, 'ZERO_RESULTS'),1) >= 1
        warning('unable to open url for %s. Defaulting to Bailey, CO.\n', address);
        loc = [39.4105578 -105.4794795];
        return
end

% Returns one lat and long in the out, not necessarily the middle.
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
