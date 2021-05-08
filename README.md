# **Portfolio Manager**

## Architecture

![pf-manager architecture][diagram]

The architectrure consists of two separate services:
- app (asset prices poller) - responsible for collecting the current prices of various assets from free internet apis
- api - responsible for several api calls that can be done to pull information about the portfolio
- pfv (portfolio visualizer) - hosts a webpage in a S3 bucket that presents the porfolio in a slightly better way that the json response from the api

### app flow
- 1a: Every 15min an event bridge rule triggers the lambda collector
- 2a: The lambda polls assets prices from various apis
- 3a: The lambda saves all prices in a dynamodb

### pfv flow
- 1b 

### api flow
- 2b: The flow is trigered each time a client initiates a HTTP GET request to the API Gateway
- 3b: The API Gateway forwards the client's request to the visualizer lambda
- 4b: The visualizer lambda collects all needed asset price information from the dynamodb populated by the app service
- 5b: The visualizer converts and properly formats the date and calculates the porfolio holding after which sends a resply back to the API Gateway
- 6b: The API Gateway relays the response back to the client


## Deployment
For normal deployement do the following:
1. Terraform apply inside services/shared/infra - This will deploy some libraries that are used by the lambdas in the actual services
2. Terraform apply inside services/app/infra - This will deploy the APP - Asset Prices Poller service
3. Terraform apply inside services/api/infra - This will deploy the API service
4. Terraform apply inside services/pfv/infra - This will deploy the PFV - Portfolio visualizer service


[diagram]: docs/architecture.png