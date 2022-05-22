# ERC-223 Implementation

ERC-223 is build on top of ERC-20 standard and it fixes some of the problems with ERC-20:

1. Lack of transfer handling possibility
2. Loss of tokens
3. Token-transactions should match Ethereum ideology of uniformity. When a user wants to transfer tokens, he should always call transfer. It doesn't matter if the user is depositing to a contract or sending to an externally owned account.

Those will allow contracts to handle incoming token transactions and prevent accidentally sent tokens from being accepted by contracts.
