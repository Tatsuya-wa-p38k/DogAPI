import UIKit

    class CollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var collectionView: UICollectionView!

    var dogImages: [String] = [] // APIから取得した犬の画像URLを格納するプロパティ
    //segueの受け皿
    var breed: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.dataSource = self

        // 犬の種類に基づいてAPIから画像を取得する関数を呼び出す
        if let breed = breed {
                   DogAPI.fetchDogImages(for: breed) { images in
                       DispatchQueue.main.async {
                           if let images = images {
                               self.dogImages = images
                               self.collectionView.reloadData()
                           } else {
                               print("Failed to load dog images")
                           }
                       }
                   }
               }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dogImages.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
           let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DogImageCell", for: indexPath) as! DogImageCell
           let imageUrl = dogImages[indexPath.row]
           // 画像のURLから画像を取得して表示
           if let url = URL(string: imageUrl) {
               URLSession.shared.dataTask(with: url) { data, response, error in
                   if let data = data, error == nil {
                       DispatchQueue.main.async {
                           cell.imageView.image = UIImage(data: data)
                       }
                   }
               }.resume()
           }
           return cell
       }
   }

class DogImageCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
}

