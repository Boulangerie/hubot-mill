# hubot

hubot is a chat bot built on the [Hubot][hubot] framework. It was
initially generated by [generator-hubot][generator-hubot], and configured to be
deployed on [Heroku][heroku] to get you up and running as quick as possible.

This README is intended to help get you started. Definitely update and improve
to talk about your own instance, how to use and deploy, what functionality he
has, etc!

[heroku]: http://www.heroku.com
[hubot]: http://hubot.github.com
[generator-hubot]: https://github.com/github/generator-hubot

### Running hubot Locally

You can test your hubot by running the following, however some plugins will not
behave as expected unless the [environment variables](#configuration) they rely
upon have been set.

You can start hubot locally by running:

    % bin/hubot

You'll see some start up output and a prompt:

    [Sat Feb 28 2015 12:38:27 GMT+0000 (GMT)] INFO Using default redis on localhost:6379
    hubot>

Then you can interact with hubot by typing `hubot help`.

    hubot> hubot help
    hubot animate me <query> - The same thing as `image me`, except adds [snip]
    hubot help - Displays all of the help commands that hubot knows about.
    ...

### Configuration

A few scripts (including some installed by default) require environment
variables to be set as a simple form of configuration.

Each script should have a commented header which contains a "Configuration"
section that explains which values it requires to be placed in which variable.
When you have lots of scripts installed this process can be quite labour
intensive. The following shell command can be used as a stop gap until an
easier way to do this has been implemented.

    grep -o 'hubot-[a-z0-9_-]\+' external-scripts.json | \
      xargs -n1 -I {} sh -c 'sed -n "/^# Configuration/,/^#$/ s/^/{} /p" \
          $(find node_modules/{}/ -name "*.coffee")' | \
        awk -F '#' '{ printf "%-25s %s\n", $1, $2 }'

How to set environment variables will be specific to your operating system.
Rather than recreate the various methods and best practices in achieving this,
it's suggested that you search for a dedicated guide focused on your OS.

### Scripting

An example script is included at `scripts/example.coffee`, so check it out to
get started, along with the [Scripting Guide](scripting-docs).

For many common tasks, there's a good chance someone has already one to do just
the thing.

[scripting-docs]: https://github.com/github/hubot/blob/master/docs/scripting.md

### external-scripts

There will inevitably be functionality that everyone will want. Instead of
writing it yourself, you can use existing plugins.

Hubot is able to load plugins from third-party `npm` packages. This is the
recommended way to add functionality to your hubot. You can get a list of
available hubot plugins on [npmjs.com](npmjs) or by using `npm search`:

    % npm search hubot-scripts panda
    NAME             DESCRIPTION                        AUTHOR DATE       VERSION KEYWORDS
    hubot-pandapanda a hubot script for panda responses =missu 2014-11-30 0.9.2   hubot hubot-scripts panda
    ...


To use a package, check the package's documentation, but in general it is:

1. Use `npm install --save` to add the package to `package.json` and install it
2. Add the package name to `external-scripts.json` as a double quoted string

You can review `external-scripts.json` to see what is included by default.

##### Advanced Usage

It is also possible to define `external-scripts.json` as an object to
explicitly specify which scripts from a package should be included. The example
below, for example, will only activate two of the six available scripts inside
the `hubot-fun` plugin, but all four of those in `hubot-auto-deploy`.

```json
{
  "hubot-fun": [
    "crazy",
    "thanks"
  ],
  "hubot-auto-deploy": "*"
}
```

**Be aware that not all plugins support this usage and will typically fallback
to including all scripts.**

[npmjs]: https://www.npmjs.com

### hubot-scripts

Before hubot plugin packages were adopted, most plugins were held in the
[hubot-scripts][hubot-scripts] package. Some of these plugins have yet to be
migrated to their own packages. They can still be used but the setup is a bit
different.

To enable scripts from the hubot-scripts package, add the script name with
extension as a double quoted string to the `hubot-scripts.json` file in this
repo.

[hubot-scripts]: https://github.com/github/hubot-scripts

##  Persistence

If you are going to use the `hubot-redis-brain` package (strongly suggested),
you will need to add the Redis to Go addon on Heroku which requires a verified
account or you can create an account at [Redis to Go][redistogo] and manually
set the `REDISTOGO_URL` variable.

    % heroku config:add REDISTOGO_URL="..."

If you don't need any persistence feel free to remove the `hubot-redis-brain`
from `external-scripts.json` and you don't need to worry about redis at all.

[redistogo]: https://redistogo.com/

## Adapters

Adapters are the interface to the service you want your hubot to run on, such
as Campfire or IRC. There are a number of third party adapters that the
community have contributed. Check [Hubot Adapters][hubot-adapters] for the
available ones.

If you would like to run a non-Campfire or shell adapter you will need to add
the adapter package as a dependency to the `package.json` file in the
`dependencies` section.

Once you've added the dependency with `npm install --save` to install it you
can then run hubot with the adapter.

    % bin/hubot -a <adapter>

Where `<adapter>` is the name of your adapter without the `hubot-` prefix.

[hubot-adapters]: https://github.com/github/hubot/blob/master/docs/adapters.md

## Deployment

    % heroku create --stack cedar
    % git push heroku master

If your Heroku account has been verified you can run the following to enable
and add the Redis to Go addon to your app.

    % heroku addons:add redistogo:nano

If you run into any problems, checkout Heroku's [docs][heroku-node-docs].

You'll need to edit the `Procfile` to set the name of your hubot.

More detailed documentation can be found on the [deploying hubot onto
Heroku][deploy-heroku] wiki page.

### Deploying to UNIX or Windows

If you would like to deploy to either a UNIX operating system or Windows.
Please check out the [deploying hubot onto UNIX][deploy-unix] and [deploying
hubot onto Windows][deploy-windows] wiki pages.

[heroku-node-docs]: http://devcenter.heroku.com/articles/node-js
[deploy-heroku]: https://github.com/github/hubot/blob/master/docs/deploying/heroku.md
[deploy-unix]: https://github.com/github/hubot/blob/master/docs/deploying/unix.md
[deploy-windows]: https://github.com/github/hubot/blob/master/docs/deploying/unix.md

## Campfire Variables

If you are using the Campfire adapter you will need to set some environment
variables. If not, refer to your adapter documentation for how to configure it,
links to the adapters can be found on [Hubot Adapters][hubot-adapters].

Create a separate Campfire user for your bot and get their token from the web
UI.

    % heroku config:add HUBOT_CAMPFIRE_TOKEN="..."

Get the numeric IDs of the rooms you want the bot to join, comma delimited. If
you want the bot to connect to `https://mysubdomain.campfirenow.com/room/42`
and `https://mysubdomain.campfirenow.com/room/1024` then you'd add it like
this:

    % heroku config:add HUBOT_CAMPFIRE_ROOMS="42,1024"

Add the subdomain hubot should connect to. If you web URL looks like
`http://mysubdomain.campfirenow.com` then you'd add it like this:

    % heroku config:add HUBOT_CAMPFIRE_ACCOUNT="mysubdomain"

[hubot-adapters]: https://github.com/github/hubot/blob/master/docs/adapters.md

## Restart the bot

You may want to get comfortable with `heroku logs` and `heroku restart` if
you're having issues.


# (Payou - Experiments) Display a widget from sumologic

## Idea

From a Sumologic dashboard widget, be able to display it as an image

## How

Step one : Target the good widget
For now we can't do it easily while the dashboard API from Sumologic is broken.
For now we should link manually id to widget :cry:

Step two : Transform widget data to graph

Thanks to jsdom and highcharts we can transform what sumologic return to a graph.
This process will be manual in a first time for testing purpose, then a bit 
industrialize to display all widget possible. Sumologic seems to use highcharts 
for rendering their widget, so this part shouldn't be hard...

Step three : Transform svg graph to image

For now we will use svg2png, it use phamtomjs in background for extract png from
svg. Not the nicer solution but the easiest for now. Other lib are only wrapper 
of lower image libs. Maybe this latest solution is faster than the previous and 
we should consider it on long term maybe. But this one is harder to implement and
depend on which OS the hubot will run.

Step Four : Host/Send the img to slack

At first sight, Hubot should send image generated.
Not the hardest part, seems slack api have what we need to do it !
We just need to implement that part and we should be done !

Could send it to a third part and just send link in a channel to.

## usefull commands

```
// Will launch the test bouzin !
coffee ./scripts/hubot-sumologic-image-widget/main.coffee

// Will launch the gist test bouzin !
node ./scripts/hubot-sumologic-image-widget/gist.js
```

## Now

- [x] Tests the all chain !
- [x] Use real data from sumologic widget
- [x] Implement some highchart adapters depending of widget
- [x] Add Hubot hear for this dev
- [x] Test on a true slack
- [ ] Graph can be built on highchart or svg template
  - [x] Split how work graph builder for allowing multiple implementation
  - [x] Base on graph type
  - [ ] Add missing graph
- [ ] Clean generated image file
- [ ] Style graph
- [ ] Better logs for be able to track activity
- [x] Use promises !
   - [x] Break callback hell into promise composition
- [ ] Refactor a lot (Again :D ?)
- [ ] Clean it !

## At dev end

- [ ] Remove dev npm scripts
- [ ] Remove tests files
- [ ] Consider to package it 
