filenames = {'hist_EURIBOR_2009.csv' 'hist_EURIBOR_2010.csv' 'hist_EURIBOR_2011.csv' 'hist_EURIBOR_2012.csv' 'hist_EURIBOR_2013.csv'};

%# container for 3m Eurlibor 1 row: date 2row: rate
ratesContainer = [];

for str = filenames
    %# open file for reading
    fid = fopen(char(str), 'rt');
    
    %# read first line and extract date strings
    data = textscan(fid, '%s %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f','Delimiter',',','CollectOutput',1);

    %# close file
    fclose(fid);

    formatIn = 'dd/mm/yyyy';
%# place data in individual cells
data{1} = datenum(data{1},formatIn);

temp = [];
temp(:,1) =  data{1}(:,1);
temp(:,2) = data{2}(:,6);

ratesContainer = [ratesContainer ; temp];

end


