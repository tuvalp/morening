const amplifyconfig = '''{
  "UserAgent": "aws-amplify/cli",
  "Version": "1.0",
  "auth": {
    "plugins": {
      "awsCognitoAuthPlugin": {
        "UserAgent": "aws-amplify/cli",
        "Version": "1.0",
        "IdentityManager": {
          "Default": {}
        },
        "CognitoUserPool": {
          "Default": {
            "PoolId": "eu-north-1_87OZfEv9q",
            "AppClientId": "4as2ok8ju7am06f79v913ad6nf",
            "Region": "eu-north-1"
          }
        }
      }
    }
  }
}''';
