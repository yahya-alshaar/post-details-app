//
//  DetailViewController.swift
//  PostApp
//
//  Created by Yahya Alshaar on 11/7/19.
//  Copyright © 2019 Yahya Alshaar. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var rows = [RowKind.medias, .details]
    var viewModel: PostViewModel!
    
    // MARK: - View Configuration
    
    func configureView() {
        title = viewModel.title
        
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    func configureTableView(_ tableView: UITableView, withMedias medias: [Media]) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MediaTableViewCell.identifier) as! MediaTableViewCell
        cell.medias = medias
        
        return cell
    }
    
    func configureTableView(_ tableView: UITableView, withDetails details: NSAttributedString) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailsCell") as! DetailsTableViewCell
        cell.textView.attributedText = details
        cell.delegate = self
        
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if let indexPathOfMedia = indexPathForMedia() {
            (tableView.cellForRow(at: indexPathOfMedia) as! MediaTableViewCell).notifyDismissal()
        }
                
    }
    
    func indexPathForMedia() -> IndexPath? {
        guard let index = rows.lastIndex(of: .medias) else {
            return nil
        }
        
        return IndexPath(row: index, section: 0)
    }
    
    enum RowKind {
        case medias
        case details
    }
}

extension DetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch rows[indexPath.row] {
        case .medias:
            return configureTableView(tableView, withMedias: viewModel.medias)
        case .details:
            return configureTableView(tableView, withDetails: viewModel.details)
        }
    }
}

extension DetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch rows[indexPath.row] {
        case .medias:
            return tableView.frame.height * 0.7
        default:
            return tableView.rowHeight
        }
    }
}

extension DetailViewController: DetailsTableViewCellDelegate {
    func detailsTableViewCell(_ detailsTableViewCell: DetailsTableViewCell, shouldInteractWith URL: URL) -> Bool {
        let alert = UIAlertController(title: "Alert", message: "Why!! to click", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            // do wherever you want here :)
        }))
        self.present(alert, animated: true, completion: nil)
        
        return false
    }
    
}

