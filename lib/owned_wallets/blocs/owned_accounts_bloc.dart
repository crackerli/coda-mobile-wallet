import 'package:flutter_bloc/flutter_bloc.dart';
import '../../service/coda_service.dart';
import 'owned_accounts_events.dart';
import 'owned_accounts_states.dart';
import 'owned_accounts_entity.dart';

class OwnedAccountsBloc extends
    Bloc<OwnedAccountsEvents, OwnedAccountsStates> {

  CodaService _service;
  List<Account> _ownedAccounts;
  String _accountToLock;
  bool _isAccountLoading;

  bool get isAccountLoading => _isAccountLoading;

  OwnedAccountsBloc(OwnedAccountsStates state) : super(state) {
    _service = CodaService();
    _isAccountLoading = false;
    _ownedAccounts = List<Account>();
  }

  newCodaService() => _service = CodaService();

  OwnedAccountsStates get
      initState => FetchOwnedAccountsLoading(_ownedAccounts);

  @override
  Stream<OwnedAccountsStates>
      mapEventToState(OwnedAccountsEvents event) async* {

    if(event is FetchOwnedAccounts) {
      yield* _mapFetchOwnedAccountsToStates(event);
      return;
    }

    if(event is ToggleLockStatus) {
      yield* _mapToggleLockStatusToStates(event);
      return;
    }

    if(event is CreateAccount) {
      yield* _mapCreateAccountToStates(event);
      return;
    }
  }

  Stream<OwnedAccountsStates>
    _mapCreateAccountToStates(CreateAccount event) async* {

    final query = event.mutation;
    final variables = event.variables ?? null;

    try {
      final result = await _service.performMutation(query, variables: variables);

      if (result.hasException) {
        print('graphql errors: ${result.exception.graphqlErrors.toString()}');
        yield CreateAccountFail(result.exception.graphqlErrors[0]);
        return;
      }

      final newAccount = Account(
          publicKey: result.data['createAccount']['account']['publicKey'],
          balance: result.data['createAccount']['account']['balance']['total'],
          locked: result.data['createAccount']['account']['locked']
      );

      _ownedAccounts.add(newAccount);
      yield CreateAccountSuccess(_ownedAccounts);
    } catch (e) {
      print(e);
      yield CreateAccountFail(e.toString());
    } finally {

    }
  }

  Stream<OwnedAccountsStates>
    _mapToggleLockStatusToStates(ToggleLockStatus event) async* {

    final query = event.mutation;
    final variables = event.variables ?? null;
    _accountToLock = variables['publicKey'];

    try {
      final result = await _service.performMutation(query, variables: variables);

      if (result.hasException) {
        print('graphql errors: ${result.exception.graphqlErrors.toString()}');
        yield ToggleLockStatusFail(result.exception.graphqlErrors[0]);
        return;
      }

      Account changed = _ownedAccounts.singleWhere((element) => element.publicKey == _accountToLock);
      final changedAccount = Account(
        publicKey: changed.publicKey,
        balance: changed.balance,
        locked: !changed.locked
      );

      _ownedAccounts = _ownedAccounts
        .map((e) => e.publicKey == _accountToLock ? changedAccount : e)
        .toList();
      yield ToggleLockStatusSuccess(_ownedAccounts);
    } catch (e) {
      print(e);
      yield ToggleLockStatusFail(e.toString());
    } finally {
      _accountToLock = null;
    }
  }

  Stream<OwnedAccountsStates>
    _mapFetchOwnedAccountsToStates(FetchOwnedAccounts event) async* {

    final query = event.query;
    final variables = event.variables ?? null;

    try {
      yield FetchOwnedAccountsLoading(_ownedAccounts);
      _isAccountLoading = true;
      final result = await
        _service.performQuery(query, variables: variables);

      _isAccountLoading = false;
      if(result.hasException) {
        print('graphql errors: ${result.exception.graphqlErrors.toString()}');
        yield FetchOwnedAccountsFail(result.exception.graphqlErrors[0]);
        return;
      }

      _ownedAccounts.clear();
      final List<dynamic> accounts = result.data['ownedWallets'];

      _ownedAccounts = accounts
          .map((e) => Account(
            publicKey: e['publicKey'] as String,
            balance: e['balance']['total'] as String,
            locked: e['locked'] as bool
          ))
          .toList();
      yield FetchOwnedAccountsSuccess(_ownedAccounts);
    } catch (e) {
      print('Fetch owned accounts: $e');
      yield FetchOwnedAccountsFail(e.toString());
    }
  }
}
