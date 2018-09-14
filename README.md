# SeguePerformable
A simple swift protocol that

- Allows Segue ID's to be referenced by enums rather than strings
- Uses a closure api when triggering segues

## Overview

----------------------------------
#### Note:
This idea for this was initially based on a the tutorial by Natasha Murashev aka Natasha The Robot, which can be found here: www.natashatherobot.com/protocol-oriented-segue-identifiers-swift/

----------------------------------

Every year since Xcode introduced storyboards, Apple has heavily invested in the tech pushing a device agnostic mentality.

With all the pros from dynamic cells, size classes and easy-to-setup navigation, it is pretty much a no brainer to use them (I see the eye rolls).

Saying that, there has been one major feature missing that still has developers reminiscing about life before the UIStoryboard - Custom initialisers!

What makes this even more of a painful omission is the fact that if you want to override any default parameters before displaying your view controller you are forced to

- call ```prepare(for:sender:)``` separately from ```performSegue(withIdentifier:sender:)```
- then navigate an ```if``` statment to find the correct id for your view controller
- then finally cast back your view controller from the segues destination view controller.

Not exactly a satisfying replacement for the previous one-liner custom init, and that's not to mention the stringly typed API that Storyboards heavily promote.

That's where ```SeguePerformable``` comes in.

The idea is twofold:

-  Replace the use of hard coded strings for Segue ID's with enums.
- Create a block based API so that triggering a segue and overriding the destination view controller is done in a single footprint, allowing for easier dependacy injection.

### Usage

#### look ma! no strings!

First lets look at how we replace strings with enums when dealing with segue id's.

Firstly the view controller that is initiating the navigating i.e. the parent view controller, should conform to the protocol.

```swift
class MyViewController: UIViewController, SeguePerformable {
```
The view controller will now need to declare an enum named ```SegueIdentifier``` of type ```String```

The enum cases will each be a represenation of a segue id created in the storyboard. The cases are ```RawRepresentable``` which means that the case name can be represented as a string. It is important that they are typed exactly as they have been defined in the storyboard (no avoiding this ... YET!).

```swift
enum SegueIdentifier : String {
     case ProfileViewController
     case SettingsViewController
 }
```

Next we will look at how these enums are used to trigger segues.

#### I just need some closure

Using the above ```SegueIdentifier``` enum, below we look at how triggering segues have been improved using closures.

*Previously*

Previously to display a view controller and override a parameter you would do the following

Triggering a segue:
```swift
func viewProfile() {
  performSegue(withIdentifier: "ProfileViewController", sender: user)
}
```

override :
```swift
override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   if  segue.identifier == "ProfileViewController" {
      guard let profileViewController = segue.destination as? ProfileViewController else { return }
      profileViewController.user = user
   } else if segueID == "SettingsViewController" {
      //bla bla
   }
}
```
*Now*

This has now been replaced with a simple call.

```swift
performSegue(ProfileViewController.self, .ProfileViewController) { (segue, destination) in
     destination.user = user
}
```

Notice that not only do we no longer use a string as the segue identifier as our new ```SegueIdentifier``` enum value, but thanks to the generic nature of the function call, destination is already of the correct type so we do not need to cast it to ProfileViewController

Finally the ```sender:``` parameter is no longer needed as we can now override our view controller parameters immediately in the closure.


There is one caveat to get this working smoothly. In ```prepare(for:sender:)``` we have to include the following line:

```swift
override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   if senderIsSegueCompletionBlock(sender, segue) { return }

   ...
   ...   
}
```

This checks if the sender is the completion block we passed in when calling our new ```performSegue``` function, if it is the protocol extension will automatically call the completion block.

#### Embedded Segues / Container Views

```SeguePerformable``` is fully compatible with embedded segues & container views. In fact they also benefit from the syntax sugar of the ```SegueIdentifier``` enum as shown below

```swift
override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

   if senderIsSegueCompletionBlock(sender, segue) { return }

   switch segueIdentifier(for: segue) {

   case .SettingsViewController:
       guard let settingsViewController = segue.destination as? SettingsViewController else { return }
       self.settingsViewController = settingsViewController
       break
   default: break

   }
}

```

The above example shows a view controller ```SettingsViewController``` which is an embedded container view.

The line ```switch segueIdentifier(for: segue)``` creates a ```SegueIdentifier``` enum value from the UIStoryboardSegue, allowing us to now switch on the ```SegueIdentifier``` to determine which embedded segue triggered this call.

Enjoy!

### Requirements

- iOS 9.0+
- Swift 3+
- Xcode 8+

### Integration

#### CocoaPods

Will be a pod soon :)
