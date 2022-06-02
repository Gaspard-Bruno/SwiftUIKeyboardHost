# SwiftUIKeyboardHost

## WARNING
This project is deprecated and not maintained anymore. SwiftUI already fixed the keyboard issue addressed by this library so it shouldn't be needed anymore.

## Getting Started

### Usage

Add SwiftUIKeyboardHost containing all the body and at the end add a .background(SwiftUIDismissKeyboard()) to dismiss keyboard


```swift
struct ContentView: View {
    var body: some View {
        SwiftUIKeyboardHost {
            VStack {
                Spacer()
                TextField("Example Title 1", text: .constant(""))
                TextField("Example Title 2", text: .constant(""))
                TextField("Example Title 3", text: .constant(""))
                TextField("Example Title 4", text: .constant(""))
                TextField("Example Title 5", text: .constant(""))
                TextField("Example Title 6", text: .constant(""))
                Spacer()
            }
            
        }
        .background(SwifUIDismissKeyboard())
    }
}
```

## 🚀 Authors

- [@Shozuke](https://www.github.com/Shozuke)
