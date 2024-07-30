import 'package:flutter/material.dart';

import '../../../views/widgets/common/custom_dialog.dart';


enum CustomErrors {
  networkError,
  emailOrPasswordError,
  userAlreadyExistsError,
  invalidDataError,
  tokenError,
  appError,
  multiFactorError,
  undefinedError
}

class ErrorHelper {
  static CustomErrors firebaseAuthErrors({required String error}) =>
    switch (error) {
       "network-request-failed"=>
         CustomErrors.networkError,
       "wrong-password"||
       "invalid-credential"||
       "invalid-email"||
       "invalid-password"=>
         CustomErrors.emailOrPasswordError,
       "email-already-in-use"=>
         CustomErrors.userAlreadyExistsError,
       "argument-error"||
       "invalid-continue-uri"||
       "invalid-phone-number"=>
         CustomErrors.invalidDataError,
       "user-token-expired"||
       "code-expired"=>
         CustomErrors.tokenError,
       "app-not-authorized"||
       "app-not-installed"||
       "popup-blocked"||
       "popup-closed-by-user"=>
         CustomErrors.appError,
       "multi-factor-info-not-found"||
       "multi-factor-auth-required"=>
         CustomErrors.multiFactorError,
      _=>
         CustomErrors.undefinedError
    };
  static void firebaseAuthErrorMessage({required CustomErrors error,required BuildContext context})=>switch(error){
    CustomErrors.tokenError=>showTokenErrorAlert(context),
    CustomErrors.networkError=>showNetworkErrorAlert(context),
    _=>showUndefinedErrorAlert(context)
  };


}