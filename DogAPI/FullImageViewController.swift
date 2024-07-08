import UIKit

class FullImageViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    var imageURL: String?

    override func viewDidLoad() {
           super.viewDidLoad()

           if let imageURL = imageURL, let url = URL(string: imageURL) {
               URLSession.shared.dataTask(with: url) { data, response, error in
                   if let data = data, error == nil {
                       DispatchQueue.main.async {
                           self.imageView.image = UIImage(data: data)
                       }
                   }
               }.resume()
           }
       }
}
