part of 'main.dart';

Future<FirebaseApp> configureDatabase() async {
  return await FirebaseApp.configure(
      name: 'db2',
      options: Platform.isIOS
        ? const FirebaseOptions(
          googleAppID: '1:590951349495:ios:a1bd959b93903331',
          gcmSenderID: '',
          databaseURL: 'https://scouting-2019-sac-2bdd7.firebaseio.com',
        )
        : const FirebaseOptions( // Android
          googleAppID: '1:590951349495:android:a1bd959b93903331',
          apiKey: 'AIzaSyAHmQsrjNA7ZsKPp6poUdG_HeILOOBzCBg',
          databaseURL: 'https://scouting-2019-sac-2bdd7.firebaseio.com',
        )
  );
}