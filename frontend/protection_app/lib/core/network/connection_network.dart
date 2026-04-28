
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

abstract interface class ConnectionNetwork {
  Future<bool> get isConnected;
}


class ConnectedNetwworkImp implements ConnectionNetwork{
  final InternetConnection internetConnection;
  ConnectedNetwworkImp(
    {
      required this.internetConnection
    }
  );
  @override
  // TODO: implement isConnected
  Future<bool> get isConnected async =>
    await internetConnection.hasInternetAccess;  
}

