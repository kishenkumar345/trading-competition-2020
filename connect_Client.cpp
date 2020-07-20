#include "connect_Client.h"

#include <iostream>

connect_Client::connect_Client() :
   message_Ready_Process(2000), //2-seconds timeout
   send_Message(new EClientSocket(this, &message_Ready_Process)),
   read_Parse_Message(0),
   extra_Auth(false)
{

}

connect_Client::~connect_Client(){
  if (read_Parse_Message){
      delete read_Parse_Message;
  }

  delete send_Message;
}

bool connect_Client::connect(const char* host, int port, int client_Id){

   std::cout << "Connecting..." << std::endl;

   bool initial_Connect = send_Message->eConnect(host, port, client_Id, extra_Auth); //create socket connection to TWS/IBG

   if(initial_Connect == false){
     std::cout << "\nCan not connect to host: " << *host << "\n"
     << "Port: " << port << "\n"
     << "Client ID: " << client_Id << std::endl;
     return false;
   } else {
     std::cout << "\nConnected to host: " << *host << "\n"
     << "Port: " << port << "\n"
     << "Client ID: " << client_Id << std::endl;

     read_Parse_Message = new EReader(send_Message, &message_Ready_Process);
     read_Parse_Message->start();//start reading and parsing messages from TWS
     return true;
   }

   return false;
}

void connect_Client::disconnect() const{
  send_Message->eDisconnect();
  std::cout << "You have been disconnected" << std::endl;
}

bool connect_Client::check_Connected() const{
  return send_Message->isConnected();
}

//Must define these functions, part of EWrapper_Prototypes
void connect_Client::tickPrice( TickerId tickerId, TickType field, double price, const TickAttrib& attribs) { }
void connect_Client::tickSize( TickerId tickerId, TickType field, int size) { }
void connect_Client::tickOptionComputation( TickerId tickerId, TickType tickType, double impliedVol, double delta,
	   double optPrice, double pvDividend, double gamma, double vega, double theta, double undPrice) { }
void connect_Client::tickGeneric(TickerId tickerId, TickType tickType, double value) { }
void connect_Client::tickString(TickerId tickerId, TickType tickType, const std::string& value) { }
void connect_Client::tickEFP(TickerId tickerId, TickType tickType, double basisPoints, const std::string& formattedBasisPoints,
	   double totalDividends, int holdDays, const std::string& futureLastTradeDate, double dividendImpact, double dividendsToLastTradeDate) { }
void connect_Client::orderStatus( OrderId orderId, const std::string& status, double filled,
	   double remaining, double avgFillPrice, int permId, int parentId,
	   double lastFillPrice, int clientId, const std::string& whyHeld, double mktCapPrice) { }
void connect_Client::openOrder( OrderId orderId, const Contract&, const Order&, const OrderState&) { }
void connect_Client::openOrderEnd() { }
void connect_Client::winError( const std::string& str, int lastError) { }
void connect_Client::connectionClosed() { }
void connect_Client::updateAccountValue(const std::string& key, const std::string& val,
   const std::string& currency, const std::string& accountName) { }
void connect_Client::updatePortfolio( const Contract& contract, double position,
      double marketPrice, double marketValue, double averageCost,
      double unrealizedPNL, double realizedPNL, const std::string& accountName) { }
void connect_Client::updateAccountTime(const std::string& timeStamp) { }
void connect_Client::accountDownloadEnd(const std::string& accountName) { }
void connect_Client::nextValidId( OrderId orderId) { }
void connect_Client::contractDetails( int reqId, const ContractDetails& contractDetails) { }
void connect_Client::bondContractDetails( int reqId, const ContractDetails& contractDetails) { }
void connect_Client::contractDetailsEnd( int reqId) { }
void connect_Client::execDetails( int reqId, const Contract& contract, const Execution& execution) { }
void connect_Client::execDetailsEnd( int reqId) { }
void connect_Client::error(int id, int errorCode, const std::string& errorString) { }
void connect_Client::updateMktDepth(TickerId id, int position, int operation, int side,
      double price, int size) { }
void connect_Client::updateMktDepthL2(TickerId id, int position, const std::string& marketMaker, int operation,
      int side, double price, int size, bool isSmartDepth) { }
void connect_Client::updateNewsBulletin(int msgId, int msgType, const std::string& newsMessage, const std::string& originExch) { }
void connect_Client::managedAccounts( const std::string& accountsList) { }
void connect_Client::receiveFA(faDataType pFaDataType, const std::string& cxml) { }
void connect_Client::historicalData(TickerId reqId, const Bar& bar) { }
void connect_Client::historicalDataEnd(int reqId, const std::string& startDateStr, const std::string& endDateStr) { }
void connect_Client::scannerParameters(const std::string& xml) { }
void connect_Client::scannerData(int reqId, int rank, const ContractDetails& contractDetails,
	   const std::string& distance, const std::string& benchmark, const std::string& projection,
	   const std::string& legsStr) { }
void connect_Client::scannerDataEnd(int reqId) { }
void connect_Client::realtimeBar(TickerId reqId, long time, double open, double high, double low, double close,
	   long volume, double wap, int count) { }
