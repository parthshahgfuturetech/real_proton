import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:real_proton/utils/apis.dart';

class GraphQLService {
  static final HttpLink httpLink = HttpLink(
    ApiUtils.transactionHistory,
  );

  static final ValueNotifier<GraphQLClient> client = ValueNotifier(
    GraphQLClient(
      link: httpLink,
      cache: GraphQLCache(),
    ),
  );
}
