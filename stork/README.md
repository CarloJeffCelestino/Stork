Publish Instructions:
change site_url
    (Production) https://admin.stork.ph
    (Staging) https://storkph-staging.azurewebsites.net


change firebase reference
    (Production) flutterfire configure --project=storkph-297500
    (Staging) flutterfire configure --project=storkph-staging-a7a08

build
    flutter build apk
    flutter build ios
    flutter build web --web-renderer html

Known issues:
Image network to ByteData not working for web, possible fix by using NetworkAssetBundle