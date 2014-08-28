#Overview

This is the demo used in the [AppLinks meetup](http://applinkshappyhour.splashthat.com/). The demo shows how you can set up App Links and use Bolts to trigger measurement events that are consumed by Facebook App Events and Parse Analytics.

The repo contains three folders:

  + **AppLinks:** Xcode project that acts as the "target" app. It triggers incoming and back App Links event measurement that are logged on Facebook. It also showcases Facebook sharing.
  + **MeasureAppLinks:** Xcode project that triggers the measuring of outgoing and incoming App Links events by linking to the `AppLinks` app. The measurements are logged on Parse.
  + **CloudCode:** Contains Parse Cloud Code that shows how to set up App Links via a static page and dynamically using Parse's App Links Cloud Module.

# Initial Setup

First clone this repository. Then set up Facebook and Parse apps.

## Facebook
1. Create a [Facebook app](https://developers.facebook.com/apps).
2. Add the iOS platform.

## Parse
1. Create a [Parse app](https://www.parse.com/apps).
2. Setup [Parse Hosting](https://www.parse.com/docs/hosting_guide#hosting) and select a hosting subdomain.
3. Copy the contents under the repo's `CloudCode` directory under your app's local Cloud Code directory. Deploy your code.

# App Links Data Setup

The Xcode projects contain links representing content that you should replace with your own.

## AppLinks App

In this section, you'll create the App Links metadata representing content for the `AppLinks` app. You'll see two flavors in creating the content:

  + Using [Parse Hosting](https://www.parse.com/docs/hosting_guide)
  + Using the [Facebook's App Link Host API](https://developers.facebook.com/docs/graph-api/reference/v2.1/app/app_link_hosts)

Either case shows how you could set things up if you don't have a backend web server.

### The Cat

The web page representing a cat can be found in your Cloud Code's folder, `public/cat.html`. 

If you want to test Facebook sharing from the `App Links` app then:

1. Replace `myapplinktest` with your Parse Hosting subdomain. 
2. Set the `fb:app_id` property to your Facebook app id.
3. Deploy your changes to Parse Hosting.

The canonical URL for your cat content is https://[YOUR_PARSE_SUBDOMAIN]/cat.html. Note it for later use.

### The Dog

1. Create the App Links metadata using [Facebook's App Link Host API](https://developers.facebook.com/docs/graph-api/reference/v2.1/app/app_link_hosts), example:

    ```
% curl https://graph.facebook.com/app/app_link_hosts \
-F access_token="FB_APP_ACCESS_TOKEN" \
-F name="Dog" \
-F ios=' [
    {
      "url" : "applinktest://dog",
      "app_name" : "App Links",
    },
  ]' \
-F web=' {
    "should_fallback" : false,
  }'
```

    Replace `FB_APP_ACCESS_TOKEN` with your Facebook app's access token. You can find it using the [Access Token Tool](https://developers.facebook.com/tools/access_token).
    
    Sample response:

    ```json
{"id":"643402985734299"}
```

2. Get the canonical URL using the ID returned from the previous step, example:

    ```
% curl -G https://graph.facebook.com/643402985734299 \
-d access_token="FB_APP_ACCESS_TOKEN" \
-d fields=canonical_url \
-d pretty=true
```

    Sample response:

    ```json
{
   "canonical_url": "https://fb.me/643402985734299",
   "id": "643402985734299"
}
```

3. Note the canonical URL for later use.

### The Bird

1. Create the App Links metadata using [Facebook's App Link Host API](https://developers.facebook.com/docs/graph-api/reference/v2.1/app/app_link_hosts), example:

    ```
% curl https://graph.facebook.com/app/app_link_hosts \
-F access_token="FB_APP_ACCESS_TOKEN" \
-F name="Bird" \
-F ios=' [
    {
      "url" : "applinktest://bird",
      "app_name" : "App Links",
    },
  ]' \
-F web=' {
    "should_fallback" : false,
  }'
```

    Sample response:

    ```json
{"id":"643486985725899"}
```

2. Get the canonical URL using the ID returned from the previous step, example:

    ```
% curl -G https://graph.facebook.com/643486985725899 \
-d access_token="FB_APP_ACCESS_TOKEN" \
-d fields=canonical_url \
-d pretty=true
```

    Sample response:

    ```json
{
   "canonical_url": "https://fb.me/643486985725899",
   "id": "643486985725899"
}
```

3. Note the canonical URL for later use.

## MeasureAppLinks App

The content for the `MeasureAppLinks` app is generated dynamically using [Parse Hosting](https://www.parse.com/docs/hosting_guide#webapp), specifically using Express and the [App Links Cloud Module](https://www.parse.com/docs/cloud_modules_guide#applinks). This content was set up when you copied over the `CloudCode` folder's content and deployed it. The `cloud/app.js` file sets up the dynamic endpoints:

  + Bird: https://[YOUR_PARSE_SUBDOMAIN]/bird
  + Dog: https://[YOUR_PARSE_SUBDOMAIN]/dog

# Xcode Setup

## AppLinks App

1. Modify `ApLinks-Info.plist`
    + To use your Facebook app id in the `FacebookAppID` property.
    + To use your Facebook app id in the `URL types > Item 0 > URL Schemes > Item 0` property, remember it should be fb[YOUR_APP_ID].
    + To use your Facebook display name in the `FacebookDisplayName` property.
    + To use the same bundle identifier set up on Facebook.
2. Modify `ViewController.m` to use the canonical URLs you set up for the bird, cat, and dog.

## MeasureAppLinks App

1. Modify `AppDelegate.m` to use your Parse application id and client key.
2. Modify `ViewController.m` to use the canonical URLs you set up for the bird and dog.
3. Modify `ViewController.m` and replace `myapplinktest` with your Parse Hosting subdomain.

# Testing

1. Build and run `AppLinks`.
2. Build and run `MeasureAppLinks`
3. Click "Show me a Dog". This should open the `AppLinks` app to it's detail view controller to show an adorable dog, at least I think so. You should also see a link back to the `MeasureAppLinks` app on the top of the view.
4. Click the back link.
5. **Parse analytics:** Check your Parse Analytics dashboard. Go to Events. From the top drop down, select Custom Breakdown. From the side drop down, you should see `AppLinksOutbound` and `AppLinksInbound`. Select each in turn and you should see activity based on your test.
6. **Facebook analytics**: Check your App Events page, (https://www.facebook.com/insights/[YOUR_FB_APP_ID]?section=AppEvents). You should see data for `bf_al_nav_in` and `bf_al_ref_back_out`.

# Images

Attribution:

  + Cat: http://ramosburrito.deviantart.com/art/Orange-Tabby-Cat-88715555

  + Dog: http://pixabay.com/en/dog-dogs-pet-holland-model-214236/

  + Bird: http://commons.wikimedia.org/wiki/File:%22Bird%22_as_painted_by_a_kindergarten_child_-_Flickr_-_Lip_Kee.jpg
