# Event Types
Event Types primarily represent sports but aren't called that because they can also represent things such as Politics.
They are a top level grouping of events and markets upon which bets can be placed on the outcome(s)
Examples: Soccer, Basketball, Politics

# Events
Either a group of events or a specific event, can be a league, season, competition, round, tournament or individual match.
Organised in a hierarchy similar to the Betfair navigation data.
hierarchy pattern: https://docs.mongodb.com/manual/tutorial/model-tree-structures-with-ancestors-array/
Examples: An AFL match, PGA tour 2020, US Presedential Election, March Madness, A horse racing meeting, A horse racee

# Markets
Something upon which a bet can be placed the outcome of which is determined by the event with which the market is associated.
Examples: First goal scorer, PGA tournament winner, Winning team of an NBA match

# Runners
Represents a competitor in or possible outcome of a market associated with an event
Examples: A horse, An NBA player, An NBA team, A score range

# Bookmaker
What it says on the tin. We model this so we can scope aliases by them if required and also a place to capture
information we need about them such as URLs API keys etc.

# Aliases

We only need to specify scope to resolve clashes or for mapping to bookmaker ids.

# Querying logic

To use these structures to display predictions with odds comparison, the following queries and logic would be executed:

In the front end a visual table would be specified with a marketId.
Then the client would ask the api for predictions and odds for that market.

Api service would:
Retrieve market from Market collection.
Retrieve event from Event collection using market.eventId
Retrieve eventType from EventType collection using event.eventTypeId
Retrieve the aliases records for market and event from Aliases collection
For each bookmaker in the Bookmaker collection retrieve odds for the market using the ids from the bookmaker-scoped aliases for the market and event.
Retrieve predictions record from Predictions collection for market.
Augement predictions with odds using aliases records for each runner