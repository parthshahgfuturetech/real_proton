class GraphQlStrings{


  static String getUserTransactionsQuery =  """
      query GetUserTransactions(\$id: ID!) {
        user(id: \$id) {
          id
          transactions {
            amount
            blockTimestamp
            transactionHash
            usdaddress
            blockNumber
          }
        }
      }
      """;



}