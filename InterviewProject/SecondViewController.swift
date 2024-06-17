//
//  SecondViewController.swift
//  InterviewProject
//
//  Created by Jason Deng on 2024/6/17.
//

import UIKit

struct ApodData: Codable {
    let description: String
    let copyright: String
    let title: String
    let url: String
    let apod_site: String
    let date: String
    let media_type: String
    let hdurl: String
}

class SecondViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    var collectionView: UICollectionView!
    var data: [ApodData] = []
    let imageCache = NSCache<NSString, UIImage>()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupCollectionView()
        fetchData()
    }

    func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        let itemSize = (view.frame.size.width - 32) / 4 // 32 = 8 * 3 (three gaps)
        layout.itemSize = CGSize(width: itemSize, height: itemSize)
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ApodCell.self, forCellWithReuseIdentifier: "ApodCell")
        collectionView.backgroundColor = .white

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    func fetchData() {
        let urlString = "https://raw.githubusercontent.com/cmmobile/NasaDataSet/main/apod.json"
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                let decoder = JSONDecoder()
                do {
                    let apodData = try decoder.decode([ApodData].self, from: data)
                    self.data = apodData
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                } catch {
                    print(error)
                }
            }
        }.resume()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ApodCell", for: indexPath) as! ApodCell
        let apodData = data[indexPath.item]
        cell.titleLabel.text = apodData.title

        if let cachedImage = imageCache.object(forKey: apodData.url as NSString) {
            cell.imageView.image = cachedImage
        } else {
            cell.imageView.image = nil
            if let imageUrl = URL(string: apodData.url) {
                DispatchQueue.global().async {
                    if let data = try? Data(contentsOf: imageUrl), let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            if collectionView.indexPath(for: cell) == indexPath {
                                cell.imageView.image = image
                            }
                            self.imageCache.setObject(image, forKey: apodData.url as NSString)
                        }
                    }
                }
            }
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailVC = DetailViewController()
        detailVC.apodData = data[indexPath.item]
        navigationController?.pushViewController(detailVC, animated: true)
    }
}


class ApodCell: UICollectionViewCell {
    let imageView = UIImageView()
    let titleLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)

        imageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            titleLabel.topAnchor.constraint(equalTo: imageView.topAnchor, constant: 8),
            titleLabel.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -8),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8)
        ])

        titleLabel.font = UIFont.systemFont(ofSize: 12)
        titleLabel.numberOfLines = 3
        titleLabel.textAlignment = .center
        titleLabel.textColor = .white
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        titleLabel.text = nil
    }
}


