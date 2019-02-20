part of 'main.dart';

Future<FirebaseApp> configureDatabase() async {
  return await FirebaseApp.configure(
      name: 'db2',
      options: Platform.isIOS
        ? const FirebaseOptions(
          googleAppID: '1:413343640093:ios:a1bd959b93903331',
          gcmSenderID: '',
          databaseURL: 'https://field-test-2019.firebaseio.com',
        )
        : const FirebaseOptions( // Android
          googleAppID: '1:413343640093:android:2829f0a89f52ae04',
          apiKey: 'AIzaSyA_veCdf2hSw4HPm0y0t-WUTRzCpyziTfo',
          databaseURL: 'https://field-test-2019.firebaseio.com',
        )
  );
}