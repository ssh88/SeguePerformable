# SeguePerformable
A simple swift protocol that stream lines the use of Segue ID's

## Overview

This is based on the tutorial by Natasha Murashev aka Natasha The Robot, which can be found here: www.natashatherobot.com/protocol-oriented-segue-identifiers-swift/

The idea is to limit the use of hard coded strings for Segue ID's and provide a clean and simple interface for working with them.

This concept can be extended to address similiar issues with cell reuse id's etc 

### Usage

- The view controller that you are navigating away FROM i.e the parent view controller, should conform to the protocol.

```
class MyViewController: UIViewController, SeguePerformable {
```
- Next the view controller will now need to declare an enum named ```SegueIdentifier``` of type ```String```

```
   enum SegueIdentifier : String {
        case ProfileViewController
        case GalleryViewController
    }
```
The cases are ```RawRepresentable``` which means that the case name can be represented as a string, therefore it is important that they are typed exactly as they have been defined in the storyboard (no avoiding this YET! - maybe checkout swiftGen).

- Now anytime you need to perform or prepare for a segue, you can use the functions defined in the protocol extenion which encapsulate the stock functions from UIViewController, but instead now take an enum

#### Perform Segue

##### Previously

```
performSegue(withIdentifier: "ProfileViewController", sender: sender)
```

##### Now

```
performSegue( .ProfileViewController, sender: nil)
```

#### Prepare Segue  

##### Previously

```
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let segueID = segue.identifier
        if segueID == "ProfileViewController" {
            
            guard let profileViewController = segue.destination as? ProfileViewController else { return }
            profileViewController.user = self.user
        } else  if segueID == "GalleryViewController" {
         //bla bla
        
        }
    }
```

##### Now

```
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //protocols make this look so sweet!
        
        switch segueIdentifier(for: segue) {
        case .ProfileViewController:
            guard let profileViewController = segue.destination as? ProfileViewController else { return }
            profileViewController.user = self.user
            break
        case .GalleryViewController:
            break
        }
    }
```

### Requirements

- iOS 9.0+
- Swift 3
- Xcode 8

### Integration

#### CocoaPods

Will be a pod soon :)
