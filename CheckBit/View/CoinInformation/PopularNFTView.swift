//
//  PopularNFTView.swift
//  CheckBit
//
//  Created by 이상민 on 3/10/25.
//

import UIKit
import SnapKit

class PopularNFTView: BaseView {
    
    private let popularTitleLable: UILabel = {
        let label = UILabel()
        label.text = "인기 NFT"
        label.textColor = UIColor(resource: .main)
        label.font = .systemFont(ofSize: 14, weight: .bold)
        return label
    }()
    
    private(set) lazy var nftCollectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout())
        view.register(PopularNFTCollectionViewCell.self, forCellWithReuseIdentifier: PopularNFTCollectionViewCell.identifier)
        view.showsHorizontalScrollIndicator = false
        return view
    }()
    
    override func configureHierarchy() {
        self.addSubview(popularTitleLable)
        self.addSubview(nftCollectionView)
    }
    
    override func configureLayout() {
        self.popularTitleLable.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().inset(16)
        }
        
        self.nftCollectionView.snp.makeConstraints { make in
            make.top.equalTo(popularTitleLable.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    override func configureView() {
        
    }
    
    
    private func layout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        
        let width = 72.0
        let spacing = 4.0
        let padding = 16.0
        
        layout.itemSize = CGSize(width: width, height: 150)
        layout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        layout.minimumInteritemSpacing = spacing
        
        layout.scrollDirection = .horizontal
        return layout
    }
    
    func configureDelegate(delegate: UICollectionViewDelegateFlowLayout){
        self.nftCollectionView.delegate = delegate
    }
}
