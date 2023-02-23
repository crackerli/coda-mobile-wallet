
class ProvidersEntity {
  int? providersCount;
  List<Staking_providersBean?>? stakingProviders;

  static ProvidersEntity? fromMap(Map<String, dynamic>? map) {
    if (map == null) return null;
    ProvidersEntity providersEntityBean = ProvidersEntity();
    providersEntityBean.providersCount = map['providers_count'];
    providersEntityBean.stakingProviders = []..addAll(
      (map['staking_providers'] as List).map((o) => Staking_providersBean.fromMap(o))
    );
    return providersEntityBean;
  }

  Map toJson() => {
    "providers_count": providersCount,
    "staking_providers": stakingProviders,
  };
}

class Staking_providersBean {
  int? addressVerification;
  int? delegatorsNum;
  String? discordGroup;
  String? discordUsername;
  String? email;
  String? github;
  String? payoutTerms;
  String? providerAddress;
  double? providerFee;
  int? providerId;
  String? providerLogo;
  String? providerTitle;
  double? stakePercent;
  double? stakedSum;
  String? telegram;
  String? twitter;
  String? website;
  bool chosen = false;

  static Staking_providersBean? fromMap(Map<String, dynamic>? map) {
    if (map == null) return null;
    Staking_providersBean staking_providersBean = Staking_providersBean();
    staking_providersBean.addressVerification = map['address_verification'];
    staking_providersBean.delegatorsNum = map['delegators_num'];
    staking_providersBean.discordGroup = map['discord_group'];
    staking_providersBean.discordUsername = map['discord_username'];
    staking_providersBean.email = map['email'];
    staking_providersBean.github = map['github'];
    staking_providersBean.payoutTerms = map['payout_terms'];
    staking_providersBean.providerAddress = map['provider_address'];
    staking_providersBean.providerFee = map['provider_fee'];
    staking_providersBean.providerId = map['provider_id'];
    staking_providersBean.providerLogo = map['provider_logo'];
    staking_providersBean.providerTitle = map['provider_title'];
    staking_providersBean.stakePercent = map['stake_percent'];
    staking_providersBean.stakedSum = map['staked_sum'];
    staking_providersBean.telegram = map['telegram'];
    staking_providersBean.twitter = map['twitter'];
    staking_providersBean.website = map['website'];
    return staking_providersBean;
  }

  Map toJson() => {
    "address_verification": addressVerification,
    "delegators_num": delegatorsNum,
    "discord_group": discordGroup,
    "discord_username": discordUsername,
    "email": email,
    "github": github,
    "payout_terms": payoutTerms,
    "provider_address": providerAddress,
    "provider_fee": providerFee,
    "provider_id": providerId,
    "provider_logo": providerLogo,
    "provider_title": providerTitle,
    "stake_percent": stakePercent,
    "staked_sum": stakedSum,
    "telegram": telegram,
    "twitter": twitter,
    "website": website,
  };
}