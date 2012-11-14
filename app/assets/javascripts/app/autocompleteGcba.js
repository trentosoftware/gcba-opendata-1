var AutocompleteGcba = function(){

    var direccion, createAutocomplete, setCallback, callback, onReadyCallback;

    setCallback = function(cb) {
        callback = cb;
    }

    setAfterRenderCallback = function(cb) {
        onReadyCallback = cb;
    }

    createAutocomplete = function(selector) {
        new usig.AutoCompleter(selector, {
            rootUrl: 'http://servicios.usig.buenosaires.gob.ar/usig-js/2.3/',
            skin: 'usig4',
            onReady: function() {
                onReadyCallback();
            },
            afterSelection: function(option) {
                direccion = option;
            },
            afterGeoCoding: function(pt) {
                if (pt instanceof usig.Punto) {
                    if (direccion instanceof usig.Direccion) {
                        direccion.setCoordenadas(pt);
                    }
                }
                if(direccion instanceof usig.Direccion) {
                    callback(direccion);
                }
            }

        });
    }

    return {
        init : function(selector, afterGeocodingCallback, afterRenderCallback){
            createAutocomplete(selector);
            setCallback(afterGeocodingCallback);
            setAfterRenderCallback(afterRenderCallback);
        }
    }
}();

