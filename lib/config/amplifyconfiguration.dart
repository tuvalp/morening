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
            "PoolId": "eu-north-1_kir9HcMwt",
            "AppClientId": "3oodcif5kp2brt885at0jceupc",
            "Region": "eu-north-1"
          }
        }
      }
    }
  }
}''';
