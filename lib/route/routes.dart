import 'package:coda_wallet/qr_scan/qr_scanner.dart';
import 'package:coda_wallet/send/blocs/send_bloc.dart';
import 'package:coda_wallet/send/blocs/send_token_bloc.dart';
import 'package:coda_wallet/send/screens/send_amount_screen.dart';
import 'package:coda_wallet/send/screens/send_fee_screen.dart';
import 'package:coda_wallet/send/screens/send_from_screen.dart';
import 'package:coda_wallet/send/screens/send_to_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../entry_sheet.dart';

const SendFromRoute = '/SendFromScreen';
const SendToRoute = '/SendToScreen';
const SendAmountRoute = '/SendAmountScreen';
const SendFeeRoute = '/SendFeeScreen';
const QrScanRoute = '/QrScanScreen';

var globalRoutes = {
  '$SendFromRoute': (context) => SendFromScreen(),
  '$SendToRoute': (context) => SendToScreen(),
  '$SendFeeRoute': (context) => BlocProvider<SendBloc>(
    create: (BuildContext context) {
      return SendBloc(null);
    },
    child: SendFeeScreen()
  ),
  '$SendAmountRoute': (context) => SendAmountScreen(),
  '$QrScanRoute': (context) => QrScanScreen(),
};