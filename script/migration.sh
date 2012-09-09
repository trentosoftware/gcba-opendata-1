#/bin/bash
echo -e "class Dataset < ActiveRecord::Migration\n  def up" > 20120908210557_dataset.rb
head -n 10 uso-suelo-2008.csv | sed -e "s/^/ParcelasData\.create \:fecha => /" | sed "s/|/, \:barrio => /" | sed "s/|/, \:seccion => /" | sed "s/|/, \:manzana => /" | sed "s/|/, \:parcela => /" | sed "s/|/, \:smp => /" | sed "s/|/, \:calle => /" | sed "s/|/, \:nro => /" | sed "s/|/, \:calle2 => /" | sed "s/|/, \:chapa_visible => /" | sed "s/|/, \:tipo1 => /" | sed "s/|/, \:tipo2 => /" | sed "s/|/, \:pisos => /" | sed "s/|/, \:nombre => /" >> 20120908210557_dataset.rb
echo -e "  end\n\n  def down\n  end\nend\n" >> 20120908210557_dataset.rb