void connect_Client::currentTime(long time) { }
void connect_Client::fundamentalData(TickerId reqId, const std::string& data) { }
void connect_Client::deltaNeutralValidation(int reqId, const DeltaNeutralContract& deltaNeutralContract) { }
void connect_Client::tickSnapshotEnd( int reqId) { }
void connect_Client::marketDataType( TickerId reqId, int marketDataType) { }
void connect_Client::commissionReport( const CommissionReport& commissionReport) { }
void connect_Client::position( const std::string& account, const Contract& contract, double position, double avgCost) { }
void connect_Client::positionEnd() { }
void connect_Client::accountSummary( int reqId, const std::string& account, const std::string& tag, const std::string& value, const std::string& curency) { }
void connect_Client::accountSummaryEnd( int reqId) { }
void connect_Client::verifyMessageAPI( const std::string& apiData) { }
void connect_Client::verifyCompleted( bool isSuccessful, const std::string& errorText) { }
void connect_Client::displayGroupList( int reqId, const std::string& groups) { }
void connect_Client::displayGroupUpdated( int reqId, const std::string& contractInfo) { }
void connect_Client::verifyAndAuthMessageAPI( const std::string& apiData, const std::string& xyzChallange) { }
void connect_Client::verifyAndAuthCompleted( bool isSuccessful, const std::string& errorText) { }
void connect_Client::connectAck() { }
void connect_Client::positionMulti( int reqId, const std::string& account,const std::string& modelCode, const Contract& contract, double pos, double avgCost) { }
void connect_Client::positionMultiEnd( int reqId) { }
void connect_Client::accountUpdateMulti( int reqId, const std::string& account, const std::string& modelCode, const std::string& key, const std::string& value, const std::string& currency) { }
void connect_Client::accountUpdateMultiEnd( int reqId) { }
void connect_Client::securityDefinitionOptionalParameter(int reqId, const std::string& exchange, int underlyingConId, const std::string& tradingClass,
	const std::string& multiplier, const std::set<std::string>& expirations, const std::set<double>& strikes) { }
void connect_Client::securityDefinitionOptionalParameterEnd(int reqId) { }
void connect_Client::softDollarTiers(int reqId, const std::vector<SoftDollarTier> &tiers) { }
void connect_Client::familyCodes(const std::vector<FamilyCode> &familyCodes) { }
void connect_Client::symbolSamples(int reqId, const std::vector<ContractDescription> &contractDescriptions) { }
void connect_Client::mktDepthExchanges(const std::vector<DepthMktDataDescription> &depthMktDataDescriptions) { }
void connect_Client::tickNews(int tickerId, time_t timeStamp, const std::string& providerCode, const std::string& articleId, const std::string& headline, const std::string& extraData) { }
void connect_Client::smartComponents(int reqId, const SmartComponentsMap& theMap) { }
void connect_Client::tickReqParams(int tickerId, double minTick, const std::string& bboExchange, int snapshotPermissions) { }
void connect_Client::newsProviders(const std::vector<NewsProvider> &newsProviders) { }
void connect_Client::newsArticle(int requestId, int articleType, const std::string& articleText) { }
void connect_Client::historicalNews(int requestId, const std::string& time, const std::string& providerCode, const std::string& articleId, const std::string& headline) { }
void connect_Client::historicalNewsEnd(int requestId, bool hasMore) { }
void connect_Client::headTimestamp(int reqId, const std::string& headTimestamp) { }
void connect_Client::histogramData(int reqId, const HistogramDataVector& data) { }
void connect_Client::historicalDataUpdate(TickerId reqId, const Bar& bar) { }
void connect_Client::rerouteMktDataReq(int reqId, int conid, const std::string& exchange) { }
void connect_Client::rerouteMktDepthReq(int reqId, int conid, const std::string& exchange) { }
void connect_Client::marketRule(int marketRuleId, const std::vector<PriceIncrement> &priceIncrements) { }
void connect_Client::pnl(int reqId, double dailyPnL, double unrealizedPnL, double realizedPnL) { }
void connect_Client::pnlSingle(int reqId, int pos, double dailyPnL, double unrealizedPnL, double realizedPnL, double value) { }
void connect_Client::historicalTicks(int reqId, const std::vector<HistoricalTick>& ticks, bool done) { }
void connect_Client::historicalTicksBidAsk(int reqId, const std::vector<HistoricalTickBidAsk>& ticks, bool done) { }
void connect_Client::historicalTicksLast(int reqId, const std::vector<HistoricalTickLast>& ticks, bool done) { }
void connect_Client::tickByTickAllLast(int reqId, int tickType, time_t time, double price, int size, const TickAttribLast& tickAttribLast, const std::string& exchange, const std::string& specialConditions) { }
void connect_Client::tickByTickBidAsk(int reqId, time_t time, double bidPrice, double askPrice, int bidSize, int askSize, const TickAttribBidAsk& tickAttribBidAsk) { }
void connect_Client::tickByTickMidPoint(int reqId, time_t time, double midPoint) { }
void connect_Client::orderBound(long long orderId, int apiClientId, int apiOrderId) { }
void connect_Client::completedOrder(const Contract& contract, const Order& order, const OrderState& orderState) { }
void connect_Client::completedOrdersEnd() { }
