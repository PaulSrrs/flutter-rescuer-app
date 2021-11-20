import 'dart:io';

/// This class is used to retrieve API routes. All the variables of the class are static.
/// All the variables of the class are static in order to be accessible from outside the class.
class RescuerApi {
  static get apiUrl => Platform.isAndroid ? 'http://10.0.2.2:8000/' : 'http://127.0.0.1:8000/';

  static const String getRescuesList = 'rescues/';    /// rescues     -> get all rescues with basic field
  static const String getRescue = 'rescue/';          /// rescue/:uuid -> get a detailed field for a rescue
  static const String postRescue = 'rescues/';        /// rescue/:uuid -> post a rescue
  static const String putRescue = 'rescue/';          /// rescue/:uuid -> put a rescue
  static const String deleteRescue = 'rescue/';       /// rescue/:uuid -> delete a rescue

}