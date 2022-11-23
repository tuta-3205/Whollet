import UIKit
import Reusable

final class AddressViewController: UIViewController, StoryboardSceneBased {
    static let sceneStoryboard = UIStoryboard(name: "AddressViewController", bundle: nil)

    @IBOutlet private weak var bottomView: UIView!
    @IBOutlet private var heightConstants: [NSLayoutConstraint]!
    @IBOutlet private weak var sendICXButton: UIButton!
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var scrollViewBottom: NSLayoutConstraint!
    @IBOutlet weak var eyeButton: UIButton!    
    @IBOutlet weak var addressTextField: UITextField!
    private weak var appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    private var isExpand = false
    
    private var isShow = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }
    
    private func configView() {
        for height in heightConstants {
            height.constant *= UIScreen.resizeHeight
        }
        bottomView.topRadius()
        sendICXButton.fullCornerRadiusWithHeight()
        sendICXButton.resizeTextWithHeight()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardAppear),
            name: UIResponder.keyboardWillShowNotification,
            object: nil)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardDisappear),
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
        sendICXButton.layer.borderWidth = AppConstants.CGFloats.borderWidthButton.rawValue
        sendICXButton.layer.borderColor = UIColor.MyTheme.borderColor.cgColor
        sendICXButton.backgroundColor = .none
        sendICXButton.tintColor = UIColor.MyTheme.primary
        addressTextField.delegate = self
        configNavigatorBar()
    }
    
    private func configNavigatorBar() {
        navigationItem.title = AppConstants.Strings.send.rawValue
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.black,
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 26.0 * UIScreen.resizeHeight)]
        navigationController?.navigationBar.backgroundColor = UIColor.MyTheme.primaryBackground
    }
    
    @objc func keyboardAppear(notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                let keyboardRectangle = keyboardFrame.cgRectValue
                let keyboardHeight = keyboardRectangle.height
            if !isExpand {
                UIView.animate(withDuration: 0.3, animations: {
                    self.scrollViewBottom.constant = keyboardHeight
                })
                isExpand = true
            }
        }
    }
    
    @objc private func keyboardDisappear() {
        if isExpand {
            scrollViewBottom.constant = 0
            isExpand = false
        }
    }
    
    @IBAction func eyeOnTap(_ sender: UIButton) {
        isShow = !isShow
        UIView.animate(withDuration: 0.2, animations: {
            self.eyeButton.setImage(UIImage(named: self.isShow ? "show" : "hide"), for: .normal)
            self.addressTextField.isSecureTextEntry = !self.isShow
        })
    }
    
    @IBAction func sendICXTap(_ sender: UIButton) {
        if let address =  self.addressTextField.text, address != "" {
            self.appDelegate?.transactions.address = address
            self.navigationController?.pushViewController(ConfirmationViewController.instantiate(), animated: true)
        }
        
    }
}

extension AddressViewController: UITextFieldDelegate {
    public func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String) -> Bool {
        guard let oldText = textField.text,
                   let range = Range(range, in: oldText) else {
                 return true
             }
        let newText = oldText.replacingCharacters(in: range, with: string)
        
        if newText.isEmpty {
            sendICXButton.backgroundColor = .none
            sendICXButton.tintColor = UIColor.MyTheme.primary
        } else {
            sendICXButton.backgroundColor = UIColor.MyTheme.primary
            sendICXButton.tintColor = .white
        }
        return true
    }
}
