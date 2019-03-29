part of 'main.dart';

Future<FirebaseApp> configureDatabase() async {
  return await FirebaseApp.configure(
      name: 'db2',
      options: Platform.isIOS
        ? const FirebaseOptions(
          googleAppID: '1:959322619782:ios:a1bd959b93903331',
          gcmSenderID: '',
          databaseURL: 'https://scouting-2019-avr-cacf9.firebaseio.com',
        )
        : const FirebaseOptions( // Android
          googleAppID: '1:959322619782:android:a1bd959b93903331',
          apiKey: 'AIzaSyCrWVk5t0-2QchRmzA7_LfOXJ2uXronJc0',
          databaseURL: 'https://scouting-2019-avr-cacf9.firebaseio.com',
        )
  );
}