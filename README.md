# WetherApi
iOS App built with Xcode 11.4.1 and targeting iOS 12.4+

The app is calling the [OpenWheather API](https://openweathermap.org/api) and is displaying  a list of forecasts. 

[5 day / 3 hour forecast API Documentation](https://openweathermap.org/forecast5)


NOTE The [Dark Sky API](https://darksky.net/dev) can no longer be used:

> We are no longer accepting new signups.
> Please see our [blog post](https://blog.darksky.net/) for more information.

## Security

WIP 

This is a iOS project and ProGuard is made for Java/Android.

An alternative could be [Sirius](https://github.com/Polidea/SiriusObfuscator) but it only supports Xcode 9.2 and Swift 4.0. Xcode 9.2 is not supported by MacOs Catalina.

Also see this blog post about "Open Source Code Obfuscation Tool for Protecting iOS Apps" by [Polidea](https://www.polidea.com/blog/open-source-code-obfuscation-tool-for-protecting-ios-apps/). It is talking about Sirius mentioned above.

There are also a lot of interesting articls on the subject of *Hardening* on the [CRYPTOMAThIC blog](https://www.cryptomathic.com/news-events/blog/), for example [Overview of App & Code Hardening for Mobile Banking Apps](https://www.cryptomathic.com/news-events/blog/overview-of-app-code-hardening-for-mobile-banking-apps) 

An open source library for checking JailBreaking is [DTTJailbreakDetection](https://github.com/thii/DTTJailbreakDetection). One can also follow [this advise on Stackoverflow](https://stackoverflow.com/a/40930618/2081047) and write some code in Obective-C (this Stackoverflow example is not in C/C++)

### Comersial products 
https://www.guardsquare.com/en/products/ixguard

