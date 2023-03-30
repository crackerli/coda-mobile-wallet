import 'dart:convert';

import 'package:coda_wallet/constant/constants.dart';
import 'package:coda_wallet/global/global.dart';
import 'package:coda_wallet/stake_provider/blocs/stake_providers_entity.dart';

// Convert the provider list get from staketab to map for quick access with public key.
// And store it in local storage.
storeProvidersMap(List<Staking_providersBean?>? providers) async {
  if(null == providers || providers.isEmpty) {
    return;
  }

  Map<String, dynamic> mapProviders = Map<String, dynamic>();
  providers.forEach((provider) {
    if(null != provider && null != provider.providerAddress && provider.providerAddress!.isNotEmpty) {
      mapProviders['${provider.providerAddress}'] = provider;
    }
  });

  // Saved the provider list to local storage
  String storeProviders = json.encode(mapProviders);
  await globalPreferences.setString(STAKETAB_PROVIDER_KEY, storeProviders);
}