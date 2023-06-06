//
//  HomeCollectionViewController.swift
//  Day6Lab1OnlineMovieList
//
//  Created by Hossam on 08/05/2023.
//

import UIKit
import Kingfisher



class HomeCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    var myItems: Array<Item> = []
    let myDatabase = DBManager.sharedMovieDB
    let reachability = try! Reachability()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        myItems = myDatabase.getHomeMovies() ?? []
        collectionView.reloadData()
        print("view will appear")

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("view did load")
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.center = self.view.center
        self.view.addSubview(indicator)
        
        indicator.startAnimating()
        print("before reachability")
        
        reachability.whenReachable = { _ in
            print("there is internet")
            loadData { [weak self] (result) in
                self!.myDatabase.deleteAll()
                for element in result!.items{
                    self!.myDatabase.insertToHome(movie: element)

                }
                DispatchQueue.main.async { [self] in
                    
                    self!.myItems = self!.myDatabase.getHomeMovies() ?? []
                    self!.collectionView.reloadData()
                    indicator.stopAnimating()
                    
                }
            }
        }
        reachability.whenUnreachable = { _ in
            print("there is noooo internet")
            self.myItems = self.myDatabase.getHomeMovies() ?? []
            self.collectionView.reloadData()
            indicator.stopAnimating()
        }
        
        do {
            try reachability.startNotifier()
            print("tried")
        } catch {
            print("Unable to start notifier")
        }
        // Do any additional setup after loading the view.
    }
    
    deinit{
        reachability.stopNotifier()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        
        return CGSize(width: screenWidth/2 - 10, height: screenHeight/4 - 10)
    }
    
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        print("thos is count:::: \(myItems.count)")
        return myItems.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "homeMovieCell", for: indexPath) as! HomeCollectionViewCell
        
        let url = URL(string: myItems[indexPath.row].image ?? "https://icon-library.com/images/no-image-icon/no-image-icon-20.jpg")
        let processor = DownsamplingImageProcessor(size: cell.cellImage.bounds.size)
                     |> RoundCornerImageProcessor(cornerRadius: 20)
        
        cell.cellImage.kf.setImage(
            with: url,
            placeholder: UIImage(named: "loading"),
//            placeholder: UIImage.gifImageWithName("funny"),
            options: [
                    .processor(processor),
                    .scaleFactor(UIScreen.main.scale),
                    .transition(.flipFromLeft(0.5)),
                    .cacheOriginalImage
                ])
        cell.movieCellLabel.text = myItems[indexPath.row].header
    
    
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailsVC = storyboard?.instantiateViewController(withIdentifier: "movieDetailsCV") as! MovieDetailsViewController
        
        detailsVC.currentMovie = myItems[indexPath.row]
        detailsVC.sourceVC = "home"
        self.navigationController?.pushViewController(detailsVC, animated: true)
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
