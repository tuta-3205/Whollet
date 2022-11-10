import Foundation

class BaseViewModel: NSObject {
    var bindViewModelToController : (() -> ()) = { }
}

