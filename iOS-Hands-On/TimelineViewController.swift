import UIKit
import Accounts
import Social

final class TimelineViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!

    fileprivate var tweets: [Tweet] = []

    private var account: ACAccount?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(TimelineTableViewCell.Nib, forCellReuseIdentifier: TimelineTableViewCell.CellIdentifier)
        tableView.estimatedRowHeight = 180
        tableView.rowHeight = UITableViewAutomaticDimension
        requestTwitterAccount()
    }

    private func requestTwitterAccount() {
        let accountStore = ACAccountStore()
        let accountType = accountStore.accountType(withAccountTypeIdentifier: ACAccountTypeIdentifierTwitter)
        accountStore.requestAccessToAccounts(with: accountType, options: nil) { (granted: Bool, error: Error?) -> Void in
            if let error = error {
                self.showAlert(message: error.localizedDescription)
                return
            }
            guard granted else {
                self.showAlert(message: "No account access")
                return
            }
            // TODO: show account select action-sheet
            guard let account = accountStore.accounts(with: accountType).first as? ACAccount else {
                self.showAlert(message: "No Twitter account")
                return
            }

            self.account = account
            self.getHomeTimeline()
        }
    }

    private func getHomeTimeline() {
        let requestURL = URL(string: "https://api.twitter.com/1/statuses/home_timeline.json")
        let request = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: .GET, url: requestURL, parameters: nil)
        request?.account = account
        request?.perform { (data: Data?, response: HTTPURLResponse?, error: Error?) -> Void in
            if let error = error {
                self.showAlert(message: error.localizedDescription)
                return
            }
            guard let data = data else {
                self.showAlert(message: "No Timeline data")
                return
            }
            
            do {
                let results = try JSONSerialization.jsonObject(with: data, options: [])
                // TODO: error handling
                if let rawTimeline = results as? [[String: Any]] {
                    self.tweets = rawTimeline.map(Tweet.init)
                    DispatchQueue.main.async { [weak self] in
                        self?.tableView.reloadData()
                    }
                }
            } catch let error as NSError {
                self.showAlert(message: error.localizedDescription)
            }
        }
    }

    private func showAlert(message: String) {
        DispatchQueue.main.async { [weak self] in
            let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            self?.present(alertController, animated: true, completion: nil)
        }
    }
}

// MARK: - UITableViewDataSource

extension TimelineViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TimelineTableViewCell.CellIdentifier, for: indexPath) as! TimelineTableViewCell
        cell.setTweet(tweets[indexPath.row])
        return cell
    }
}

// MARK: - UITableViewDelegate

extension TimelineViewController: UITableViewDelegate {
}
