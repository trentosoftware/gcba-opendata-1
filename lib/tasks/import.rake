namespace :import do
  desc "import the data file into postgres local db"
  task :data do

    output = IO.popen('pwd')
    s = output.readlines.first
    output.close

    cmd = 'psql -d \'gcba-opendata-dev\' -h localhost -U gcba -c "copy parcelas_data(id,fecha,barrio,seccion,manzana,parcela,smp,calle,nro,calle2,chapa_visible,tipo1,tipo2,pisos,nombre,created_at,updated_at) from \'' + s.chomp + '/db/migrate/uso-suelo-2008-csv2\' DELIMITERS \'|\' csv"'

    puts 'importing parcelas data...'
    output = IO.popen(cmd)
    puts output.readlines
    output.close
    raise "Cannot import parcelas data" if not $?.success?

    cmd = 'psql -d \'gcba-opendata-dev\' -h localhost -U gcba -c "copy parcelas_geometry(seccion,manzana,parcela,smp,geometry) from \'' + s.chomp + '/db/migrate/insert_geometry_data2.csv\' DELIMITERS \'#\' csv quote \'\'\'\' encoding \'utf-8\'"'

    puts 'importing parcelas geometries...'
    output = IO.popen(cmd)
    puts output.readlines
    output.close
    raise "Cannot import parcelas geometry data" if not $?.success?

    cmd = 'psql -d \'gcba-opendata-dev\' -h localhost -U gcba -f ' + s.chomp + '/db/migrate/sanetizar.sql'

    puts 'cleaning data...'
    output = IO.popen(cmd)
    puts output.readlines
    output.close
    raise "Cannot clean data" if not $?.success?

  end
end

