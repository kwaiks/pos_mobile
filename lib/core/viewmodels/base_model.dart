import 'package:flutter/widgets.dart';
import '../enums/state_status.dart';

class BaseModel extends ChangeNotifier {
  StateStatus _state = StateStatus.Unloaded;

  StateStatus get state => _state;

  void setState(StateStatus stateStatus) {
    _state = stateStatus;
    notifyListeners();
  }
}
