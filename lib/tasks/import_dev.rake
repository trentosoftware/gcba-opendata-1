#encoding: utf-8
namespace :import_prod do
  desc "import the data file into postgres local db"
  task :data do

    data_sets = [
      {'type' => 'rar', 'name' => 'parcelas.rar', 'table' => 'parcelas_geometries', 'opc' => '-a', 'inserts' => []},
      {'type' => 'rar', 'name' => 'manzanas.rar', 'table' => 'manzanas_geometries', 'opc' => '-a', 'inserts' => []},
      {'type' => 'zip', 'name' => 'mapa-bibliotecas.zip', 'table' => 'biblio_geometries', 'opc' => '-d', 'inserts' => [
          'INSERT INTO parcelas_geometries (smp, geometry) SELECT \'biblio\'||gid AS smp, ST_Multi(ST_GeomFromText(ST_AsText(ST_Buffer(geometry,0.00005,2)),4326)) FROM biblio_geometries',
          'INSERT INTO parcelas_data (smp, tipo2, nombre, created_at, updated_at) SELECT \'biblio\'||gid AS smp, \'BIBLIOTECA\' AS tipo2, nom_mapa AS nombre, now() AS created_at, now() AS updated_at FROM biblio_geometries'
          ]
      },
      {'type' => 'zip', 'name' => 'establecimientos-educativos-privados.zip', 'table' => 'edu_priv_geometries', 'opc' => '-d', 'inserts' => [
          'INSERT INTO parcelas_geometries (smp, geometry) SELECT \'epriv\'||gid AS smp, ST_Multi(ST_GeomFromText(ST_AsText(ST_Buffer(geometry,0.00005,2)),4326)) FROM edu_priv_geometries',
          'INSERT INTO parcelas_data (smp, tipo2, nombre, created_at, updated_at) SELECT \'epriv\'||gid AS smp, \'ESTABLECIMIENTO EDUCATIVO PRIVADO\' AS tipo2, nombre_est AS nombre, now() AS created_at, now() AS updated_at FROM edu_priv_geometries'
          ]
      },
      {'type' => 'zip', 'name' => 'establecimientos-educativos-publicos.zip', 'table' => 'edu_pub_geometries', 'opc' => '-d', 'inserts' => [
          'INSERT INTO parcelas_geometries (smp, geometry) SELECT \'epub\'||gid AS smp, ST_Multi(ST_GeomFromText(ST_AsText(ST_Buffer(geometry,0.00005,2)),4326)) FROM edu_pub_geometries',
          'INSERT INTO parcelas_data (smp, tipo2, nombre, created_at, updated_at) SELECT \'epub\'||gid AS smp, \'ESTABLECIMIENTO EDUCATIVO PUBLICO\' AS tipo2, nombre_est AS nombre, now() AS created_at, now() AS updated_at FROM edu_pub_geometries'
          ]
      },
      {'type' => 'zip', 'name' => 'mapa-estaciones-de-subterraneo.zip', 'table' => 'subte_geometries', 'opc' => '-d', 'inserts' => [
          'INSERT INTO parcelas_geometries (smp, geometry) SELECT \'subte\'||gid AS smp, ST_Multi(ST_GeomFromText(ST_AsText(ST_Buffer(geometry,0.00005,2)),4326)) FROM subte_geometries',
          'INSERT INTO parcelas_data (smp, tipo2, nombre, created_at, updated_at) SELECT \'subte\'||gid AS smp, \'ESTACION SUBTE\' AS tipo2, \'Línea \'||linea||\' - \'||estacion AS nombre, now() AS created_at, now() AS updated_at FROM subte_geometries'
          ]
      },
      {'type' => 'rar', 'name' => 'espacios-verdes.rar', 'table' => 'espverdes_data', 'opc' => '-d', 'inserts' => [
         'INSERT INTO parcelas_geometries (smp, geometry) SELECT \'everde\'||gid AS smp, geometry FROM espverdes_data',
         'INSERT INTO parcelas_data (smp, tipo2, nombre, created_at, updated_at) SELECT \'everde\'||gid AS smp, \'ESPACIO VERDE\' AS tipo2, nombre, now() AS created_at, now() AS updated_at FROM espverdes_data'
         ]
      },
      {'type' => 'zip', 'name' => 'comisarias.zip', 'table' => 'comisarias_geometries', 'opc' => '-d', 'inserts' => [
          'INSERT INTO parcelas_geometries (smp, geometry) SELECT \'comisa\'||gid AS smp, ST_Multi(ST_GeomFromText(ST_AsText(ST_Buffer(geometry,0.00015,2)),4326)) FROM comisarias_geometries',
          'INSERT INTO parcelas_data (smp, tipo2, nombre, created_at, updated_at) SELECT \'comisa\'||gid AS smp, \'COMISARIA\' AS tipo2, nombre, now() AS created_at, now() AS updated_at FROM comisarias_geometries'
         ]
      }
    ]

    db_name = "gcba-opendata-dev"
    bsas_data_path = "localhost:./bsas.data/"
    output = IO.popen('pwd')
    s = output.readlines.first
    output.close

    # Insert Parcelas data
    cmd = 'psql -d \'' + db_name + '\' -h localhost -U gcba -c "copy parcelas_data(id,fecha,barrio,seccion,manzana,parcela,smp,calle,nro,calle2,chapa_visible,tipo1,tipo2,pisos,nombre,created_at,updated_at) from \'' + s.chomp + '/db/migrate/uso-suelo-2008-csv2\' DELIMITERS \'|\' csv ENCODING \'utf8\'"'
    puts 'Importing parcelas data...'
    output = IO.popen(cmd)
    puts output.readlines
    output.close
    raise "Cannot import parcelas data" if not $?.success?

    # Add Utils to db    
    cmd = 'psql -d \'gcba-opendata-prod\' -h localhost -U gcba -f ' + s.chomp + '/db/migrate/pg_utils.sql'
    puts 'running pg utils script...'
    output = IO.popen(cmd)
    puts output.readlines
    output.close
    raise "Cannot run pg utils script" if not $?.success?

    # Update smp in data to match in geometries
    cmd = 'psql -d \'' + db_name + '\' -h localhost -U gcba -c "update parcelas_data set seccion = concat(\'0\',seccion), smp = concat(\'0\', smp)"'
    puts 'Updating parcelas_data.id sequence...'
    output = IO.popen(cmd)
    puts output.readlines
    output.close
    raise "Cannot update parcelas_data.id sequence" if not $?.success?

    # Update sequence for parcelas_data.id
    cmd = 'psql -d \'' + db_name + '\' -h localhost -U gcba -c "select setval(\'parcelas_data_id_seq\', (select max(id)+1 from parcelas_data))"'
    puts 'Updating parcelas_data.id sequence...'
    output = IO.popen(cmd)
    puts output.readlines
    output.close
    raise "Cannot update parcelas_data.id sequence" if not $?.success?

    # Create the temp directory  
    cmd = 'mkdir -p ' + s.chomp + '/import_tmp'
    output = IO.popen(cmd)
    puts output.readlines
    output.close
    raise "Cannot create the temp directory" if not $?.success?

    # Remove possible files in the temp directory  
    cmd = 'rm -rf ' + s.chomp + '/import_tmp/*'
    output = IO.popen(cmd)
    puts output.readlines
    output.close
    raise "Cannot remove files in the temp directory" if not $?.success?

    # Go temp directory  
    Dir.chdir('import_tmp')
    raise "Cannot find the temp directory" if not $?.success?

    # Get dataset files
    cmd = 'scp -i ~/.ssh/id_rsa '
    data_sets.each do |data|
	cmd += ' ' + bsas_data_path + data['name']
    end
    cmd += ' .'
    output = IO.popen(cmd)
    puts output.readlines
    output.close
    raise 'Cannot get files from ' + bsas_data_path if not $?.success?

    # Process dataset files
    data_sets.each do |data|
        
        puts("Working with: #{data['name']}...")
       
        # Unrar/Unzip dataset files
        (data['type'] == 'zip')?cmd = 'unzip ':cmd = 'unrar e '
	cmd += data['name']
        output = IO.popen(cmd)
        puts output.readlines
        output.close
        raise 'Cannot uncompress file: ' + data['name'] if not $?.success?

        # Get shp file
        output = IO.popen('ls *.shp')
        shp = output.readlines.first.chomp
        output.close
        raise "Cannot find dataset shp file in " + data['name']  if not $?.success?

        # Insert data set into db
        cmd = 'shp2pgsql ' + data['opc']  + ' -s 9807:4326 -g geometry -W latin1 -I ' + shp + ' ' + data['table'] + ' | sudo -u postgres psql -d ' + db_name
        puts 'Importing dataset in ' + data['name'] + '...'
        output = IO.popen(cmd)
        puts output.readlines
        output.close
        raise "Cannot import data set in db" if not $?.success?

        # Run data insertion to parcelas_db
        data['inserts'].each do |insert|
            cmd = 'psql -d \'' + db_name + '\' -h localhost -U gcba -c "' + insert  + '"'
            puts 'Moving data from dataset ' + data['name'] + ' to main parcela data/geometries table...'
            output = IO.popen(cmd)
            puts output.readlines
            output.close
            raise "Cannot import into parcelas data: '#{insert}'" if not $?.success?
        end

        # Remove dataset files
        cmd = 'rm -rf *.shp'
        output = IO.popen(cmd)
        puts output.readlines
        output.close
        raise "Cannot remove files in the temp directory" if not $?.success?
    end


    # Go temp directory  
    Dir.chdir('..')
    raise "Cannot exit the temp directory" if not $?.success?

    # Remove temp directory  
    cmd = 'rm -rf import_tmp'
    output = IO.popen(cmd)
    puts output.readlines
    output.close
    raise "Cannot remove the temp directory" if not $?.success?

    # Sanetizar
    cmd = 'psql -d \'' + db_name + '\' -h localhost -U gcba -f ' + s.chomp + '/db/migrate/sanetizar.sql'
    puts 'cleaning data...'
    output = IO.popen(cmd)
    puts output.readlines
    output.close
    raise "Cannot clean data" if not $?.success?

  end
end

