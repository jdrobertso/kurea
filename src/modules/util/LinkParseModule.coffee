module.exports = (Module) ->
  request = require 'request'
  cheerio = require 'cheerio'
  ent = require 'ent'

  class LinkParseModule extends Module
    shortName: "LinkParse"
    helpText:
      default: "I parse your links so people know what they are!"

    constructor: (moduleManager) ->
      super(moduleManager)

      urlRegex = /(https?:\/\/[^\s]+)/g
      @on 'message', (bot, sender, channel, message) =>
        @moduleManager.canModuleRoute @, bot.getServer(), channel, false, =>
          links = message.match urlRegex
          links?.forEach (link) =>
            request link, (e,r,body) =>
              return if not r
              return if r.headers['content-type']?.indexOf('text/html') is -1
              $ = cheerio.load body
              title = $('title').html()?.replace(/\r?\n|\r/g, '').trim()
              return if not title
              title = ent.decode title
              bot.say channel, "#{sender}'s URL » #{title}" if title?


  LinkParseModule
