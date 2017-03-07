import UIKit

final class TimelineTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tweetTextView: UITextView!
    @IBOutlet weak var iconImageView: UIImageView!

    static let Nib: UINib = UINib(nibName: "TimelineTableViewCell", bundle: nil)
    static let CellIdentifier = "TimelineTableViewCell"

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    override func prepareForReuse() {
        nameLabel.text = nil
        tweetTextView.text = nil
        iconImageView.image = nil
    }

    func setTweet(_ tweet: Tweet) {
        nameLabel.text = tweet.name
        tweetTextView.text = tweet.text
        URLSession.shared.dataTask(with: URL(string: tweet.iconURLString)!) { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let data = data else {
                return
            }
            DispatchQueue.main.async { [weak self] in
                self?.iconImageView.image = UIImage(data: data)
            }
        }.resume()
    }
}
