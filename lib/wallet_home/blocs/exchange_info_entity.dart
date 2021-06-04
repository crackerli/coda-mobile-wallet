/// id : "MINA"
/// currency : "MINA"
/// symbol : "MINA"
/// name : "Mina Protocol"
/// logo_url : "https://s3.us-east-2.amazonaws.com/nomics-api/static/images/currencies/MINA.png"
/// status : "active"
/// price : "3.39441967"
/// price_date : "2021-06-02T00:00:00Z"
/// price_timestamp : "2021-06-02T14:47:00Z"
/// market_cap_dominance : "0.0000"
/// num_exchanges : "13"
/// num_pairs : "17"
/// num_pairs_unmapped : "0"
/// first_candle : "2021-04-13T00:00:00Z"
/// first_trade : "2021-04-21T00:00:00Z"
/// first_order_book : "2021-04-15T00:00:00Z"
/// first_priced_at : "2021-04-14T14:25:23.039277Z"
/// rank : "1925"
/// high : "45.06268585"
/// high_timestamp : "2021-05-16T00:00:00Z"
/// 1h : {"volume":"1517838.53","price_change":"0.10834752","price_change_pct":"0.0330","volume_change":"390088.26","volume_change_pct":"0.3459"}

class ExchangeInfoEntity {
  String? id;
  String? currency;
  String? symbol;
  String? name;
  String? logoUrl;
  String? status;
  String? price;
  String? priceDate;
  String? priceTimestamp;
  String? marketCapDominance;
  String? numExchanges;
  String? numPairs;
  String? numPairsUnmapped;
  String? firstCandle;
  String? firstTrade;
  String? firstOrderBook;
  String? firstPricedAt;
  String? rank;
  String? high;
  String? highTimestamp;
  OneHourBean? oneHour;

  static ExchangeInfoEntity? fromMap(Map<String, dynamic>? map) {
    if (map == null) return null;
    ExchangeInfoEntity exchangeInfoEntityBean = ExchangeInfoEntity();
    exchangeInfoEntityBean.id = map['id'];
    exchangeInfoEntityBean.currency = map['currency'];
    exchangeInfoEntityBean.symbol = map['symbol'];
    exchangeInfoEntityBean.name = map['name'];
    exchangeInfoEntityBean.logoUrl = map['logo_url'];
    exchangeInfoEntityBean.status = map['status'];
    exchangeInfoEntityBean.price = map['price'];
    exchangeInfoEntityBean.priceDate = map['price_date'];
    exchangeInfoEntityBean.priceTimestamp = map['price_timestamp'];
    exchangeInfoEntityBean.marketCapDominance = map['market_cap_dominance'];
    exchangeInfoEntityBean.numExchanges = map['num_exchanges'];
    exchangeInfoEntityBean.numPairs = map['num_pairs'];
    exchangeInfoEntityBean.numPairsUnmapped = map['num_pairs_unmapped'];
    exchangeInfoEntityBean.firstCandle = map['first_candle'];
    exchangeInfoEntityBean.firstTrade = map['first_trade'];
    exchangeInfoEntityBean.firstOrderBook = map['first_order_book'];
    exchangeInfoEntityBean.firstPricedAt = map['first_priced_at'];
    exchangeInfoEntityBean.rank = map['rank'];
    exchangeInfoEntityBean.high = map['high'];
    exchangeInfoEntityBean.highTimestamp = map['high_timestamp'];
    exchangeInfoEntityBean.oneHour = OneHourBean.fromMap(map['1h']);
    return exchangeInfoEntityBean;
  }

  Map toJson() => {
    "id": id,
    "currency": currency,
    "symbol": symbol,
    "name": name,
    "logo_url": logoUrl,
    "status": status,
    "price": price,
    "price_date": priceDate,
    "price_timestamp": priceTimestamp,
    "market_cap_dominance": marketCapDominance,
    "num_exchanges": numExchanges,
    "num_pairs": numPairs,
    "num_pairs_unmapped": numPairsUnmapped,
    "first_candle": firstCandle,
    "first_trade": firstTrade,
    "first_order_book": firstOrderBook,
    "first_priced_at": firstPricedAt,
    "rank": rank,
    "high": high,
    "high_timestamp": highTimestamp,
    "1h": oneHour,
  };
}

/// volume : "1517838.53"
/// price_change : "0.10834752"
/// price_change_pct : "0.0330"
/// volume_change : "390088.26"
/// volume_change_pct : "0.3459"

class OneHourBean {
  String? volume;
  String? priceChange;
  String? priceChangePct;
  String? volumeChange;
  String? volumeChangePct;

  static OneHourBean? fromMap(Map<String, dynamic>? map) {
    if (map == null) return null;
    OneHourBean oneHourBean = OneHourBean();
    oneHourBean.volume = map['volume'];
    oneHourBean.priceChange = map['price_change'];
    oneHourBean.priceChangePct = map['price_change_pct'];
    oneHourBean.volumeChange = map['volume_change'];
    oneHourBean.volumeChangePct = map['volume_change_pct'];
    return oneHourBean;
  }

  Map toJson() => {
    "volume": volume,
    "price_change": priceChange,
    "price_change_pct": priceChangePct,
    "volume_change": volumeChange,
    "volume_change_pct": volumeChangePct,
  };
}