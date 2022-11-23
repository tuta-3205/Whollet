import UIKit
import Foundation
import CoreData

final class LocalDataManager {
    
    static let shared = LocalDataManager()
    private var appDelegate: AppDelegate?
    
    private init() {
        appDelegate = UIApplication.shared.delegate as? AppDelegate
    }
    
    func saveTransaction(_ transaction: TransactionDetail) {
        guard let appDelegate = appDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "TransactionDetailEntity", in: managedContext)!
        
        let detail = NSManagedObject(entity: entity, insertInto: managedContext)
        detail.setValue(transaction.from, forKey: "from")
        detail.setValue(transaction.to, forKey: "to")
        detail.setValue(transaction.totalAmount, forKey: "total_amount")
        detail.setValue(transaction.status, forKey: "status")
        detail.setValue(transaction.totalAmountUSD, forKey: "total_amount_usd")
        detail.setValue(transaction.time, forKey: "time")
        detail.setValue(transaction.id, forKey: "id")
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func getAllTransaction(completion: @escaping ([TransactionDetail], Error?) -> (Void)) {
        guard let appDelegate = appDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "TransactionDetailEntity")
        fetchRequest.includesPropertyValues = false
        do {
            let items = try managedContext.fetch(fetchRequest)
            var list: [TransactionDetail] = []
            for item in items {
                list.append(TransactionDetail(item: item))
            }
            completion(list, nil)
        } catch let error as NSError {
            DispatchQueue.main.async {
                completion([], error)
            }
            return
        }
    }
}
