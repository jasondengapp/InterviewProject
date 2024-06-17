//
//  DetailViewController.swift
//  InterviewProject
//
//  Created by Jason Deng on 2024/6/17.
//

import UIKit

class DetailViewController: UIViewController {
    var apodData: ApodData?

    let scrollView = UIScrollView()
    let contentView = UIView()

    let dateLabel = UILabel()
    let imageView = UIImageView()
    let titleLabel = UILabel()
    let copyrightLabel = UILabel()
    let descriptionLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupScrollView()
        setupViews()
        configureWithData()
    }

    func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }

    func setupViews() {
        contentView.addSubview(dateLabel)
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(copyrightLabel)
        contentView.addSubview(descriptionLabel)

        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        copyrightLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            dateLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),

            imageView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 16),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4),

            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            copyrightLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            copyrightLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            copyrightLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            descriptionLabel.topAnchor.constraint(equalTo: copyrightLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])

        dateLabel.font = UIFont.systemFont(ofSize: 14)
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        titleLabel.numberOfLines = 0
        copyrightLabel.font = UIFont.systemFont(ofSize: 12)
        descriptionLabel.font = UIFont.systemFont(ofSize: 16)
        descriptionLabel.numberOfLines = 0
    }

    func configureWithData() {
        guard let apodData = apodData else { return }

        title = apodData.title

        if let imageUrl = URL(string: apodData.hdurl) {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: imageUrl) {
                    let image = UIImage(data: data)
                    DispatchQueue.main.async {
                        self.imageView.image = image
                    }
                }
            }
        }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let date = dateFormatter.date(from: apodData.date) {
            dateFormatter.dateFormat = "yyyy MMM. dd"
            dateLabel.text = dateFormatter.string(from: date)
        }

        titleLabel.text = apodData.title
        copyrightLabel.text = apodData.copyright
        descriptionLabel.text = apodData.description
    }
}
