# swift-todo-app
A simple todo app written in Swift using the Vapor framework. A little project of mine coded in 1 day to get to know the basic of Vapor/Swift.

Setting it up is very easy. Just create and .env with the keys defined in `sourcs/configure.swift`. 

Then run the migrate command. (What I did is adding the migrate argument to the current scheme and turning it off/on when needed)

Run the app and it should start on a localhost server. The index should automatically redirect you to the /todos endpoint.


Yes this project only uses GET endpoints, And yes I was too tired to implement axios and/or forms in the leaf views. This is supposed to be an easy and small project :)
