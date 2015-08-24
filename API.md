# Introduction [Draft](Draft.md) #

Basic summary of REST actions, used by Flex interface but could be used by anything that consumes XML. Note this is obviously not the final API, just a work in progress draft.


## Order API ##

| **Method** | **URL** | **Description** |
|:-----------|:--------|:----------------|
| GET        | /orders |  Lists orders (summary fields: id, created\_at, purchase\_order\_nume, customer\_name, country\_name, order\_status\_name, order\_status\_id, total\_amount\_payable, price\_type\_symbol, price\_type\_dollar\_sign |
| GET        | /orders/[:id] |  Shows Order (all fields) |
| GET        | /orders/new;select\_customer | Returns customers (id, name, country\_name ). Need to get the customer id to create an order |
| GET        | /orders/new?customer\_id=[:customer\_id] | Returns a starting point of an order xml fragment. For the given customer id will prefill the address fields in the order (to be moved to sperate address objects |
| PUT        | /orders/[:id] | Update the order object and save order |
| PUT        | /orders/[:id|;recalculate\_only | Recalculates the order given passed order lines, but doesn't save the order, returns updated order without comitting changes |
| PUT        | /orders/[:id];payment\_selection | Set the payment type for the order |
| PUT        | /orders/[:id];update\_status | Change the status for the order |

## Products API ##

| **Method** | **URL** | **Description** |
|:-----------|:--------|:----------------|
| GET        | /products | Get unfiltered list of all products |


## Customers API ##

| **Method** | **URL** | **Description** |
|:-----------|:--------|:----------------|
| GET        | /customers | Get list of all customers (unfiltered)  |
| GET        | /customer/[:id] | Gets all details for this customer |
| POST       | /customers/ | Create a new customer with given xml fragment.  |

## Security API ##

| **Method** | **URL** | **Description** |
|:-----------|:--------|:----------------|

