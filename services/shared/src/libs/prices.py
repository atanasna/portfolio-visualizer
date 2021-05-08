import requests 
import json
import boto3
import time

from requests import Request, Session
from requests.exceptions import ConnectionError, Timeout, TooManyRedirects
from datetime import date

from boto3.dynamodb.conditions import Key
from boto3.dynamodb.conditions import Attr

class Prices:
    def get_all_from_api(self):
        prices = {}
        # Populate Metals
        metals_prices = self.__poll_metals()
        prices["XAU"] = metals_prices["gram_in_usd"]
        prices["XAG"] = metals_prices["silver_gram_in_usd"]

        # Populate Crypto
        cryptos = ["BTC", "ETH", "XRP", "LINK", "ADA", "UNI", "OMG", "ENJ"]
        crypto_prices = self.__poll_cryptos(cryptos)
        for crypto in cryptos:
            prices[crypto] = crypto_prices["data"][crypto]["quote"]["USD"]["price"]
        
        # Populate Stonks
        stocks = ["DBX","WORK","BYND","TSLA","PFE"]
        stock_prices = self.__poll_stocks(stocks)
        for stock in stocks:
            prices[stock] = stock_prices[stock]["c"]
        
        return prices

    def get_one_from_dynamodb(self, dynamodb_table, symbol):
        dynamodb = boto3.resource('dynamodb')
        table = dynamodb.Table(dynamodb_table)
        results = table.query(IndexName="TickerIndex",KeyConditionExpression=Key('ticker').eq(f"{symbol}/USD") & Key('time').gt(int(time.time())-15*60)) 
        return float(results["Items"][0]["price"])

    def get_many_from_dynamodb(self, dynamodb_table, symbols):
        prices = {}
        for symbol in symbols:
            prices[symbol] = self.get_one_from_dynamodb(dynamodb_table, symbol)
        return prices

    def __poll_metals(self):
        api_key = "26e8ce55665d16719f1a72cdf95546ee26e8ce55"
        url = f"http://goldpricez.com/api/rates/currency/usd/measure/gram/metal/all"

        headers={
            "X-API-KEY" : api_key,
            "Content-Type": "application/json"
        }
        # sending get request and saving the response as response object 
        r = requests.get(url = url, headers = headers) 
        
        # extracting data in json format 
        return json.loads(r.json())

    def __poll_cryptos(self,symbols):
        api_key = "546003e8-b701-4b0c-811f-456f23ef8e1a" # key for coinmarketcap.com 333 requests per day

        url = 'https://pro-api.coinmarketcap.com/v1/cryptocurrency/quotes/latest'
        parameters = {
            'symbol':','.join(symbols)
        }
        headers = {
            'X-CMC_PRO_API_KEY': api_key,
            "Content-Type": "application/json"
        }

        session = Session()
        session.headers.update(headers)

        try:
            response = session.get(url, params=parameters)
            return json.loads(response.text)
        except (ConnectionError, Timeout, TooManyRedirects) as e:
            print(e)

    def __poll_stocks(self,symbols):
        api_key = "bu9j4jv48v6tjsddpq7g"
        url = 'https://finnhub.io/api/v1/quote'
        headers = {
            "X-Finnhub-Token" : api_key,
            "Content-Type": "application/json"
        }

        results = {}
        for symbol in symbols:
            parameters = {
                'symbol': symbol
            }
            response = requests.get(url = url, headers = headers, params=parameters) 
            results[symbol] = json.loads(response.text)
        return results