#include "connect_Client.h"

#include <iostream>

int main() {

  const char* local_Host = "127.0.0.1"; //local host ip address
  int paper_Port = 7497; //paper trading default port
  int client_Id = 0; //default client id
  connect_Client connection;

  bool connectBool = connection.connect(local_Host, paper_Port, client_Id);

  if(connectBool == false){
    std::cout << "Connection Issue" << std::endl;
    return -1;
  } else {
    std::cout <<"Connection Success" << std::endl;
  }

  return 0;
}
