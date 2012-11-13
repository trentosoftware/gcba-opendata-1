ActiveAdmin.register ParcelasData do

  index do
    column :barrio
    column :calle
    column :calle2
    column :chapa_visible
    column :fecha
    column :manzana
    column :nombre
    column :nro
    column :parcela
    column :pisos
    column :seccion
    column :smp
    column :tipo1
    column :tipo2
    column :aliases
    default_actions
  end
  #
  #filter :email
  #
  #form do |f|
  #  f.inputs "Admin Details" do
  #    f.input :email
  #    f.input :password
  #    f.input :password_confirmation
  #  end
  #  f.buttons
  #end
end                                   
