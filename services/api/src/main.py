import os
from libs.assets import Commodity
from libs.assets import Crypto
from libs.assets import Equity
from libs.prices import Prices
from libs.portfolio import Portfolio

def main(event,context):
    print(event["params"]["querystring"]["name"])
    
    portfolios = []
    pf1 = Portfolio("atanas")
    pf1.assets = [
        Commodity("XAU", 745),
        Commodity("XAG", 68250),
        Crypto("BTC", 7.28),
        Crypto("ETH", 72),
        Crypto("XRP", 21800),
        Crypto("ADA", 24000),
        Crypto("LINK", 244),
        Crypto("UNI", 244),
        Crypto("OMG", 137),
        Crypto("ENJ", 1200),
        Equity("WORK", 45),
        Equity("DBX", 58),
        Equity("BYND", 10),
        Equity("TSLA",5),
        Equity("PFE",15)
    ]
    pf2 = Portfolio("somo")
    pf2.assets = [
        Crypto("BTC", 7.28)
    ]
    portfolios.append(pf1)
    portfolios.append(pf2)

    present_pf = [pf for pf in portfolios if pf.name == event["params"]["querystring"]["name"]][0]
    prices = Prices().get_many_from_dynamodb(os.getenv('dynamodb_table'), [asset.symbol for asset in present_pf.assets])
    print(prices)
    print(present_pf.to_json(prices))
    return present_pf.to_json(prices)
