import UIKit

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
    
    public func configCell(with indexPath: IndexPath) {
        guard let image = UIImage(named: "\(indexPath.row)") else { return }
        cellImage.image = image
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
