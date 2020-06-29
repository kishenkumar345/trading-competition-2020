# Trading Competition 2020

Seed repository for the trading competition, with some example projects you can use to get started/

## Menu

[Trading Tips](TRADING.md)
[IB Client Portal](IB-CLIENT-PORTAL.md)

## Overview

The target is to paper-trade on interactive brokers, to make the most money possible before the competition ends.

You can fork this repo, and start testing your ideas and developing a strategy.

You will have to research a trading strategy, do some back-testing then pitch your investment strategy before you can open the paper trading account.

You can then trade on the interactive broker API and build up your fund as large as possible!

## Pre-requisites

In order to access the Interactive Broker API, you must do this through their custom gateway.  This requires Java, and is located in the

```bash
/ib-client-portal
```

folder.  You are not required to use this to make trades, you can also login to the platform and trade manually, however this is available.

All of the examples are in Ruby, so if you want to run any of the scripts you will need to install the latest Ruby version.  You can either use the Ruby Version Manager (or RVM) if you want to install multiple versions of Ruby (is sometimes required for projects with specific versioning requirements), or you can just install the latest Ruby version from your system's package manager.
