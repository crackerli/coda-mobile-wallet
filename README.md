# StakingPower Wallet
A mina mobile wallet developed by flutter, support both android and ios.

# Declaration
This is a community tool developed under the policy of Mina Project Grants, not developed by o1labs.

# Feature Contents v1.0.0
1. Mina keys and accounts management.
2. Send and receive tokens.
3. Check the transaction lists.
4. Check the transaction detail.
5. Calculate the best fees.

# How to build
1. Clone https://github.com/crackerli/ffi_mina_signer.git
2. Clone https://github.com/crackerli/coda-mobile-wallet.git
3. Edit the path in pubspec.yaml to make sure coda-mobile-wallet project can access ffi_mina_signer project.
4. Config the build settings in pubspec.yaml for build version and build code.
5. Config the build settings in lib/global/build_config.dart, following the comments of the build config variables.
6. Run "flutter build apk" or "flutter build ios" to build android release apk or ios release ipa package.
