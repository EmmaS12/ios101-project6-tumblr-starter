import UIKit
import Nuke

class PostDetailViewController: UIViewController {

    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    var post: Post?
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Safely unwrap the post data
        if let post = post {
            // Safely unwrap and assign the summary to the label
            captionLabel.text = post.summary

            // Safely unwrap the photo data before trying to load the image
            if let photo = post.photos.first {
                let url = photo.originalSize.url
                Nuke.loadImage(with: url, into: imageView)
            } else {
                print("❌ No photo available for this post.")
            }
        } else {
            print("❌ No post data found!")
        }
    }
}

