
import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var dogBreeds: [String] = []

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self // デリゲートをセット
        // Do any additional setup after loading the view.

        // 犬の種類を取得する関数を呼び出し
        DogAPI.fetchDogBreeds { breeds in
            DispatchQueue.main.async {
                if let breeds = breeds {
                    self.dogBreeds = breeds
                    self.tableView.reloadData()
                } else {
                    print("Failed to load dog breeds")
                }
            }
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return dogBreeds.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = UITableViewCell()
    cell.textLabel?.text = dogBreeds[indexPath.row]
    return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         let selectedBreed = dogBreeds[indexPath.row]
         performSegue(withIdentifier: "showCollectionView", sender: selectedBreed)
     }

     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         if segue.identifier == "showCollectionView", let selectedBreed = sender as? String {
             if let destinationVC = segue.destination as? CollectionViewController {
                 destinationVC.breed = selectedBreed
             }
         }
     }
}   

