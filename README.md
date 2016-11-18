# SeguePerformable
A simple swift protocol that stream lines the use of Segue ID's

## Overview

This is based on the tutorial by Natasha Murashev aka Natasha The Robot, which can be found here: www.natashatherobot.com/protocol-oriented-segue-identifiers-swift/

The idea is to limit the use of hard coded strings for Segue ID's and provide a clean and simple interface for working with them.

This concept can be extended to address similiar issues with cell reuse id's etc 

### Usage

1. The view controller that you are navigating away FROM i.e the parent view controller, should conform to the protocol.

```
class MyViewController: UIViewController, SeguePerformable {
```
2. Next the view controller will now need to declare an enum of type ```SegueIdentifier```

```
   enum SegueIdentifier : String {
        case ProfileViewController
        case GalleryViewController
    }
```
The cases are ```RawRepresentable``` meaning that case name can be represented as a string, therefore it is important that they are typed exactly as they have been defined in the storyboard.

3.




When you need to use your mock data file simply call the ```serializedJSON:from:``` function by passing in the file name (excluding the file extension)

```
 guard let responseData = serializedJSON(from: "mockResponse") else {  return }
```

Currently only supports JSON

### Requirements

- iOS 9.0+
- Swift 3
- Xcode 8

### Integration

#### CocoaPods

Will be a pod soon :)
