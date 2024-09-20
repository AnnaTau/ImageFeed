import UIKit

public protocol ImagesListViewControllerProtocol: AnyObject {
    var presenter: ImagesListPresenterProtocol? { get set }
    func setLikeState(for row: Int, newState: Bool)
}

final class ImagesListViewController: UIViewController, ImagesListViewControllerProtocol {
    
    var presenter: ImagesListPresenterProtocol?
    private var imagesListServiceObserver: NSObjectProtocol?
    @IBOutlet private var tableView: UITableView!

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupNotifications()
        presenter?.fetchNextPhotos()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.Segues.showSingleImageSegueIdentifier {
            guard
                let viewController = segue.destination as? SingleImageViewController,
                let indexPath = sender as? IndexPath
            else {
                assertionFailure("Invalid segue destination")
                return
            }
            let urlString = presenter?.getLargeImageURL(row: indexPath.row)
            viewController.fullImageURLString = urlString
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    func updateTableViewAnimated() {
        guard let presenter else {
            preconditionFailure("[ImagesListViewController updateTableViewAnimated] presenter is nil")
        }
        let oldCount = presenter.getCountOfImages() - Constants.Photos.perPage
        let newCount = presenter.getCountOfImages()
        if oldCount != newCount {
            tableView.performBatchUpdates {
                let indexPaths = (oldCount..<newCount).map { i in
                    IndexPath(row: i, section: 0)
                }
                tableView.insertRows(at: indexPaths, with: .automatic)
            } completion: { _ in }
        }
    }
    
    func setLikeState(for row: Int, newState: Bool) {
        let indexPath = IndexPath(row: row, section: 0)
        guard let cell = tableView.cellForRow(at: indexPath) as? ImagesListCell else {
            debugPrint("[ImagesListViewController setLikeState] cell is nil")
            return
        }
        cell.setIsLiked(isLike: newState)
    }
    
    // MARK: - Private methods for setup view
    
    private func setupLayout() {
        tableView.rowHeight = 200
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
    }
    
    private func setupNotifications() {
        imagesListServiceObserver = NotificationCenter.default.addObserver(
                forName: ImagesListService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                self.updateTableViewAnimated()
            }
    }
    
}

// MARK: - UITableViewDelegate

extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: Constants.Segues.showSingleImageSegueIdentifier, sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let presenter else {
            preconditionFailure("[ImagesListViewController tableView] presenter is nil")
        }
        let size: CGSize = presenter.getSizeOfImage(row: indexPath.row)
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = size.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = size.height * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let presenter else {
            preconditionFailure("[ImagesListViewController tableView] presenter is nil")
        }
        if indexPath.row + 1 == presenter.getCountOfImages() {
            presenter.fetchNextPhotos()
        }
    }
	
}

// MARK: - UITableViewDataSource

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let presenter else {
            preconditionFailure("[ImagesListViewController tableView] Presenter is nil")
        }
        return presenter.getCountOfImages()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let presenter else {
            preconditionFailure("[ImagesListViewController tableView] Presenter is nil")
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        guard let imageListCell = cell as? ImagesListCell
        else {
            debugPrint("[ImagesListViewController tableView] Cell is not ImagesListCell")
            return UITableViewCell()
        }
        imageListCell.delegate = self
        imageListCell.configCell(tableView,
                                 thumbImageURL: presenter.getThumbnailImageURL(row: indexPath.row),
                                 isLiked: presenter.isImageLiked(row: indexPath.row),
                                 createdAt: presenter.getImageCreatedAt(row: indexPath.row))
        return imageListCell
    }
    
}

// MARK: - ImagesListCellDelegate

extension ImagesListViewController: ImagesListCellDelegate {
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        guard
            let indexPath = tableView.indexPath(for: cell),
            let presenter
        else {
            debugPrint("[ImagesListViewController imageListCellDidTapLike] Error: Can't get indexPath or presenter")
            return
        }
        presenter.changeImageLikeState(row: indexPath.row)
    }
    
}
