import 'package:get_it/get_it.dart';
import 'package:rickandmorty/services/global_update_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:rickandmorty/services/api_service.dart';
import 'package:rickandmorty/services/preferences_service.dart';

//setupLocator() fonksiyonu,
//uygulamanın başlangıcında çağrılarak bazı servislerin (örneğin PreferencesService ve ApiService)
//tek bir örneğini (singleton) oluşturur ve bunları global olarak erişilebilir hale getirir.
//Böylece uygulamanın herhangi bir yerinde locator.get<PreferencesService>() gibi ifadelerle bu servislere ulaşabilirsin.

final locator = GetIt.instance;

Future<void> setupLocator() async {
  final prefs = await SharedPreferences.getInstance();
  locator.registerLazySingleton<PreferencesService>(
    () => PreferencesService(prefs: prefs),
  );
  locator.registerLazySingleton<ApiService>(() => ApiService());
  locator.registerLazySingleton<GlobalUpdateNotifier>(
    () => GlobalUpdateNotifier(),
  );
}


//get_it: Flutter'da service locator desenini uygulamak için kullanılan bir paket.

//shared_preferences: Kalıcı veri saklamak için kullanılır (örneğin kullanıcı tercihleri).

//PreferencesService: Muhtemelen shared_preferences’ı saran, kendi yazdığın bir servis sınıfı.

//ApiService: API isteklerini yöneten servis sınıfı.

