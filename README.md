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

With all the pros from dynamic cells, size classes and easy to setup navigation, it is pretty much a no brainer to use them (I see the eye rolls). Saying that, there has been one major feature missing that still has developers reminiscing about life before the UIStoryboard - Custom initialisers!

What makes this an even more of a painful omission is the fact that if you want to override and default parameters before displaying your view controller you are forced to call ```prepare(for:sender:)``` separately from ```performSegue(withIdentifier:sender:)```, then have to navigate through an ```if-else```, cast back down and finally cast back down your view controller. Not exactly a satisfying replacement for the previous one-liner custom init! That's not to mention the stringly typed api the Storyboards heavily promote.

That's where ```SeguePerformable``` comes in.

The idea is twofold:

- to limit the use of hard coded strings for Segue ID's and provide a clean and simple interface for working with them.
- Create a block based api so that performing and preparing a segue are done in a single footprint.

### Usage

#### look ma! no strings!


- The view controller that is initiating the navigating i.e. the parent view controller, should conform to the protocol.

```
class MyViewController: UIViewController, SeguePerformable {
```
- Next the view controller will now need to declare an enum named ```SegueIdentifier``` of type ```String```

```
   enum SegueIdentifier : String {
        case ProfileViewController
        case SettingsViewController
    }
```
The cases are ```RawRepresentable``` which means that the case name can be represented as a string, therefore it is important that they are typed exactly as they have been defined in the storyboard (no avoiding this YET! - maybe checkout swiftGen).

- Now anytime you need to perform or prepare for a segue, you can use the functions defined in the protocol extension which encapsulate the stock functions from UIViewController, but instead now take an enum


#### I just need some closure

Previously to display a view controller and override a parameter you would do the following

call site:
```
func viewProfile() {
  performSegue(withIdentifier: "ProfileViewController", sender: sender)
}
```

override :
```
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if  segue.identifier == "ProfileViewController" {
            guard let profileViewController = segue.destination as? ProfileViewController else { return }
            profileViewController.user = user
        } else if segueID == "SettingsViewController" {
         //bla bla
        }
    }
```

This has not been replaced with a simple call.

```
func viewProfile() {
    performSegue( .ProfileViewController) { (segue, destination) in
               guard let profileViewController = destination as? ProfileViewController  else { return }
               profileViewController.user = user
           }
}

Notice we no longer use a string as the segue identifier but a SegueIdentifier enum value. Also the ```sender:``` parameter is no longer needed as we can override our view controller parameters immediately.

```

#### The Catch

There is one caveat to get this working smoothly. In ```prepare(for:sender:)``` we have to include the following line:

```
override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

      if senderIsSegueCompletionBlock(sender, segue) { return }

      ...
      ...
      }
  }

This checks if the sender if the completion block we passed in when calling our new ```performSegue``` function.

```

#### Embedded Segues / Container Views

```SeguePerformable``` is fully compatible with embedded segues & container views. In fact they also benefit from the syntax sugar of the ```SegueIdentifier``` enum as shown below

```
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

### Requirements

- iOS 9.0+
- Swift 3+
- Xcode 8+

### Integration

#### CocoaPods

Will be a pod soon :)
