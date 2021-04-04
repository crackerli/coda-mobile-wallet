const APPBAR_HEIGHT = 52;
const APPBAR_TITLE_FONT_SIZE = 68;
const BOTTOM_BAR_ITEM_SIZE = 22;
//const DEFAULT_RPC_SERVER = 'http://207.180.212.167:3085/graphql';
const DEFAULT_RPC_SERVER = FIGMENT_MAINNET_RPC_SERVER;
const DEFAULT_INDEXER_SERVER = FIGMENT_MAINNET_INDEXER_SERVER;
// add your own figment api key here
const FIGMENT_API_KEY = '';
const FIGMENT_MAINNET_RPC_SERVER = 'https://mina-mainnet--graphql.datahub.figment.io/apikey/$FIGMENT_API_KEY/graphql';
const FIGMENT_MAINNET_INDEXER_SERVER = 'https://mina--mainnet--indexer.datahub.figment.io/apikey/$FIGMENT_API_KEY/';
const FIGMENT_DEVNET_RPC_SERVER = 'https://mina-devnet--graphql.datahub.figment.io/apikey/$FIGMENT_API_KEY/graphql';
const FIGMENT_DEVNET_INDEXER_SERVER = 'https://mina--devnet--indexer.datahub.figment.io/apikey/$FIGMENT_API_KEY/';
const RPC_SERVER_KEY = 'rpc_server_key';

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
