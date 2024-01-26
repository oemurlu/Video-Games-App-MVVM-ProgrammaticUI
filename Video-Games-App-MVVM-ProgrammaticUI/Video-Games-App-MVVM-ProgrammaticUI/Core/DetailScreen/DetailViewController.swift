//
//  DetailViewController.swift
//  Video-Games-App-MVVM-ProgrammaticUI
//
//  Created by Osman Emre Ömürlü on 24.01.2024.
//

import UIKit

protocol DetailViewControllerInterface: AnyObject {
    func configureVC()
    func configureCollectionView()
    func configureNameLabel()
    func configureFavoriteButton()
    func configureReleaseLabel()
    func configurePlaytimeContainerView()
    func configureMetascoreView()
    func configureRatingView()
    func configureRatingStackView()
    func configureOverviewTextView()
    func configurePageControl()
    func updatePageControl(currentPageIndex: Int)
}

class DetailViewController: UIViewController {

    private let viewModel: DetailViewModel!
    private var collectionView: UICollectionView!
    private var nameLabel: UILabel!
    private var releaseLabel: UILabel!
    private var ratingStackView: UIStackView!
    private var playtimeContainerView: UIView!
    private var metascoreContainerView: UIView!
    private var ratingContainerView: UIView!
    private var overviewTextView: UITextView!
    private var pageControl: UIPageControl!
    private var favoriteButton: UIButton!
    
    private let padding: CGFloat = 8
    
    init(gameDetails: GameResult, gameScreenshots: GameScreenshots) {
        print("DETAIL-VC INIT")
        self.viewModel = DetailViewModel(gameDetails: gameDetails, gameScreenshots: gameScreenshots)
        super.init(nibName: nil, bundle: nil)
    }
    
    deinit {
        print("DETAIL-VC DEINIT")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.view = self
        viewModel.viewDidLoad()
    }
}

extension DetailViewController: DetailViewControllerInterface {
    func configureVC() {
        view.backgroundColor = .systemGray6
    }
    
