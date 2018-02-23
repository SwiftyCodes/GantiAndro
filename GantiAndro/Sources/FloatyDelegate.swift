
import Foundation

/**
 Optional delegate that can be used to be notified whenever the user
 taps on a FAB that does not contain any sub items.
 */
@objc public protocol FloatyDelegate
{
    /**
     Indicates that the user has tapped on a FAB widget that does not
     contain any defined sub items.
     - parameter fab: The FAB widget that was selected by the user.
     */
    @objc optional func emptyFloatySelected(_ floaty: Floaty)
    
    @objc optional func floatyOpened(_ floaty: Floaty)
    
    @objc optional func floatyClosed(_ floaty: Floaty)
}
