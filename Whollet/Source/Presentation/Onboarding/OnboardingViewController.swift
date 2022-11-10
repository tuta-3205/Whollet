import UIKit

final class OnboardingViewController: UIViewController {

    @IBOutlet private weak var splashImage: UIImageView!
    @IBOutlet private weak var indexPage: UIPageControl!
    @IBOutlet private weak var bottomView: UIView!
    @IBOutlet private weak var titleText: UILabel!
    @IBOutlet private weak var descriptionText: UILabel!
    @IBOutlet private weak var nextStepButton: UIButton!
    
    private var index: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }
    
    private func configView() {
        bottomView.layer.cornerRadius = 20
        bottomView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        nextStepButton.layer.cornerRadius = nextStepButton.frame.height / 2
        nextStepButton.layer.borderWidth = 1.0
        nextStepButton.layer.borderColor = UIColor.MyTheme.primary.cgColor
        titleText.resizeWithHeight()
        descriptionText.resizeWithHeight()
        
        configNextPage()
    }
    
    private func configNextPage() {
        let pageData = AppConstants.onboardings[index]
        splashImage.image = UIImage(named: pageData.image)
        indexPage.currentPage = index
        titleText.text = pageData.title
        descriptionText.text = pageData.description
        
        if (index == AppConstants.onboardings.count - 1) {
            nextStepButton.setTitle(AppStrings.getStarted.rawValue, for: .normal)
            nextStepButton.setTitleColor(.white, for: .normal)
            nextStepButton.backgroundColor = UIColor.MyTheme.primary
        } else {
            nextStepButton.setTitle(AppStrings.nextStep.rawValue, for: .normal)
            nextStepButton.setTitleColor(UIColor.MyTheme.primary, for: .normal)
            nextStepButton.backgroundColor = .white
        }
    }
    
    @IBAction private func onTapSkip(_ sender: UIButton) {
        // To next page
    }
    
    @IBAction private func onTapNextStep(_ sender: Any) {
        if (index == AppConstants.onboardings.count - 1) {
            // To next page
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