    func configureCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: UIHelper.createDetailFlowLayout())
        view.addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        collectionView.register(DetailCell.self, forCellWithReuseIdentifier: DetailCell.reuseID)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: CGFloat.deviceWidth / (16/9))
        ])
    }
    
    func configurePageControl() {
        pageControl = UIPageControl(frame: .zero)
        view.addSubview(pageControl)
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        
        pageControl.numberOfPages = viewModel.gameScreenshots.count
        pageControl.direction = .leftToRight
        
        NSLayoutConstraint.activate([
            pageControl.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: padding),
            pageControl.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor)
        ])
    }
    
    func configureNameLabel() {
        nameLabel = UILabel(frame: .zero)
        view.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        nameLabel.text = viewModel.gameDetails._name
        nameLabel.font = .systemFont(ofSize: 32, weight: .bold)
        nameLabel.numberOfLines = 2
        nameLabel.textColor = .yellow
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: pageControl.bottomAnchor, constant: padding),
            nameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: padding),
        ])
    }
    
    func configureFavoriteButton() {
        favoriteButton = UIButton(type: .custom)
        view.addSubview(favoriteButton)
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false
        
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 24, weight: .semibold, scale: .large)
        let largeHeart = UIImage(systemName: "heart", withConfiguration: largeConfig)?.withTintColor(.systemRed, renderingMode: .alwaysOriginal)
        let largeHeartFill = UIImage(systemName: "heart.fill", withConfiguration: largeConfig)?.withTintColor(.systemRed, renderingMode: .alwaysOriginal)
        
        favoriteButton.setImage(largeHeart, for: .normal)
        favoriteButton.setImage(largeHeartFill, for: .selected)
        favoriteButton.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            favoriteButton.topAnchor.constraint(equalTo: nameLabel.topAnchor),
            favoriteButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -padding),
            favoriteButton.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: padding),
            favoriteButton.heightAnchor.constraint(equalToConstant: 50),
            favoriteButton.widthAnchor.constraint(equalTo: favoriteButton.heightAnchor)
        ])
    }

    
    func configureReleaseLabel() {
        releaseLabel = UILabel(frame: .zero)
        view.addSubview(releaseLabel)
        releaseLabel.translatesAutoresizingMaskIntoConstraints = false
        
        releaseLabel.text = "Release Date: \(viewModel.gameDetails._released)"
        releaseLabel.font = .systemFont(ofSize: 20, weight: .semibold)
        releaseLabel.textColor = .secondaryLabel
        
        NSLayoutConstraint.activate([
            releaseLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: padding),
            releaseLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            releaseLabel.trailingAnchor.constraint(equalTo: favoriteButton.trailingAnchor)
        ])
    }
    
    func configurePlaytimeContainerView() {
        playtimeContainerView = UIHelper.createContainerViewForDetailScreenStackView(withBorderColor: .lightGray, cornerRadius: 10)
        let playtimeLabel = UIHelper.createLabelForDetailScreenStackView(withText: "⏱️ \(viewModel.gameDetails._playtime) hour", fontSize: 20, fontWeight: .semibold)
        
        playtimeContainerView.addSubview(playtimeLabel)
        
        NSLayoutConstraint.activate([
            playtimeLabel.topAnchor.constraint(equalTo: playtimeContainerView.topAnchor, constant: 4),
            playtimeLabel.leadingAnchor.constraint(equalTo: playtimeContainerView.leadingAnchor, constant: 8),
            playtimeLabel.trailingAnchor.constraint(equalTo: playtimeContainerView.trailingAnchor, constant: -8),
            playtimeLabel.bottomAnchor.constraint(equalTo: playtimeContainerView.bottomAnchor, constant: -4)
        ])
        
    }
    
    func configureMetascoreView() {
        metascoreContainerView = UIHelper.createContainerViewForDetailScreenStackView(withBorderColor: .lightGray, cornerRadius: 10)
        let metascoreLabel = UIHelper.createLabelForDetailScreenStackView(withText: "💯 \(viewModel.gameDetails._metacritic) / 100", fontSize: 20, fontWeight: .semibold)
        
        metascoreContainerView.addSubview(metascoreLabel)

        NSLayoutConstraint.activate([
            metascoreLabel.topAnchor.constraint(equalTo: metascoreContainerView.topAnchor, constant: 4),
            metascoreLabel.leadingAnchor.constraint(equalTo: metascoreContainerView.leadingAnchor, constant: 8),
            metascoreLabel.trailingAnchor.constraint(equalTo: metascoreContainerView.trailingAnchor, constant: -8),
            metascoreLabel.bottomAnchor.constraint(equalTo: metascoreContainerView.bottomAnchor, constant: -4),
        ])
    }
    
    func configureRatingView() {
        ratingContainerView = UIHelper.createContainerViewForDetailScreenStackView(withBorderColor: .lightGray, cornerRadius: 10)
        let ratingLabel = UIHelper.createLabelForDetailScreenStackView(withText: "⭐️ \(viewModel.gameDetails._rating) / 5", fontSize: 20, fontWeight: .semibold)
        
        ratingContainerView.addSubview(ratingLabel)

        NSLayoutConstraint.activate([
            ratingLabel.topAnchor.constraint(equalTo: ratingContainerView.topAnchor, constant: 4),
            ratingLabel.leadingAnchor.constraint(equalTo: ratingContainerView.leadingAnchor, constant: 8),
            ratingLabel.trailingAnchor.constraint(equalTo: ratingContainerView.trailingAnchor, constant: -8),
            ratingLabel.bottomAnchor.constraint(equalTo: ratingContainerView.bottomAnchor, constant: -4),
        ])
    }

    
    func configureRatingStackView() {
        ratingStackView = UIStackView()
        view.addSubview(ratingStackView)

        ratingStackView.axis = .horizontal
        ratingStackView.distribution = .fillEqually
        ratingStackView.alignment = .center
        ratingStackView.spacing = 8

        ratingStackView.translatesAutoresizingMaskIntoConstraints = false

        ratingStackView.addArrangedSubview(playtimeContainerView)
        ratingStackView.addArrangedSubview(metascoreContainerView)
        ratingStackView.addArrangedSubview(ratingContainerView)
        

        NSLayoutConstraint.activate([
            ratingStackView.topAnchor.constraint(equalTo: releaseLabel.bottomAnchor, constant: padding * 2),
            ratingStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: padding),
            ratingStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -padding)
        ])
    }
    
    func configureOverviewTextView() {
        overviewTextView = UITextView(frame: .zero)
        view.addSubview(overviewTextView)
        overviewTextView.translatesAutoresizingMaskIntoConstraints = false
        
        overviewTextView.font = .systemFont(ofSize: 16)
        overviewTextView.backgroundColor = .systemGray6
        overviewTextView.isEditable = false
        overviewTextView.isScrollEnabled = true
        overviewTextView.textAlignment = .justified
        overviewTextView.attributedText = viewModel.gameDetails._description.htmlAttributedString(fontSize: 20, hexColorString: "#fff")
        
        NSLayoutConstraint.activate([
            overviewTextView.topAnchor.constraint(equalTo: ratingStackView.bottomAnchor, constant: padding),
            overviewTextView.leadingAnchor.constraint(equalTo: ratingStackView.leadingAnchor),
            overviewTextView.trailingAnchor.constraint(equalTo: ratingStackView.trailingAnchor),
            overviewTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -padding)
        ])
    }
    
    func updatePageControl(currentPageIndex: Int) {
            pageControl.currentPage = currentPageIndex
        }

}

extension DetailViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.gameScreenshots.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailCell.reuseID, for: indexPath) as! DetailCell
        cell.setCell(game: viewModel.gameScreenshots[indexPath.item])
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width
        guard width > 0 else { return }
        
        let currentPage = Int((scrollView.contentOffset.x + (0.5 * width)) / width)
        viewModel.updateCurrentPageIndex(currentPage)
    }
}

extension DetailViewController {
    @objc private func favoriteButtonTapped(sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected {
            //TODO: Add to favorites
            print("add")
        } else {
            //TODO: Remove from favorites
            print("remove")
        }
    }
}
