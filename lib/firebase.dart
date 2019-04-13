part of 'main.dart';

Future<FirebaseApp> configureDatabase() async {
  return await FirebaseApp.configure(
      name: 'db2',
      options: Platform.isIOS
        ? const FirebaseOptions(
          googleAppID: '1:959322619782:ios:a1bd959b93903331',
          gcmSenderID: '',
          databaseURL: 'https://scouting-2019-cmp-d43a4.firebaseio.com',
        )
        : const FirebaseOptions( // Android
          googleAppID: '1:354375974134:android:a1bd959b93903331',
          apiKey: 'AIzaSyCeR0ofxDgRkY-vw1-CAN_vmruh6P_k9XU',
          databaseURL: 'https://scouting-2019-cmp-d43a4.firebaseio.com',
        )
  );
}