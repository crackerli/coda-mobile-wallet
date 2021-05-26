const APPBAR_HEIGHT = 52;
const APPBAR_TITLE_FONT_SIZE = 68;
const BOTTOM_BAR_ITEM_SIZE = 22;

// add your own figment api key here
const FIGMENT_API_KEY = 'Put your own figment api key here';
const FIGMENT_MAINNET_RPC_SERVER = 'https://mina-mainnet--graphql.datahub.figment.io/apikey/$FIGMENT_API_KEY/graphql';
const FIGMENT_MAINNET_INDEXER_SERVER = 'https://mina--mainnet--indexer.datahub.figment.io/apikey/$FIGMENT_API_KEY/';
const FIGMENT_DEVNET_RPC_SERVER = 'https://mina-devnet--graphql.datahub.figment.io/apikey/$FIGMENT_API_KEY/graphql';
const FIGMENT_DEVNET_INDEXER_SERVER = 'https://mina--devnet--indexer.datahub.figment.io/apikey/$FIGMENT_API_KEY/';

const STAKETAB_PROVIDERS = 'https://api.staketab.com/mina/get_providers';

// Local stored provider list
const STAKETAB_PROVIDER_KEY = 'staketab_provider_key';

// Encrypted seed
const ENCRYPTED_SEED_KEY = 'encrypted_seed_key';

// Default derived accounts number, only one if app published
const DEFAULT_ACCOUNT_NUMBER = 1;

const GLOBAL_ACCOUNTS_KEY = 'global_accounts_key';

const MINIMAL_FEE_COST = 1000000;
const FEE_COHORT_LENGTH = 80;

// Network id used for signature generated in mina signer
const MAIN_NET_ID = 1;
const TEST_NET_ID = 0;

const SLOT_PER_EPOCH = 7140;

// Key to retrieve current network used, mainnet or testnet
const CURRENT_NETWORK_ID = 'current_network_id_key';

const List<String> RPC_SERVER_LIST = [FIGMENT_DEVNET_RPC_SERVER, FIGMENT_MAINNET_RPC_SERVER];
const List<String> INDEXER_SERVER_LIST = [FIGMENT_DEVNET_INDEXER_SERVER, FIGMENT_MAINNET_INDEXER_SERVER];

const List<String> NETWORK_LIST = ['Testnet', 'Mainnet'];

