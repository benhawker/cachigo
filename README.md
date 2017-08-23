Introduction

To write the application you can use any language (Elixir and Ruby are prefered, but you can choose anything you feel comfortable with). It should work as a web server. You can post it as a gist, upload to github or send us via email, anything works as long as the code is correct and you send us instructions how to use it.

Background

Whenever you make a search with Kaligo, a lot of things happen under the hood:

we are querying multiple suppliers to find the cheapest hotel
we are calculating the price based on different criteria
we are calculating number of miles the user will get etc
etc.
The task is to write a very simplified version of our hotel search in form of an API server with 1 endpoint. It needs to work in a following way:

Requirements

Request

endpoint needs to accept following parameters: checkin, checkout, destination, guests, and optionally suppliers
when requested, the server needs to fetch the results either from the cache or directly from the suppliers (explained below)
checkin, checkout, destination and guests params can take any value, they're only used to form cache key
the optional "suppliers" parameter allows to determine which suppliers I want to query, and can take following values:
empty (not provided any value), which means that all suppliers should be queried
"suppliers=supplier2" which means only 1 supplier (supplier 2) should be queried
"suppliers=supplier1,supplier3" which means that both supplier 1 and 3 should be queried (but not supplier 2)
Response

Response should be returned in a following format:

[
  {"id": "abcd", "price": 120, "supplier": "supplier1"},
  {"id": "cdef", "price": 200, "supplier": "supplier3"}
]
each hotel should be returned only once (if some hotel is returned by more than 1 supplier, choose the one with lower price)
caching needs to be done per search parameters, e.g. if I search for destination "Singapore" and then for "Rome", the cache cannot be reused
cache should expire after 5 minutes
Caching

For caching response you can use anything you want - whether it's Redis or Memcache or just a simple memory store, everything works. The goal is to cache proper results and to fetch correct content from cache.

Resources

there are 3 suppliers, each of them has different url:
https://api.myjson.com/bins/2tlb8
https://api.myjson.com/bins/42lok
https://api.myjson.com/bins/15ktg
please note that for the simplification and easiness of testing these are static urls, they always return the same values