import 'package:coda_wallet/send/screens/send_amount_screen.dart';
import 'package:coda_wallet/send/screens/send_fee_screen.dart';
import 'package:coda_wallet/send/screens/send_from_screen.dart';
import 'package:coda_wallet/send/screens/send_to_screen.dart';

import '../entry_sheet.dart';

const SendFromRoute = '/SendFromScreen';
const SendToRoute = '/SendToScreen';
const SendAmountRoute = '/SendAmountScreen';
const SendFeeRoute = '/SendFeeScreen';
//const EntryRoute = '/';

var globalRoutes = {
  '$SendFromRoute': (context) => SendFromScreen(),
  '$SendToRoute': (context) => SendToScreen(),
  '$SendFeeRoute': (context) => SendFeeScreen(),
  '$SendAmountRoute': (context) => SendAmountScreen(),
//  '$EntryRoute': (context) => EntrySheet(),
};