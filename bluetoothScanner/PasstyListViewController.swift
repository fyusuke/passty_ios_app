import UIKit
import SlideMenuControllerSwift

class PasstyListViewController: SlideMenuController {

    @IBOutlet weak var label1: UILabel!
    let stock_info: [[String: String]] = UserDefaults.standard.object(forKey: "stock_info") as! [[String: String]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let _ = UserDefaults.standard.string(forKey: "access_token") else {
            NotificationCenter.default.post(name: NSNotification.Name("SignOut"), object: nil)
            return
        }
    }
    
    // セルが表示されるときに呼ばれる処理（1個のセルを描画する毎に呼び出されます
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell:CustomCell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CustomCell
        cell.UUID = stock_info[indexPath.row]["uuid"]
        cell.major = stock_info[indexPath.row]["major"]
        cell.minor = stock_info[indexPath.row]["minor"]
        cell.serial_num = stock_info[indexPath.row]["serial_num"]
        return cell
    }
    
    // セクションの数（今回は1つだけです）
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    // 表示するセルの数
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return stock_info.count
        return stock_info.count != nil ? stock_info.count : 0
    }
    
}
