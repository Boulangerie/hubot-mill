# Description:
#   Example scripts for you to examine and try out.
#
# Notes:
#   They are commented out by default, because most of them are pretty silly and
#   wouldn't be useful and amusing enough for day to day huboting.
#   Uncomment the ones you want to try and experiment with.
#
#   These are from the scripting documentation: https://github.com/github/hubot/blob/master/docs/scripting.md

getRandomItem = (items) => items[Math.floor(Math.random()*items.length)]

module.exports = (robot) ->

  responses = [
    "uk:Hello!"
    "ua:Dobriy den!"
    "es:Hola!"
    "fr:Bonjour!"
    "ru:Zdravstvuyte!"
    "pt:Olá!"
    "dk:Hallo!"
    "de:Hej!"
    "ee:Tere!"
    "it:Ciao"
    "sk:Ahoj"
    "bg:Zdraveĭte"
    "is:Góðan dag"
    "hu:Jó napot"
    "gr:Geia sas"
    "lt:Sveiki"
    "hr:Bok"
    "cz:Ahoj"
    "lu:Moïen"
    "mk:Zdravo"
    "ba:Dobar dan"
    "by:Zdravstvujtie"
    "fi:Hei"
    "no:Hallo"
    "fi:Hallå"
    "pl:Cześć"
    "mt:Bonjour"
    "ro:Salut"
    "rs:Zdravo"
    "si:Živjo"
    "ge:Komentari"
    "tr:Merhaba"
  ]

  robot.hear /(yo|coucou|hello|salut|hey)/i, (res) ->
    randomResponse = getRandomItem(responses).split(':')
    res.reply ":flag-" + randomResponse[0] + ": " + randomResponse[1]
