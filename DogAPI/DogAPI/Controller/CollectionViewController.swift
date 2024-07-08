import UIKit

    class CollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!

    var dogImages: [String] = [] // APIから取得した犬の画像URLを格納するプロパティ
    //segueの受け皿
    var breed: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.dataSource = self
        collectionView.delegate = self

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
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
             let width = (collectionView.frame.width  / 2) // 横に2つ並べるために幅を調整
             return CGSize(width: width, height: width) // 正方形のセルを設定
         }

        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            let selectedImageURL = dogImages[indexPath.row]
            performSegue(withIdentifier: "showFullImage", sender: selectedImageURL)
        }

        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "showFullImage", let imageURL = sender as? String {
                if let destinationVC = segue.destination as? FullImageViewController {
                    destinationVC.imageURL = imageURL
                }
            }
        }
   }

class DogImageCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // 画像のアスペクト比を維持するように設定
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
    }
}
