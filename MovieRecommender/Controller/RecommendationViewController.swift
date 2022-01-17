//
//  RecommendationViewController.swift
//  MovieRecommender
//
//  Created by Sitare Arslanturk on 16.01.2022.
//

import UIKit

class RecommendationViewController: UIViewController {
    var recommendations: [String] = []
    private var collectionView : UICollectionView?
    private let pageTitle: UILabel = {
        let label = UILabel()
        label.text = "Recommendations"
        label.font = .systemFont(ofSize: 32, weight: .bold)
        return label
    }()
    private let replayButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("AGAIN", for: .normal)
        btn.backgroundColor = .orange
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
        btn.addTarget(self, action: #selector(replayTapped), for: .touchUpInside)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        // Do any additional setup after loading the view.
        setUpView()
    }
    
    @objc func replayTapped(){
        navigationController?.popViewController(animated: true)
    }
    
    func setUpView(){
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 30
        layout.minimumInteritemSpacing = 30
        layout.itemSize = CGSize(width: (view.frame.size.width/1.75)-4, height: (view.frame.size.height/2)-4)
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        guard let collectionView = collectionView else {
            return
        }
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20);
        collectionView.register(RecommendationCollectionViewCell.self, forCellWithReuseIdentifier: RecommendationCollectionViewCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        view.addSubview(pageTitle)
        pageTitle.translatesAutoresizingMaskIntoConstraints = false
        pageTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        pageTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        pageTitle.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: pageTitle.bottomAnchor).isActive = true
        collectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -45).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        view.addSubview(replayButton)
        replayButton.translatesAutoresizingMaskIntoConstraints = false
        replayButton.topAnchor.constraint(equalTo: collectionView.bottomAnchor).isActive = true
        replayButton.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        replayButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        replayButton.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension RecommendationViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recommendations.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecommendationCollectionViewCell.identifier, for: indexPath) as? RecommendationCollectionViewCell else { return UICollectionViewCell()}
        cell.configureCell(movieTitle: recommendations[indexPath.row])
        cell.layer.cornerRadius = 10.0
        cell.layer.borderWidth = 0.0
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 0)
        cell.layer.shadowRadius = 5.0
        cell.layer.shadowOpacity = 1
        cell.layer.masksToBounds = false
        return cell
    }
}
