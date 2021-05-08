import json

eur_to_usd = 0.845
class Portfolio():

    def __init__(self, name):
        self.name = name
        self.assets = []
    
    def print(self, asset_prices):
        total_metals = sum([asset.get_value(asset_prices) for asset in self.assets if asset.get_type()=="commodity"])#sum([metal.get_value(ap) for metal in metals])
        total_cryptos = sum([asset.get_value(asset_prices) for asset in self.assets if asset.get_type()=="crypto"])
        total_stocks = sum([asset.get_value(asset_prices) for asset in self.assets if asset.get_type()=="equity"])
        total = total_metals + total_cryptos + total_stocks

        print(f"-".ljust(50,"-"))
        print(f"Portfolio - {self.name}") 
        print(f"-".ljust(50,"-"))
        print(f"Commodities : {(str(int(total_metals*eur_to_usd))+' €').ljust(10)} : ({round(total_metals*100/total,1)}%)")
        print(f"Cryptos     : {(str(int(total_cryptos*eur_to_usd))+' €').ljust(10)} : ({round(total_cryptos*100/total,1)}%)")
        print(f"Equities    : {(str(int(total_stocks*eur_to_usd))+' €').ljust(10)} : ({round(total_stocks*100/total,1)}%)")
        print(f"-".ljust(50,"-"))
        print(f"{'Type'.ljust(11)} : ", end="") 
        print(f"{'Symbol'.ljust(6)} : ", end="") 
        print(f"{'Value'.ljust(10)} : ", end="") 
        print(f"{'%'.ljust(4)} : ", end="") 
        print(f"{'Volume'}")
        print(f"-".ljust(50,"-"))
        for asset in self.assets:
            print(f"{asset.get_type().ljust(11)} : ", end="") 
            print(f"{asset.symbol.ljust(6)} : ", end="") 
            print(f"{(str(int(asset.get_value(asset_prices)*eur_to_usd))+' €').ljust(10)} : ", end="") 
            print(f"{(str(round(asset.get_value(asset_prices)*100/total,1))).ljust(4)} : ", end="") 
            print(f"{asset.volume}") 

        print(f"-".ljust(50,"-"))
        print(f"Total       : {int(total*eur_to_usd)} € : {int(total)} $" )
        print(f"-".ljust(50,"-"))
    
    def to_json(self, asset_prices):
        total_metals = sum([asset.get_value(asset_prices) for asset in self.assets if asset.get_type()=="commodity"])#sum([metal.get_value(ap) for metal in metals])
        total_cryptos = sum([asset.get_value(asset_prices) for asset in self.assets if asset.get_type()=="crypto"])
        total_stocks = sum([asset.get_value(asset_prices) for asset in self.assets if asset.get_type()=="equity"])
        total = total_metals + total_cryptos + total_stocks

        res = {
            "name": self.name,
            "categories": {
                "commodities" : {
                    "eur": int(total_metals*eur_to_usd),
                    "usd": int(total_metals),
                    "percentage": round(total_metals*100/total,2)
                },
                "cryptos" : {
                    "eur": int(total_cryptos*eur_to_usd),
                    "usd": int(total_cryptos),
                    "percentage": round(total_cryptos*100/total,2)
                },
                "equities" : {
                    "eur": int(total_stocks*eur_to_usd),
                    "usd": int(total_stocks),
                    "percentage": round(total_stocks*100/total,2)
                },
            },
            "assets" : [],
            "total" : {
                "eur": int(total*eur_to_usd),
                "usd": int(total)
            }
        }
        for asset in self.assets:
            asset_json = {
                "type" : asset.get_type(),
                "symbol" : asset.symbol,
                "value" : {
                    "usd" : int(asset.get_value(asset_prices)),
                    "eur" : int(asset.get_value(asset_prices)*eur_to_usd)
                },
                "volume" : asset.volume,
                "percentage" : round(asset.get_value(asset_prices)*100/total,1)
            }
            res["assets"].append(asset_json)

        #print(res)
        return res
