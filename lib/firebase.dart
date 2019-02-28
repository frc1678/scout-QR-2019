part of 'main.dart';

Future<FirebaseApp> configureDatabase() async {
  return await FirebaseApp.configure(
      name: 'db2',
      options: Platform.isIOS
        ? const FirebaseOptions(
          googleAppID: '1:843068951447:ios:a1bd959b93903331',
          gcmSenderID: '',
          databaseURL: 'https://scouting-2019-cvr-e4cf3.firebaseio.com',
        )
        : const FirebaseOptions( // Android
          googleAppID: '1:843068951447:android:a1bd959b93903331',
          apiKey: 'AIzaSyDrW18Djm8-fWEs0npnew27oQ2SwzJ0IHo',
          databaseURL: 'https://scouting-2019-cvr-e4cf3.firebaseio.com',
        )
  );
}