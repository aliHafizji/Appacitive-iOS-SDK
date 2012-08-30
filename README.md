#AppYoda iOS SDK

[AppYoda website](www.appyoda.io)

[Full reference docs](www.appypda.io)

##Getting started

###Using cocoapods (the modern way of doing things)


CocoaPods is a dependency management tool for iOS apps. Using it you can easily express the external libraries (like AppYoda) your app relies on and install them.
Create a new iOS project in Xcode. Here we've created an app named "DarthVador".

    $ cd DarthVador
    $ ls -F
    DarthVador/  DarthVador.xcodeproj/  DarthVadorTests//

We need to create a Podfile to contain our project's configuration for CocoaPods.
    
    $ touch Podfile
    $ open Podfile 

Your Podfile defines your app's dependencies on other libraries. Add AppYoda to it.
    
    platform :ios
    pod 'AppYoda', '0.0.1'

Now you can use CocoaPods to install your dependencies.

    $ pod install

Your now have a workspace containing your app's project and a project build by CocoaPods which will build a static library containing all of the dependencies listed in your Podfile.

    $ ls -F 
    DarthVador/  DarthVador.xcodeproj/  DarthVador.xcworkspace/  DarthVadorTests/  Podfile          Podfile.lock  Pods/

Open the new workspace and you can start developing using the AppYoda library

    $ open DarthVador.xcworkspace

###Using the primitive way

Clone the project using

    git clone https://github.com/tavisca/AppYoda-iOS-SDK.git

Copy the source files into your project (AppYoda-iOS-SDK/Classes) and you're good to go.

#May the force be with you!!