# Veil

![Swift](https://github.com/DanielCardonaRojas/Veil/workflows/Swift/badge.svg)


Easy and flexible string masking utility.

**Features**

- Platform independent (this is a pure swift package, no dependencies)
- Provides masked and unmasked input (process method).
- Easy integration to (UIKit, SwiftUI)
- Input blocking comes free.

## Installation

Veil comes with support for SwiftPM so just copy this repos url into your Xcode project


## Usage

Veil enables string masking by providing a pattern of special characters

To create for instance a date formatter for  `mm / yy` this is as simple as: 

```swift
let dateMask = Veil(pattern: "## / ##") 
let result = dateMask.mask(input: "234") 
// result = "23 / 4"
```

Veil uses a configuration object to specify how to parse the mask pattern.
The default configuration uses `#` to represent any digit and `*` to represent other characters.

Also notice that Veil will pickup any other character such as `/` and spaces as symbols in the pattern and 
will insert them automatically in the resulting string.


## UITextField integration

UITextField integration is simple and doesn't require usage of its delegate.

This how you can accomplish live masking of textfields.

![](demo1.gif)

```swift
let dateMask = Veil(pattern: "## / ##")

@objc func textDidChange(_ sender: UITextField) {
    guard let currentText = sender.text else  {
        return
    }

    sender.text = dateMask.mask(input: currentText, exhaustive: false)
}
```

When performing masking of live input just make sure to use the exhaustive option set to `false` 

