# FreeAlert

## Feature
* Show your customized alert with two lines
  * Create your customized view
  * Show alert with your view
  
## Usage
```swift
import FreeAlert

// Create Customized View
let imgView = UIImageView.init(frame: CGRect(x: 0, y: 0, width: 300, height: 150))
imgView.contentMode = .scaleAspectFit
imgView.image = UIImage.init(named: "test")

// Show Alert
        FreeAlert.shared.show(in: self,
                              alertTitle: "Image Alert",
                              alertMessage: "I'm a alert with UIImageView",
                              additionView: imgView,
                              okInfo: ("Ok", {
                                    print("Ok Button Tapped.")
                                }), cancelInfo: ("Cancel", {
                                    print("Cancel Button Tapped.")
                                }),tapDismissEnable: true)
```

## CocoaPod

```ruby
# Podfile
use_frameworks!

target 'YOUR_TARGET_NAME' do
    pod 'FreeAlert'
end

```

Replace `YOUR_TARGET_NAME` and then, in the `Podfile` directory, type:

```bash
$ pod install
```
