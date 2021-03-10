import 'package:coda_wallet/constant/constants.dart';

// If debugConfig is true, then we will open the http proxy in coda_service.dart, else we will close it.
bool debugConfig = false;

// If using 'TEST_NET_ID', then the generated signature can be only used in Mina testnet, such as TestWorld
// If using 'MAIN_NET_ID', then the generated signature can be only used in Mina main net.
int networkIdConfig = TEST_NET_ID;