

#import sys
#sys.path.append("/home/atanasna/personal/projects/pf-manager")
#from libs.assets import AssetPrices
from libs.prices import Prices
import boto3
import os
import time

def main(event,context):
    prices = Prices().get_all_from_api()
    poll_time = int(time.time())
    dynamodb = boto3.client('dynamodb')
    
    for key in prices:
        dynamodb.put_item(
            TableName=os.getenv('dynamodb_table'),
            Item={
                "time": {"N":f"{poll_time}"},
                "ticker": {"S":f"{key}/USD"},
                "price": {"N":f"{prices[key]}"}
            }
        )

