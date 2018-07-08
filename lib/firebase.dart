part of 'main.dart';

Future<FirebaseApp> configureDatabase() async {
  return await FirebaseApp.configure(
      name: 'db2',
      options: Platform.isIOS
        ? const FirebaseOptions(
          googleAppID: '1:77298008643:ios:c32df596c9e96d79',
          gcmSenderID: '',
          databaseURL: 'https://flutter-qr-test.firebaseio.com',
        )
        : const FirebaseOptions( // Android
          googleAppID: '1:77298008643:android:a1bd959b93903331',
          apiKey: 'AIzaSyCvE9mcxD7hLOajU_O6AudbzyYruvzCNmY',
          databaseURL: 'https://flutter-qr-test.firebaseio.com',
        )
  );
}