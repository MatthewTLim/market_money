# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

2. General Requirements

Required Endpoints
You will need to expose the data through a multitude of API endpoints. All of your endpoints should follow these technical expectations:

All endpoints should be fully tested for happy path AND sad path.
All endpoints that return data will expect to return JSON data only
All endpoints should be exposed under an api and version (v0) namespace (e.g. /api/v0/markets)
API will be compliant to the JSON API spec and match our requirements below precisely
Controller actions should be limited to only the standard Rails actions and follow good RESTful convention.
Endpoints such as GET /api/v1/markets/search?parameters will NOT follow RESTful convention, and that’s okay. Consider creating an action that appears restful.
In total, you will create 11 endpoints (9 ReSTful, 2 non-ReSTful)

ReSTful Endpoints:
Market Endpoints
get all markets
get one market
get all vendors for a market
Vendor Endpoints
get one vendor
create a vendor
update a vendor
delete a vendor
MarketVendor Endpoints
create a market_vendor
delete a market_vendor
Non-ReSTful Endpoints:
AR Endpoint
get all markets within a city or state that’s name or description match a string fragment
Consume API Endpoint
get cash dispensers (ATMs) close to a market location

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...
# market_money
