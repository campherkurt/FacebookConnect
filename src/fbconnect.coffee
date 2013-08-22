"use strict"
((window, undefined_) ->
  #private properties
  fb_settings =
    appId: '' # App ID
    channelUrl: '' # channel URL, work around for old browsers
    status: false # check login status
    cookie: true # enable cookies to allow the server to access the session
    xfbml: false # parse XFBML
    frictionlessRequests: true #https://developers.facebook.com/docs/reference/dialogs/requests/#frictionless_requests
    scope: null

  fbreadyCallback = []
  authResponse = {}
  authStatus = 'unknown'
  fbReady = false
  fbScope = ''
  debug = false

  #private methods
  errorCallback = ()->
  authErrorCallback = ()->
  authChangeCallback = ()->

  extend = (origional,objects...) ->
    for object in objects
        for key, value of object
            origional[key] = value
    return origional

  updateAuthStatus = (response) ->
    if authStatus != response.status
      try
        authStatus = response.status
        authChangeCallback response
        FacebookConnect.log "authStatus changed to #{authStatus}"
      catch err
        FacebookConnect.log("[error] updateAuthStatus: #{err.message}")
        errorCallback response if response['error']
    authResponse = response

  isFunction = (func) ->
    typeof func is "function"

  getMetaTags = ->
    metaTags = document.getElementsByTagName("meta")
    i = 0
    ogMeta = {}
    
    while i < metaTags.length
      property = metaTags[i].getAttribute("property")
      ogMeta[property.substring(3)] = metaTags[i].getAttribute("content")  if property and property.indexOf("og:") is 0
      i++
    ogMeta

  class FacebookConnect
    constructor: (settings = {}, callback = null) ->
      fb_settings = extend fb_settings, settings
      if typeof fb_settings.scope == 'string'
        @setScope fb_settings.scope
      else
        delete fb_settings.scope
      _this = @
      
      #Load Facebook SDK asynchronously
      ((d) ->
        js = undefined
        id = "facebook-jssdk"
        return  if d.getElementById(id)
        js = d.createElement("script")
        js.id = id
        js.async = true
        js.src = "//connect.facebook.net/en_US/all.js"
        d.getElementsByTagName("head")[0].appendChild js
      ) document

      window.fbAsyncInit = ->
        FB.init fb_settings
        FB.Event.subscribe "auth.statusChange", (response) ->
          updateAuthStatus(response)

        fbReady = true
        FacebookConnect.log 'FB object is ready'
        try
          for fbCallParam in fbreadyCallback
            _this.api fbCallParam[0], fbCallParam[1]
        catch err
          FacebookConnect.log("[error] fbreadyCallback: #{err.message}")
        finally
          fbreadyCallback = []

        callback() if isFunction callback
        #FB.Canvas.setAutoGrow()

    isFbReady: ()->
      return fbReady

    api: (url, callback)->
      if fbReady is false
        fbreadyCallback.push [url,callback]
        return @

      errorCheckCallback = (res) ->
        if typeof res["error"] isnt "undefined"
          FacebookConnect.log "[error] API returned an error: #{res.error.message}"
          errorCallback res
        else
          callback res

      _this = @
      @getLoginStatus (response)->
        if authStatus is 'connected'
          FB.api url, errorCheckCallback
        else
          _this.login (loginResponse)->
            _this.api url, callback
      @


    getLoginStatus: (callback,forceCheck = false) ->
      if authStatus isnt 'connected' or forceCheck is true
        FB.getLoginStatus (response) ->
          updateAuthStatus(response)
          callback response if isFunction callback
        , forceCheck
      else
        callback authResponse if isFunction callback
      @

    login: (callback) ->
      FB.login ((response) ->
        if response.authResponse
          callback response  if isFunction(callback)
        else
          authErrorCallback response
          FacebookConnect.log 'User cancelled login or did not fully authorize.'
      ),
        "scope": @getScopeStr()
        "auth_type": "https"
      @
    
    logout: (callback) ->
      FB.logout (response) ->
        callback response if isFunction callback
      
      @

    share: (share_settings = {}, callback) ->
      url = window.location.toString();
      ogMeta = getMetaTags();
      obj =
        method: "feed"
        redirect_uri: url
        link: url
        picture: ogMeta.image || ""
        name: ogMeta.site_name || ""
        caption: ogMeta.caption || ogMeta.site_name || ""
        description: ogMeta.description || ""

      obj = extend(obj,share_settings)

      if isFunction(callback)
        FB.ui obj, callback
      else
        FB.ui obj
      @

    message:(message_settings = {},callback) ->
      url = window.location.toString()
      obj =
        method: "send"
        link: url
        to: ''
      obj = extend(obj,message_settings)
      if isFunction(callback)
        FB.ui obj, callback
      else
        FB.ui obj
      @

    enableDebug: () ->
      debug = true
      @

    disableDebug: () ->
      debug = false
      @

    getSettings: () ->
      fb_settings

    getAppId: () ->
      fb_settings['appId']

    setScope: (scope_srt) ->
      fbScope = {"scope" : "#{scope_srt}"} if typeof scope_srt is "string"
      @

    getScope: () ->
      return fbScope unless fbScope is ""
      return {scope:""}

    getScopeStr: () ->
      return fbScope if fbScope is ""
      return fbScope['scope']

    onError: (callback) ->
      errorCallback = callback if isFunction callback
      @

    onAuthError: (callback) ->
      authErrorCallback = callback if isFunction callback
      @

    onAuthChange: (callback) ->
      authChangeCallback = callback if isFunction callback
      @


    @log = (data) ->
      return unless debug is true
      console.log(data) unless typeof window['console'] is 'undefined' || typeof console['log'] != "function"
  
  window.FacebookConnect = FacebookConnect
) window, `undefined`
