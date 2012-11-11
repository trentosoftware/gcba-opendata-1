#encoding: utf-8
namespace :import_dev do
  desc "import the data file into postgres local db"
  task :data do

    data_sets = [
      {'type' => 'rar', 'name' => 'parcelas.rar', 'table' => 'parcelas_geometries', 'opc' => '-a', 'inserts' => []},
      {'type' => 'rar', 'name' => 'manzanas.rar', 'table' => 'manzanas_geometries', 'opc' => '-a', 'inserts' => []},
      {'type' => 'zip', 'name' => 'mapa-bibliotecas.zip', 'table' => 'biblio_geometries', 'opc' => '-d', 'inserts' => [
          'INSERT INTO parcelas_geometries (smp, geometry) SELECT \'biblio\'||gid AS smp, ST_Multi(ST_GeomFromText(ST_AsText(ST_Buffer(geometry,0.00005,2)),4326)) FROM biblio_geometries',
          'INSERT INTO parcelas_data (smp, tipo2, nombre, created_at, updated_at, is_generated) SELECT \'biblio\'||gid AS smp, \'BIBLIOTECA\' AS tipo2, nom_mapa AS nombre, now() AS created_at, now() AS updated_at, true as is_generated FROM biblio_geometries'
          ]
      },
      {'type' => 'zip', 'name' => 'establecimientos-educativos-privados.zip', 'table' => 'edu_priv_geometries', 'opc' => '-d', 'inserts' => [
          'INSERT INTO parcelas_geometries (smp, geometry) SELECT \'epriv\'||gid AS smp, ST_Multi(ST_GeomFromText(ST_AsText(ST_Buffer(geometry,0.00005,2)),4326)) FROM edu_priv_geometries',
          'INSERT INTO parcelas_data (smp, tipo2, nombre, created_at, updated_at, is_generated) SELECT \'epriv\'||gid AS smp, \'ESTABLECIMIENTO EDUCATIVO PRIVADO\' AS tipo2, nombre_est AS nombre, now() AS created_at, now() AS updated_at, true as is_generated FROM edu_priv_geometries'
          ]
      },
      {'type' => 'zip', 'name' => 'establecimientos-educativos-publicos.zip', 'table' => 'edu_pub_geometries', 'opc' => '-d', 'inserts' => [
          'INSERT INTO parcelas_geometries (smp, geometry) SELECT \'epub\'||gid AS smp, ST_Multi(ST_GeomFromText(ST_AsText(ST_Buffer(geometry,0.00005,2)),4326)) FROM edu_pub_geometries',
          'INSERT INTO parcelas_data (smp, tipo2, nombre, created_at, updated_at, is_generated) SELECT \'epub\'||gid AS smp, \'ESTABLECIMIENTO EDUCATIVO PUBLICO\' AS tipo2, nombre_est AS nombre, now() AS created_at, now() AS updated_at, true as is_generated FROM edu_pub_geometries'
          ]
      },
      {'type' => 'zip', 'name' => 'mapa-estaciones-de-subterraneo.zip', 'table' => 'subte_geometries', 'opc' => '-d', 'inserts' => [
          'INSERT INTO parcelas_geometries (smp, geometry) SELECT \'subte\'||gid AS smp, ST_Multi(ST_GeomFromText(ST_AsText(ST_Buffer(geometry,0.00005,2)),4326)) FROM subte_geometries',
          'INSERT INTO parcelas_data (smp, tipo2, nombre, created_at, updated_at, is_generated) SELECT \'subte\'||gid AS smp, \'ESTACION SUBTE\' AS tipo2, \'Línea \'||linea||\' - \'||estacion AS nombre, now() AS created_at, now() AS updated_at, true as is_generated FROM subte_geometries'
          ]
      },
      {'type' => 'rar', 'name' => 'espacios-verdes.rar', 'table' => 'espverdes_data', 'opc' => '-d', 'inserts' => [
         'INSERT INTO parcelas_geometries (smp, geometry) SELECT \'everde\'||gid AS smp, geometry FROM espverdes_data',
         'INSERT INTO parcelas_data (smp, tipo2, nombre, created_at, updated_at, is_generated) SELECT \'everde\'||gid AS smp, \'ESPACIO VERDE\' AS tipo2, nombre, now() AS created_at, now() AS updated_at, true as is_generated FROM espverdes_data'
         ]
      },
      {'type' => 'zip', 'name' => 'comisarias.zip', 'table' => 'comisarias_geometries', 'opc' => '-d', 'inserts' => [
          'INSERT INTO parcelas_geometries (smp, geometry) SELECT \'comisa\'||gid AS smp, ST_Multi(ST_GeomFromText(ST_AsText(ST_Buffer(geometry,0.00015,2)),4326)) FROM comisarias_geometries',
          'INSERT INTO parcelas_data (smp, tipo2, nombre, created_at, updated_at, is_generated) SELECT \'comisa\'||gid AS smp, \'COMISARIA\' AS tipo2, nombre, now() AS created_at, now() AS updated_at, true as is_generated FROM comisarias_geometries'
         ]
      }
    ]

    db_name = "gcba-opendata-dev"
    bsas_data_path = "deploy@gcba-opendata-1.trentolabs.com:./bsas.data/"
    output = IO.popen('pwd')
    s = output.readlines.first
    output.close

    # Insert Parcelas data
    run_command('psql -d \'' + db_name + '\' -h localhost -U gcba -c "copy parcelas_data(id,fecha,barrio,seccion,manzana,parcela,smp,calle,nro,calle2,chapa_visible,tipo1,tipo2,pisos,nombre,created_at,updated_at) from \'' + s.chomp + '/db/migrate/uso-suelo-2008-csv2\' DELIMITERS \'|\' csv ENCODING \'utf8\'"',
                'Importing parcelas data...', "Cannot import parcelas data")

    # Add Utils to db
    run_command('psql -d \'' + db_name + '\' -h localhost -U gcba -f ' + s.chomp + '/db/migrate/pg_utils.sql',
                'running pg utils script...', "Cannot run pg utils script")

    # Create the temp directory
    run_command('mkdir -p ' + s.chomp + '/import_tmp', 'creating temp directory', "Cannot create the temp directory")

    # Update sequence for parcelas_data.id
    run_command('psql -d \'' + db_name + '\' -h localhost -U gcba -c "select setval(\'parcelas_data_id_seq\', (select max(id)+1 from parcelas_data))"',
                'Updating parcelas_data.id sequence...', "Cannot update parcelas_data.id sequence")

    # Remove possible files in the temp directory
    run_command('rm -rf ' + s.chomp + '/import_tmp/*', 'remove files in temp directory', "Cannot remove files in the temp directory")

    # Go temp directory  
    Dir.chdir('import_tmp')
    raise "Cannot find the temp directory" if not $?.success?

    # Get dataset files
    cmd = 'rsync -avz '
    data_sets.each do |data|
	    cmd += ' ' + bsas_data_path + data['name']
    end
    cmd += ' .'

    run_command(cmd, 'getting files from ' + bsas_data_path, 'Cannot get files from ' + bsas_data_path)

    # Process dataset files
    data_sets.each do |data|
        
        puts("Working with: #{data['name']}...")
       
        # Unrar/Unzip dataset files
        cmd = (data['type'] == 'zip') ? 'unzip ': 'unrar e '
	      cmd += data['name']

        run_command(cmd, 'uncompressing file ' + data['name'], 'Cannot uncompress file: ' + data['name'])

        # Get shp file
        output = IO.popen('ls *.shp')
        shp = output.readlines.first.chomp
        output.close
        raise "Cannot find dataset shp file in " + data['name']  if not $?.success?

        # Insert data set into db
        cmd = 'shp2pgsql ' + data['opc']  + ' -s 9807:4326 -g geometry -W latin1 -I ' + shp + ' ' + data['table'] + ' | sudo -u postgres psql -d ' + db_name
        run_command(cmd, 'Importing dataset in ' + data['name'] + '...', "Cannot import data set in db")

        # Run data insertion to parcelas_db
        data['inserts'].each do |insert|
            cmd = 'psql -d \'' + db_name + '\' -h localhost -U gcba -c "' + insert  + '"'
            run_command(cmd, 'Moving data from dataset ' + data['name'] + ' to main parcela data/geometries table...', "Cannot import into parcelas data: '#{insert}'")
        end

        # Remove dataset files
        run_command('rm -rf *.shp', 'remove dataset files', "Cannot remove files in the temp directory")
    end

    # Go temp directory  
    Dir.chdir('..')
    raise "Cannot exit the temp directory" if not $?.success?

    # Remove temp directory
    run_command('rm -rf import_tmp', 'removing temp directory', "Cannot remove the temp directory")

    # Sanetizar
    run_command('psql -d \'' + db_name + '\' -h localhost -U gcba -f ' + s.chomp + '/db/migrate/sanetizar.sql',
                'cleaning data...', "Cannot clean data")

    # Populo la tabla para el autocomplete
    run_command('psql -d \'' + db_name + '\' -h localhost -U gcba -f ' + s.chomp + '/db/migrate/populate_search_table.sql',
                'populating autocomplete table...', "Cannot populate autocomplete table")

  end

  def run_command(cmd, desc, error_msg)
    puts desc
    output = IO.popen(cmd)
    puts output.readlines
    output.close
    raise error_msg if not $?.success?
  end
end
