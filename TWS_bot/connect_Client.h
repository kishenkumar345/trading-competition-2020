#pragma once
#ifndef CONNECT_CLIENT
#define CONNECT_CLIENT

#include "client/EWrapper.h" //delivers information to the TWS client application
#include "client/EReaderOSSignal.h" //signals that a message is ready to be processed in a queue
#include "client/EReader.h"
#include "client/EClientSocket.h"

class connect_Client : public EWrapper {
  public:
    connect_Client(); //constructor used to send messages to TWS, read and parse information from TWS and hold messages in queue for processing.
    ~connect_Client();
    void disconnect() const;
	  bool check_Connected() const;
    bool connect(const char*, int, int); //creates socket connection to TWS/IBG
  public: //prototype virtual functions
    #include "client/EWrapper_prototypes.h"
  private:
    EReaderOSSignal message_Ready_Process;
    EClientSocket* const send_Message;
    EReader* read_Parse_Message;
    bool extra_Auth;
};

#endif
