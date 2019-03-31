<a href="http://appsquickly.github.io/typhoon">![Typhoon](http://appsquickly.github.io/typhoon/typhoon-splash.png)</a>
# <a href="http://appsquickly.github.io/typhoon">Typhoon</a>

Powerful dependency injection for Cocoa and CocoaTouch. Lightweight, yet full-featured and super-easy to use. 

## Not familiar with Dependency Injection? 

Visit <a href="http://appsquickly.github.io/typhoon">the Typhoon website</a> for an introduction. There's also a nice intro over at <a href="https://www.bignerdranch.com/blog/dependency-injection-ios/">Big Nerd Ranch</a>, or <a href="https://www.objc.io/issues/15-testing/dependency-injection/">here's an article</a>, by <a href="http://qualitycoding.org/">John Reid</a>. Quite a few books have been written on the topic, though we're not familiar with one that focuses specifically on Objective-C, Swift or Cocoa yet. 

## Is Typhoon the right DI framework for you? 

Check out the <a href="http://appsquickly.github.io/typhoon/#features">feature list</a>. 

### Looking for a pure Swift Solution?

Typhoon uses the Objective-C runtime to collect metadata and instantiate objects. It powers thousands of Objective-C applications and is also pretty popular for Swift. Nonetheless there are some advantages to using a pure Swift library. 

* <a href="https://github.com/appsquickly/TyphoonSwift">Typhoon Swift</a> is available! It uses 'compile-time' code generation. 
* <a href="https://github.com/jkolb/FieryCrucible">Fiery Crucible</a> is also an excellent light-weight (just one file) and very straight-forward DI library for Swift. 

Both of the above solutions have the 'ObjectGraph' scope (you can read more about it in the docs), which provides a way to assemble a complex object-graph from a blue-print and then retain it as long as needed. This scope was introduced by Typhoon, and is an important consideration for mobile and desktop apps. Moreover, scope management is one of the main advantages to simply applying the DI pattern 'by hand'. 

Please think carefully before choosing a DI library that forces you to write complex adapters, modify your code or tightly couple it to a library. It shouldn't be more complicated than understanding and applying the pattern without a supporting framework.

---------------------------------------

# Usage

* Read the ***Quick Start*** for <a href="https://github.com/appsquickly/typhoon/wiki/Quick-Start">Objective-C</a> or <a href="https://github.com/appsquickly/typhoon/wiki/Swift-Quick-Start">Swift</a>. 
* Here's the <a href="https://github.com/appsquickly/typhoon/wiki/Types-of-Injections">User Guide</a>.
* <a href="http://ios.caph.jp/typhoon/introduction">日本のドキュメンテーション</a>

```swift
let assembly = MyAssembly().activated()
let viewController = assembly.recommendationController() as! RecommendationController
```

# Open Source Sample Applications

* Try the official <a href="https://github.com/appsquickly/typhoon-Swift-Example">Swift Sample Application</a> or <a href="https://github.com/appsquickly/Typhoon-example">Objective-C Sample Application</a>. 
* This sample shows how to <a href="https://github.com/appsquickly/Typhoon-CoreData-RAC-Example">set up Typhoon with Storyboards, Core Data and Reactive Cocoa</a>. 

*Have a Typhoon example app that you'd like to share? Great! Get in touch with us :)*

# Installing 
[![Build Status](https://travis-ci.org/appsquickly/typhoon.svg?branch=master)](https://travis-ci.org/appsquickly/typhoon)
[![codecov](https://codecov.io/gh/appsquickly/Typhoon/branch/master/graph/badge.svg)](https://codecov.io/gh/appsquickly/Typhoon)
![CocoaPods Version](https://cocoapod-badges.herokuapp.com/v/Typhoon/badge.png) [![Pod Platform](https://img.shields.io/cocoapods/p/Typhoon.svg?style=flat)](http://appsquickly.github.io/Typhoon/docs/latest/api/modules.html) [![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage) [![Dependency Status](https://www.versioneye.com/objective-c/typhoon/1.1.1/badge.svg?style=flat)](https://www.versioneye.com/objective-c/typhoon) [![Pod License](https://img.shields.io/cocoapods/l/Typhoon.svg?style=flat)](https://github.com/appsquickly/typhoon/blob/master/LICENSE)

Typhoon is available through <a href="http://cocoapods.org/?q=Typhoon">CocoaPods</a> or <a href="https://github.com/Carthage/Carthage">Carthage</a>, and also builds easily from source.

## With CocoaPods . . . 

### Static Library

```ruby

# platform *must* be at least 5.0
platform :ios, '5.0'

target :MyAppTarget, :exclusive => true do

pod 'Typhoon'

end
```

### Dynamic Framework

If you're using Swift, you may wish to install dynamic frameworks, which can be done with the Podfile shown below: 

```ruby
# platform *must* be at least 8.0
platform :ios, '8.0'

# flag makes all dependencies build as frameworks
use_frameworks!

# framework dependencies
pod 'Typhoon'
```

Simply import the Typhoon module in any Swift file that uses the framework:

```Swift
import Typhoon
```

## With Carthage

```
github "appsquickly/Typhoon"
```

## From Source

Alternatively, add the source files to your project's target or set up an Xcode workspace. 

**NB:** *All versions of Typhoon work with iOS5 and up (and OSX 10.7 and up), iOS8 is only required if you wish to use dynamic frameworks.* 

---------------------------------------

# Feedback

### I'm not sure how to do [xyz]

If you can't find what you need in the Quick Start or User Guides above, then Typhoon users and contributors monitor the Typhoon tag on <a href="http://stackoverflow.com/questions/tagged/typhoon?sort=newest&pageSize=15">Stack Overflow</a>. Chances are your question can be answered there. 

### I've found a bug, or have a feature request

Please raise a <a href="https://github.com/appsquickly/typhoon/issues">GitHub issue</a>.

### Interested in contributing?

 Great! Here's the <a href="https://github.com/appsquickly/typhoon/wiki/Contribution-Guide">contribution guide.</a>

### I'm blown away!

Typhoon is a non-profit, community driven project. We only ask that if you've found it useful to star us on Github or send a tweet mentioning us (<a href="https://twitter.com/appsquickly">@appsquickly</a>). If you've written a Typhoon related blog or tutorial, or published a new Typhoon powered app, we'd certainly be happy to hear about that too. 

Typhoon is sponsored and led by <a href="http://appsquick.ly">AppsQuick.ly</a> with <a href="https://github.com/appsquickly/Typhoon/graphs/contributors">contributions from around the world</a>. 
 
---------------------------------------
© 2012 - 2015 Jasper Blues, Aleksey Garbarev and contributors.



