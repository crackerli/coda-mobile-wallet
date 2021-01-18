import 'package:equatable/equatable.dart';

abstract class AccountEvents/* extends Equatable*/ {
  AccountEvents();

  @override
  List<Object> get props => null;
}

class GetAccounts extends AccountEvents {
  int index;

  GetAccounts(this.index) : super();

  @override
  List<Object> get props => null;
}