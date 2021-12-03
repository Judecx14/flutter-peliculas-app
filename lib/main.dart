import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:peliculas/providers/movies_provider.dart';
import 'package:peliculas/screens/screens.dart';

//Importar todas las pantallas desde el archivo screens.dart, como el modulo compartido en Angular
/*import 'package:peliculas/screens/details_screen.dart';
import 'package:peliculas/screens/home_screen.dart';*/

void main() => runApp(AppState());

//Este widget fue creado para controlar
//Los estados de los providers
class AppState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      //Usamos multiprovider para poder instanciar mas provedores
      providers: [
        //Este crea la instancia del provedor (clase Movie Provider)
        ChangeNotifierProvider(
          create: (_) => MoviesProvider(),
          //Esta propiedad nos ayuda a que imediatamente que inicia la app se crea una instancia de nuestro povider
          lazy: false,
        ),
      ],
      child: MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pelícuas',
      initialRoute: 'home',
      routes: {
        'home': (_) => HomeScreen(), //No es necesario pasarle el contexto
        'details': (_) => DetailsScreen(),
      },
      theme: ThemeData.light().copyWith(
        appBarTheme: const AppBarTheme(
          color: Colors.red,
        ),
      ),
    );
  }
}
