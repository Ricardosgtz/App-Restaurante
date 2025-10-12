import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  //Funcion-metodo para alamacenar
  Future<void> save(String key, dynamic value) async { //metodo se llama 'save' que va a recibir una llave y un valor
    final prefs = await SharedPreferences.getInstance(); //constante llamada 'prefs' 
    prefs.setString(key, json.encode(value)); //con la contante hacemos uso de setString la cual nos permite gurdar el valor de 'key' y 'value'
  }

  //metodo que nos permite traer o leer la informacion
  Future<dynamic> read(String key) async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getString(key) == null) return null;
    return json.decode(prefs.getString(key)!);
  }

  //metodo para eliminar
  Future<bool> remove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.remove(key);

  }

  //metodo que nos va a permitir saber si hay algun objeto dento de sesion, si el usuario inicio secion o no 
  Future<bool> contains(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(key);

  }


}
