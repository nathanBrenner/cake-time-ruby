# Cake Time Ruby edition

## Description

This is a Ruby on Rails backend for an Alexa skill. The documentation for creating an Alexa skill from amazon only gives you the options of doing the backend in Node or Python, which seems because they have api helper libraries for those languages and you can hook up an aws lamda function with those languages.

I completed the tutorial with node first, then I mapped over the functionality to Ruby on Rails here.

Rails might be overkill for this, depending on the skill you'd want to build. Primary reason is Alexa only communicates with one endpoint, so that endpoint has to handle different intents from the person using the Alexa skill.

Possible ways to account for this single endpoint would be to break up those complicated steps in the single method on the controller into smaller functions, possibly in the controller's context or helper methods. This is something I might further explore/refactor along with adding test coverage.

Alexa requires an ssl certificate. This skill isn't intended for production use, the code is useful as ways to do more than a simple "hello world" example, so it's sufficient to create an ssl certificate on your local environment with openssl and ngrok, which is why those bits are in the .gitignore, and doesn't prevent any one from cloning this as long as they know how to create an ssl cert. But here's a [link](https://medium.com/@deloris_86936/83e60f2db30a) to help. With that ssl cert created, and ngrok running, the configuration.cnf needs the full url in the "forwarding" output from ngrok. You also need to specify the unique bit of that url (the random looking characters) in your environment variables for the `NGROK_ID` key. You should have a file `local_env.yml` in the `config` directory.

## How to use the skill

To get this running locally, `bundle install`, `rails db:migrate`, then `rails server`. GET localhost:3000 will respond with 200 with some reminder text that I could put the documentation that I'm putting in this readme over to that view.

You'll have to setup the invocation, intents, and slots from [Amazon's Alexa developer console](https://developer.amazon.com/). You could follow Amazon's [tutorial](https://developer.amazon.com/en-US/alexa/alexa-skills-kit/get-deeper/tutorials-code-samples/build-an-engaging-alexa-skill/module-1) and ignore anything where they're telling you to work in the code section.

To run the skill in development, say "open cake ruby time". Yes, it's a terrible name, but I had the node version with "cake time" in another skill I created, and you can access all of your created skills and any other existing alexa skills from the testing environment. This invocation has to be unique and my lack of creativity stumbled on that mix

From there, you should be asked for your birthday. You'll have to give the year, day, and month. There's a few ways to make Alexa happy. Once she has what she needs, that data is persisted into the Users table, along with the id of the alexa devise you used.

The next time you hit alexa with "open cake ruby time", and you should be greated with either "Happy birthday" or the number of days till your next birthday.

This only works for one user, so do it again, you need to run `rake db:reset db:migrate`
# cake-time-ruby
