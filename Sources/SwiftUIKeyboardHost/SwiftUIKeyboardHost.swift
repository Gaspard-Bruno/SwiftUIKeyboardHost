//struct GBKeyboardHost {
//    var text = "Hello, World!"
//}

import SwiftUI
import Foundation

@available(iOS 13.0, tvOS 13.0, *)
@available(OSX, unavailable)
@available(watchOS, unavailable)
public struct SwiftUIKeyboardHost<Content>: View  where Content: View {
    var content: Content
    /// The current height of the keyboard rect.
    @State private var keyboardHeight = CGFloat(0)
    public var paddingFromKeyboard: CGFloat = 50
    
    /// A publisher that combines all of the relevant keyboard changing notifications and maps them into a `CGFloat` representing the new height of the
    /// keyboard rect.
    private let keyboardChangePublisher = NotificationCenter.Publisher(center: .default,
                                                                       name: UIResponder.keyboardWillShowNotification)
        .merge(with: NotificationCenter.Publisher(center: .default,
                                                  name: UIResponder.keyboardWillChangeFrameNotification))
        .merge(with: NotificationCenter.Publisher(center: .default,
                                                  name: UIResponder.keyboardWillHideNotification)
            .map { Notification(name: $0.name, object: $0.object, userInfo: nil) })
        .map { ($0.userInfo?[UIWindow.keyboardFrameEndUserInfoKey] as? CGRect ?? .zero).size.height }
    
    
    public var body: some View {
        content
            .onReceive(keyboardChangePublisher) { height in
                let screenSize: CGRect = UIScreen.main.bounds
                
                let firstResponder = UIResponder.getBoundsOfFirstResponder()
                let componentMaxY = firstResponder.maxY
                
                guard let firstResponderView = UIResponder.getFirstResponderView(), let parentVC = firstResponderView.parentViewController else {
                    self.keyboardHeight = 0
                    return
                }
                
                let position = parentVC.view.convert(parentVC.view.frame.origin, to: nil)
                
                let keyboardHeightHere: CGFloat = height
                
                let shouldMove = (componentMaxY - (screenSize.height - keyboardHeightHere) + self.paddingFromKeyboard ) * -1
                
                if height == 0 {
                    self.keyboardHeight = 0
                } else {
                    if position.y < 0 {
                        self.keyboardHeight = shouldMove + position.y - self.paddingFromKeyboard
                        
                    } else {
                        if  shouldMove < 0 {
                            
                            self.keyboardHeight = shouldMove
                            
                        } else if self.keyboardHeight < shouldMove {
                            
                            self.keyboardHeight = shouldMove - self.keyboardHeight + self.paddingFromKeyboard
                            
                        } else {
                            
                            self.keyboardHeight = 0
                        }
                    }
                }
                
        }
        .offset(y: keyboardHeight )
        .animation(.linear(duration: 0.15))
        
    }
    
    public init(@ViewBuilder _ content: @escaping () -> Content) {
        self.content = content()
    }
    
}
