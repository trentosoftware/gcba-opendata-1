namespace :import do
  desc "import the data file into postgres local db"
  task :data do

    output = IO.popen('pwd')
    s = output.readlines.first
    output.close

    cmd = 'psql -d \'gcba-opendata-dev\' -h localhost -U gcba -c "copy parcelas_data(id,fecha,barrio,seccion,manzana,parcela,smp,calle,nro,calle2,chapa_visible,tipo1,tipo2,pisos,nombre,created_at,updated_at) from \'' + s.chomp + '/db/migrate/uso-suelo-2008-csv2\' DELIMITERS \'|\' csv ENCODING \'latin1\'"'
    puts 'importing parcelas data...'
    output = IO.popen(cmd)
    puts output.readlines
    output.close
    raise "Cannot import parcelas data" if not $?.success?

    #cmd = 'psql -d \'gcba-opendata-dev\' -h localhost -U gcba -c "copy parcelas_geometries(seccion,manzana,parcela,smp,geometry) from \'' + s.chomp + '/db/migrate/insert_geometry_data2.csv\' DELIMITERS \'#\' csv quote \'\'\'\' encoding \'utf-8\'"'

    #puts 'importing parcelas geometries...'
    #output = IO.popen(cmd)
    #puts output.readlines
    #output.close
    #raise "Cannot import parcelas geometry data" if not $?.success?


    #cmd = 'psql -d \'gcba-opendata-dev\' -h localhost -U gcba -c "copy parcelas_geometries(seccion,manzana,parcela,smp,geometry) from \'' + s.chomp + '/db/migrate/insert_geometry_data2.csv\' DELIMITERS \'#\' csv quote \'\'\'\' encoding \'utf-8\'"'

    #puts 'importing parcelas geometries...'
    #output = IO.popen(cmd)
    #puts output.readlines
    #output.close
    #raise "Cannot import parcelas geometry data" if not $?.success?

    #INSERT INTO "spatial_ref_sys" (srid, auth_name, auth_srid, srtext, proj4text) VALUES (9807, 'Argentina_GKBsAs',9807,
    #    'PROJCS["Argentina_GKBsAs",GEOGCS["GCS_Campo_Inchauspe",DATUM["D_Campo_Inchauspe",SPHEROID["International_1924",6378388.0,297.0]],PRIMEM["Greenwich",0.0],UNIT["Degree",0.0174532925199433]],PROJECTION["Transverse_Mercator"],PARAMETER["False_Easting",100000.0],PARAMETER["False_Northing",100000.0],PARAMETER["Central_Meridian",-58.4627],PARAMETER["Scale_Factor",0.999998],PARAMETER["Latitude_Of_Origin",-34.6297166],UNIT["Meter",1.0]]','+proj=tmerc +lat_0=-34.6297166 +lon_0=-58.4627 +k=0.999998 +x_0=100000.0 +y_0=100000.0 +ellps=WGS84 +datum=WGS84 +units=m +no_defs');

    #shp2pgsql -d -s 9807 -c -g geom -W latin1 -I mo_parcelascatastro_100112.shp parcelas | sudo -u postgres psql -d training


    cmd = 'psql -d \'gcba-opendata-dev\' -h localhost -U gcba -f ' + s.chomp + '/db/migrate/sanetizar.sql'

    puts 'cleaning data...'
    output = IO.popen(cmd)
    puts output.readlines
    output.close
    raise "Cannot clean data" if not $?.success?

  end
end

