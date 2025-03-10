//
//  PopularSearchesView.swift
//  CheckBit
//
//  Created by 이상민 on 3/10/25.
//

import UIKit
import SnapKit

class PopularSearchesView: BaseView {
    private let popularTitleLable: UILabel = {
        let label = UILabel()
        label.text = "인기 검색어"
        label.textColor = UIColor(resource: .main)
        label.font = .systemFont(ofSize: 14, weight: .bold)
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.text = "02.16 00:30 기준"
        label.textColor = UIColor(resource: .secondary)
        label.font = .systemFont(ofSize: 12)
        return label
    }()
    
    private lazy var popularCollectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        view.isScrollEnabled = false
        return view
    }()
    
    override func configureHierarchy() {
        self.addSubview(popularTitleLable)
        self.addSubview(dateLabel)
        self.addSubview(popularCollectionView)
    }
    
    override func configureLayout() {
        self.popularTitleLable.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().inset(16)
        }
        
        self.dateLabel.snp.makeConstraints { make in
            make.trailing.top.equalToSuperview().inset(16)
        }
        
        self.popularCollectionView.snp.makeConstraints { make in
            make.top.equalTo(popularTitleLable.snp.bottom).offset(16)
            make.leading.trailing.bottom.equalToSuperview().inset(16)
        }
    }
    
    var dataSource: UICollectionViewDiffableDataSource<String, Int>!
    
    override func configureView() {
        configureDataSource()
        updateSnapshot()
    }
    
    func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(50)
        )
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let leftGroupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.5),
            heightDimension: .estimated(50)
        )
        let leftGroup = NSCollectionLayoutGroup.vertical(
            layoutSize: leftGroupSize,
            subitems: Array(repeating: item, count: 7)
        )
        
        let rightGroupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.5),
            heightDimension: .estimated(50)
        )
        
        let rightGroup = NSCollectionLayoutGroup.vertical(
            layoutSize: rightGroupSize,
            subitems: Array(repeating: item, count: 7)
        )
        
        let horizontalGroupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let horizontalGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: horizontalGroupSize,
            subitems: [leftGroup, rightGroup]
        )
        
        horizontalGroup.interItemSpacing = .fixed(20)
        
        let section = NSCollectionLayoutSection(group: horizontalGroup)
        section.interGroupSpacing = 20
        
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    private func configureDataSource(){
        let cellRegistraion = UICollectionView.CellRegistration<PopularCollectionViewCell, Int> { cell, indexPath, itemIdentifier in
            cell.popularRankLabel.text = "\(itemIdentifier)"
            cell.popularCoinImageView.image = UIImage(systemName: "person")
            cell.popularCoinNameLabel.text = "OMfdfdsfdfds"
            cell.popularCoinCompanyLabel.text = "MANTRAdsfdsfdsfdsfsf"
            cell.popularChangeIconImageView.image = UIImage(systemName: "arrowtriangle.up.fill")
            cell.popularChangeLabel.text = "1000%"
        }
        
        dataSource = UICollectionViewDiffableDataSource(
            collectionView: popularCollectionView,
            cellProvider: {
                collectionView,
                indexPath,
                itemIdentifier in
                let cell = collectionView.dequeueConfiguredReusableCell(
                    using: cellRegistraion,
                    for: indexPath,
                    item: itemIdentifier
                )
                return cell
            }
        )
    }
    private func updateSnapshot(){
        var snapshot = NSDiffableDataSourceSnapshot<String, Int>()
        snapshot.appendSections(["PopularSearches"])
        snapshot.appendItems([1,2,3,4,5,6, 7, 8, 9, 10, 11, 12, 13, 14], toSection: "PopularSearches")
        dataSource.apply(snapshot)
    }
}
