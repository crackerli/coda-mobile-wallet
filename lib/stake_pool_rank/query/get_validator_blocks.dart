
const GET_POOL_BLOCKS = r'''
  query GetPoolBlocksQuery($creator: String!, $minEpoch: Int!) {
    blocks(query: {creator: $creator, protocolState: {consensusState: {epochCount_gt: $minEpoch}}}, limit: 4000, sortBy: BLOCKHEIGHT_ASC) {
      blockHeight
      canonical
      protocolState {
        consensusState {
          epoch
        }
      }
    }
  }
''';