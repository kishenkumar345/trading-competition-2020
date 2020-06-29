const { LoneSchemaDefinitionRule } = require("graphql");

// Connect to the API
async function asyncFetch(url, options = { method: 'GET'}) {
  url = '/v1/portal' + url;
  return new Promise(function(resolve, reject) {
    if(options.method.toLowerCase() === 'post') {
      options['headers'] = {
        'Content-Type': 'application/json'
      }
    }
    fetch(url, options).then(response => {
      if(response.status == 200) {
        response.json().then(data => {
          resolve([data,null]);
        }).catch(err => {
          console.log("User token check json decode error")
          console.log(err);
          resolve([null,err]);
        });
      } else {
        console.log(response)
        // See if response has returned anything
        var text = ''
        response.json().then(errorJson => { 
          text = `${response.status} - ${response.statusText} (${JSON.stringify(errorJson)})`
          resolve([null, text])
        }).catch(err => {
          text = `${response.status} - ${response.statusText}`
          resolve([null, text])
        })
      }
    }).catch(err => {
      console.log("User token check network error");
      console.log(err);
      resolve([null,err]);
    });
  });
}
// Start the App
function runApp() {
  const vueInstance = new Vue({
    el: '#vueMain',
    data: {
      tempAccounts: [], // Build the accounts object before it gets rendered
      accounts: [],     // What actually gets rendered once object is constructed
      iServerAccounts: [], // For some raisin this might be different
      trades: [],
      connectedToApi: false,
      activeAccount: null,
      getTradesError: null,
    },
    // Initialise the Application
    async mounted() {
      this.tickleLoop();
      await this.loadAccounts()
      await this.loadAccountInformation()
      await this.loadAccountSummary()
      await this.loadAccountLedger()
      await this.loadIServerAccounts()
      // Now render
      this.accounts = this.tempAccounts;
      console.log('Accounts: ', this.accounts)
      console.log('iServer Accounts: ', this.iServerAccounts)
    },
    computed: {
      activeAccountId() {
        return this.activeAccount ? this.activeAccount.id : "None Selected"
      }
    },
    methods: {
      // Keep connection alive
      async tickle() {
        let [data, error] = await asyncFetch('/tickle');
        if(data) {
          this.connectedToApi = true;
        } else {
          this.connectedToApi = false;
          console.log('Tickle Error: ', error)
        }
      },
      // Continuously run in a loop to keep connection alive
      async tickleLoop() {
        this.tickle()
        setTimeout(this.tickleLoop, 1000);
      },
      // Load accounts
      async loadAccounts() {
        let [data, error] = await asyncFetch('/portfolio/accounts');
        if(data) {
          this.tempAccounts = data;
        } else {
          console.log('Get Accounts Error: ', error)
        }
      },
      // For each account, load it's information
      async loadAccountInformation() {
        for(let account of this.tempAccounts){
          let [data, error] = await asyncFetch(`/portfolio/${account.id}/meta`);
          if(data) {
            account.information = data;
          } else {
            console.log('Get Account Information Error: ', error)
          }
        }
      },
      // Now load the summary and attach this also
      async loadAccountSummary() {
        for(let account of this.tempAccounts){
          let [data, error] = await asyncFetch(`/portfolio/${account.id}/summary`);
          if(data) {
            account.summary = data;
          } else {
            console.log('Get Account Information Error: ', error)
          }
        }
      },
      // Now load the ledger and attach this also
      async loadAccountLedger() {
        for(let account of this.tempAccounts){
          let [data, error] = await asyncFetch(`/portfolio/${account.id}/ledger`);
          if(data) {
            account.ledger = data;
          } else {
            console.log('Get Account Information Error: ', error)
          }
        }
      },
      async loadIServerAccounts() {
        let [data, error] = await asyncFetch('/iserver/accounts')
        if(data) {
          this.iServerAccounts = data
        } else {
          console.log('Get iServer Accounts Error: ', error)
        }
      },
      // The mack-daddy, get the trades
      async getTrades(account) {
        this.activeAccount = account;
        // Select the account
        var [data, error] = await asyncFetch('/iserver/account/trades')
        if(error) {
          console.log("Get trades error: ", error)
          this.getTradesError = `Get Trades Error: ${error}`;
          return
        } else {
          this.trades = data;
        }

      },
    }
  });
}