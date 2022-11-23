import UIKit
import ICONKit
import CoreData

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var wallet: Wallet?
    var window: UIWindow?
    var transactions = TransactionsModel()

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = UIStoryboard(
            name: "OnboardingScreen",
            bundle: nil
        ).instantiateInitialViewController()
        window?.makeKeyAndVisible()
        return true
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Whollet")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {

                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
}
