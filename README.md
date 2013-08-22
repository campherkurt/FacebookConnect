# FacebookConnect

Facebook SDK helper class

## What is this ?

A little helper class, that makes working with the Facebook SDK a breeze, as it takes care of including the Facebook JS SDK into the DOM, managing and keeping track of the users Facebook auth status throughout the app, allowing you to do, exactly what you want to do only quicker and easier that before.

## What do you mean quicker than before ?
Using the standard Facebook JS SDK you have to keep track of the user auth status, making sure that the user is logged in before making API calls to facebook, check each API response for an error and provide all the details for sharing modals. This class handles all of the above automatically.

It also keeps a list of all the API calls made before the Facebook object was ready, and only calls it once the object it ready.


### Useage 

##### Basics
Do a simple API call to get the user's basic detail, replace the content in "<â¦>" with your relevant details.

	var fb_settings = {
 	  appId: "<your_FB_app_id>",
      channelUrl: <URL_to_FB_channel>,
      scope: "<Facebook,scope,items,comma,separated>"
    };
  
	var fc = new FacebookConnect(fb_settings,<callback_function>)
	fc.api('/me',<callback_function>);
	
	
### Methods
- `isFbReady()` :
 	
 	Checks the status of the FB object, returns true if the FB object is ready, else false

- `api(URL,callback)` :

 	Checks if the user is logged in with Facebook and has allowed the app access, if the user is authorised, a Facebook API call is made to the URL provided. If the user is not logged in, the default Facebook permissions dialog will appear, and once the user has authorised the app the API call will be executed.
	- **URL** - [ _string_ ] _(required)_ - API URL to call.
	- **callback** - [ _function_ ] - The callback function.
	
- `getLoginStatus(callback,forceCheck)` : 

 	Gets the current login status of the Facebook user.
	- **callback** - [ _function_ ] - The callback function.
	- **forceCheck** - [ _boolean_ ] - Force reloading the login status, defaults to false.

- `login(callback)` :  
 	
 	Attempts to log the user into Facebook.
 	- **callback** - [ _function_ ] - The callback function.

- `logout(callback)` : 

  	Logs the user out of Facebook.
 	- **callback** - [ _function_ ] - The callback function.

- `share(share_settings, callback)` :
 	
 	Display the facebook share dialog, if no _share_settings_ was provided, it will try and populate the settings from the _og:meta_ items in the HTML _< head >_ section.
	- **share_settings** - [ _JSON Object_, _function_ ] Object containing redirect_uri, link, picture, name, caption, description
	- **callback** - [ _function_ ] - The callback function.

- `message(message_settings,callback)` :  [ _JSON Object_, _function_ ]  	
 	Display the facebook message dialog, if no _message_settings_ was provided, it will try and populate the link setting from the current URL.
	- **share_settings** - [ _JSON Object_, _function_ ] Object containing link, to.
	- **callback** - [ _function_ ] - The callback function.
	

- `enableDebug()` : 
	
	Enables debug mode, debug content will be printed out in the browser console

- `disableDebug()` : 

 	Disables debug mode.

- `getSettings()` :

 	Returns the Facebook Settings for the app

- `getAppId()` 

  	Returns the Facebook App ID from the settings

-  `setScope(scope)` :

 	Set the Facebook scope required for the app. 	
	- **scope** - [ _string_ ] Coma separated scope list

-  `getScope()` : 

	Returns the current Facebook app scope.



### Events

- `onError(callback)` : 
 	
  	Triggered whenever a Facebook API error occurs.
 	- **callback** - [ _function_ ] - The callback function.

- `onAuthError(callback)` : 
 	
  	Triggered whenever the user cancelled the Facebook auth dialog.
 	- **callback** - [ _function_ ] - The callback function.

- `onAuthChange(callback)` : 
 	
  	Triggered whenever the user's Facebook auth status changes.
 	- **callback** - [ _function_ ] - The callback function. 
 

#### Chaining methods
FacebookConnect supports chaining methods to make writing your code so much easier.
	
	var fb_settings = {
 	  appId: "<your_FB_app_id>",
      channelUrl: <URL_to_FB_channel>,
      scope: "<Facebook,scope,items,comma,separated>"
    };
  
	var fc = new FacebookConnect(fb_settings,<callback_function>)
	fc.onError(<callback_function>).onAuthError(<callback_function>).api('/me',<callback_function>);
	
	
### License
MIT-License:

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
