import UIKit

final class OnboardingViewController: UIViewController {

    @IBOutlet private weak var splashImage: UIImageView!
    @IBOutlet private weak var indexPage: UIPageControl!
    @IBOutlet private weak var bottomView: UIView!
    @IBOutlet private weak var titleText: UILabel!
    @IBOutlet private weak var descriptionText: UILabel!
    @IBOutlet private weak var nextStepButton: UIButton!
    
    private var index = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }
    
    private func configView() {
        bottomView.layer.cornerRadius = AppConstants.CGFloats.defaultRadius.rawValue
        bottomView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        nextStepButton.fullCornerRadiusWithHeight()
        nextStepButton.layer.borderWidth = AppConstants.CGFloats.borderWidthButton.rawValue
        nextStepButton.layer.borderColor = UIColor.MyTheme.primary.cgColor
        titleText.resizeWithHeight()
        descriptionText.resizeWithHeight()
        nextStepButton.resizeTextWithHeight()
        navigationController?.isNavigationBarHidden = true
        configNextPage()
    }
    
    private func configNextPage() {
        let pageData = AppConstants.onboardings[index]
        splashImage.image = UIImage(named: pageData.image)
        indexPage.currentPage = index
        titleText.text = pageData.title
        descriptionText.text = pageData.description

        let isLastPage = index == AppConstants.onboardings.count - 1
        nextStepButton.setTitle(
            isLastPage
            ? AppConstants.Strings.getStarted.rawValue
            : AppConstants.Strings.nextStep.rawValue,
            for: .normal)
        nextStepButton.setTitleColor(isLastPage ? .white : UIColor.MyTheme.primary, for: .normal)
        nextStepButton.backgroundColor = isLastPage ? UIColor.MyTheme.primary : .white
    }
    
    private func toWelcomePage() {
        navigationController?.isNavigationBarHidden = false
        self.navigationController?.pushViewController(WelcomeViewController.instantiate(), animated: true)
    }
    
    @IBAction private func onTapSkip(_ sender: UIButton) {
        toWelcomePage()
    }
    
    @IBAction private func onTapNextStep(_ sender: Any) {
        if index == AppConstants.onboardings.count - 1 {
            toWelcomePage()
        } else {
            index = (index + 1) % AppConstants.onboardings.count
            configNextPage()
        }
    }
    
    @IBAction private func onTapPageIndex(_ sender: UIPageControl) {
        index = sender.currentPage
        configNextPage()
    }
}
