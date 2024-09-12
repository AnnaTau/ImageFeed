import UIKit
import Kingfisher

final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"
    
    // MARK: - IB Outlets
    @IBOutlet private var cellImage: UIImageView!
    @IBOutlet private var likeButton: UIButton!
    @IBOutlet private var dateLabel: UILabel!
    
    // MARK: - Private Properties
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cellImage.kf.cancelDownloadTask()
    }
    
    public func configCell(_ tableView: UITableView, with indexPath: IndexPath, url: URL) {
        cellImage.kf.indicatorType = IndicatorType.activity
        cellImage.kf.setImage(with: url,
                              placeholder: UIImage(named: "Stub"),
                              options: []) { _ in
            tableView.reloadRows(at: [indexPath], with: .automatic) 
        }
        dateLabel.text = dateFormatter.string(from: Date())
        if indexPath.row % 2 == 0 {
            guard let likeOn = UIImage(named: "like_button_on") else { return }
            likeButton.imageView?.image = likeOn
        } else {
            guard let likeOff = UIImage(named: "like_button_off") else { return }
            likeButton.imageView?.image = likeOff
        }
    }
}
