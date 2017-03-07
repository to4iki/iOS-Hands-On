import UIKit

final class TimelineViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!

    fileprivate let tweets: [String] = (1...10).map { $0.description }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
    }
}

// MARK: - UITableViewDataSource

extension TimelineViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TimelineTableViewCell", for: indexPath) as! TimelineTableViewCell
        cell.textLabel?.text = tweets[indexPath.row]
        return cell
    }
}

// MARK: - UITableViewDelegate

extension TimelineViewController: UITableViewDelegate {
    
}
