//
//  InterviewProjectTests.swift
//  InterviewProjectTests
//
//  Created by Jason Deng on 2024/6/17.
//

import XCTest
@testable import InterviewProject

final class InterviewProjectTests: XCTestCase {

    func testFirstViewController() {
            let firstVC = FirstViewController()
            firstVC.loadViewIfNeeded()

            XCTAssertNotNil(firstVC.view, "View should not be nil")
            XCTAssertTrue(firstVC.view.subviews.contains { $0 is UIButton }, "FirstViewController should have a button")

            let button = firstVC.view.subviews.first { $0 is UIButton } as? UIButton
            XCTAssertEqual(button?.title(for: .normal), "Next", "Button title should be 'Next'")
        }

        func testSecondViewController() {
            let secondVC = SecondViewController()
            secondVC.loadViewIfNeeded()

            XCTAssertNotNil(secondVC.view, "View should not be nil")
            XCTAssertTrue(secondVC.view.subviews.contains { $0 is UICollectionView }, "SecondViewController should have a UICollectionView")

            let collectionView = secondVC.view.subviews.first { $0 is UICollectionView } as? UICollectionView
            XCTAssertNotNil(collectionView, "CollectionView should not be nil")
            XCTAssertEqual(collectionView?.numberOfItems(inSection: 0), 0, "Initially, there should be no items in the collection view")
        }

        func testDetailViewController() {
            let detailVC = DetailViewController()
            detailVC.loadViewIfNeeded()

            XCTAssertNotNil(detailVC.view, "View should not be nil")

            detailVC.apodData = ApodData(
                description: "Test Description",
                copyright: "Test Copyright",
                title: "Test Title",
                url: "https://example.com/image.jpg",
                apod_site: "https://example.com",
                date: "2020-12-17",
                media_type: "image",
                hdurl: "https://example.com/hdimage.jpg"
            )

            detailVC.configureWithData()

            XCTAssertEqual(detailVC.titleLabel.text, "Test Title", "Title should be 'Test Title'")
            XCTAssertEqual(detailVC.copyrightLabel.text, "Test Copyright", "Copyright should be 'Test Copyright'")
            XCTAssertEqual(detailVC.descriptionLabel.text, "Test Description", "Description should be 'Test Description'")
            XCTAssertEqual(detailVC.dateLabel.text, "2020 Dec. 17", "Date should be '2020 Dec. 17'")
        }

        func testApodCell() {
            let cell = ApodCell()
            cell.prepareForReuse()

            XCTAssertNil(cell.imageView.image, "ImageView image should be nil after prepareForReuse")
            XCTAssertNil(cell.titleLabel.text, "TitleLabel text should be nil after prepareForReuse")

            cell.titleLabel.text = "Test Title"
            XCTAssertEqual(cell.titleLabel.text, "Test Title", "Title should be 'Test Title'")
        }

}
