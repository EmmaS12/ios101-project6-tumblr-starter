import UIKit
import Nuke

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var posts: [Post] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up the table view delegate and data source
        tableView.delegate = self
        tableView.dataSource = self
        
        print("✅ View loaded!")
        
        // Add sample post data for testing
        let samplePost = Post(summary: "Sample summary", caption: "Sample caption", photos: [])
        posts = [samplePost]  // Set this as your posts array
        
        // Reload the table to display the sample data
        tableView.reloadData()
        
        // Proceed to fetch real data from Tumblr API
        fetchPosts()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail",  // Match with the identifier you set in the storyboard segue
           let cell = sender as? UITableViewCell,
           let indexPath = tableView.indexPath(for: cell),
           let detailVC = segue.destination as? PostDetailViewController {

            // Get the selected post and pass it to the next view controller
            let post = posts[indexPath.row]
            detailVC.post = post
            print("📲 Passing post: \(post.summary)")  // Debugging statement to verify
        }
    }

    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostCell
        
        let post = posts[indexPath.row]
        cell.summaryLabel.text = post.summary
        
        if let photo = post.photos.first {
            let url = photo.originalSize.url
            Nuke.loadImage(with: url, into: cell.postImageView)
        } else {
                // Optionally handle the case where there is no image
                
        }
        
        return cell
    }
    
    // MARK: - Fetch Posts
    
    func fetchPosts() {
        // Use the correct API URL
        let url = URL(string: "https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/posts/photo?api_key=1zT8CiXGXFcQDyMFG7RtcfGLwTdDjFUJnZzKJaWTmgyK4lKGYk")!
        
        let session = URLSession.shared.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
            
            // Error handling
            if let error = error {
                print("❌ Error: \(error.localizedDescription)")
                return
            }
            
            // Check if the response status code is successful (200-299)
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, (200...299).contains(statusCode) else {
                print("❌ Response error: \(String(describing: response))")
                return
            }
            
            // Ensure data exists
            guard let data = data else {
                print("❌ Data is NIL")
                return
            }
            
            // Log the raw JSON response
            do {
                let jsonResponse = try JSONSerialization.jsonObject(with: data, options: [])
                print("📦 Raw JSON Response: \(jsonResponse)") // Log raw JSON to check the format
                
                // Decode the response into your model
                let blog = try JSONDecoder().decode(Blog.self, from: data)
                
                DispatchQueue.main.async { [weak self] in
                    // Check if data is received correctly
                    print("📲 Blog posts received: \(blog.response.posts.count)")
                    
                    self?.posts = blog.response.posts
                    print("✅ We got \(self?.posts.count ?? 0) posts!") // Verify the number of posts
                    
                    // Check if posts contain any data
                    for post in self?.posts ?? [] {
                        print("🍏 Summary: \(post.summary)")  // Print the summaries of posts
                    }
                    
                    // Reload the table view with new data
                    self?.tableView.reloadData()
                }
            } catch {
                print("❌ Error decoding JSON: \(error.localizedDescription)")
            }
        }
        
        // Start the network request
        session.resume()
    }
}
