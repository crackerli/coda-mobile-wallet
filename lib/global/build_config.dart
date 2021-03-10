import 'package:coda_wallet/constant/constants.dart';

// If debugConfig is true, then we will open the http proxy in coda_service.dart, else we will close it.
// Be sure this global var will be changed by build script.
bool debugConfig = false;

// This will be rewrite while using script to start the building.
int networkIdConfig = TEST_NET_ID;