import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import '/config/amplifyconfiguration.dart';

class CognitoConfig {
  Future<void> configureAmplify() async {
    final authPlugin = AmplifyAuthCognito();

    try {
      await Amplify.addPlugin(authPlugin);
      await Amplify.configure(amplifyconfig);
      print('Successfully configured Amplify');
    } catch (e) {
      print('Could not configure Amplify: $e');
    }
  }
}
