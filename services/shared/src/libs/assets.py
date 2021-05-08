class Asset:
    def __init__(self, symbol, volume):
        self.symbol = symbol
        self.volume = volume
        
class Commodity(Asset):
    def to_oz(self):
        # ounce to gram: 1oz = 28.3495g
        return self.volume/28.3495
    def to_toz(self):
        # troi ounce to gram: 1toz = 31.1035g
        return self.volume/31.1035
    def get_value(self, asset_prices):
        return asset_prices[self.symbol]*self.volume
    def get_type(self):
        return "commodity"
    
class Crypto(Asset):
    def get_value(self, asset_prices):
        return asset_prices[self.symbol]*self.volume
    def get_type(self):
        return "crypto"

class Equity(Asset):
    def get_value(self, asset_prices):
        return asset_prices[self.symbol]*self.volume
    def get_type(self):
        return "equity"