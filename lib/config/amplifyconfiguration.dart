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
            "PoolId": "eu-north-1_bTE14xhQm",
            "AppClientId": "7qmha9amnha0gikb9bi0nffa4g",
            "Region": "eu-north-1"
          }
        }
      }
    }
  }
}''';
