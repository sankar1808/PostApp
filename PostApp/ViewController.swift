//
//  ViewController.swift
//  PostsDisplayApp
//
//  Created by Sankaranarayana Settyvari on 05/03/24.
//

import UIKit


class ViewController: UIViewController {
 
    var postsArray = NSMutableArray()
    var totalPosts:[PostResponse] = []
    
    let scrollView: UIScrollView =
      {
          let scrollView = UIScrollView()
          scrollView.isPagingEnabled = true
          scrollView.translatesAutoresizingMaskIntoConstraints = false
          return scrollView
      }()
      
      let stackView: UIStackView =
      {
          let stackView = UIStackView()
          stackView.axis = .horizontal
          stackView.distribution = .equalSpacing
          stackView.translatesAutoresizingMaskIntoConstraints = false
          return stackView
      }()
      
      let pageControl = UIPageControl()
      
      let padding: CGFloat = 20
      let pageWidth = UIScreen.main.bounds.width
      
      let tableViewCellIdentifier = "cell"
      
      // Use this factor to unique identify your table
      let tableViewUniqueIdFactor = 1000
      
      // https://stackoverflow.com/a/21130486/1619193
    
      private func randomColor() -> UIColor
      {
          let red = CGFloat(arc4random_uniform(256)) / 255.0
          let blue = CGFloat(arc4random_uniform(256)) / 255.0
          let green = CGFloat(arc4random_uniform(256)) / 255.0
          
          return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
      }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        fetchPosts()
        scrollView.delegate = self
        
        title = "Posts List"
        view.backgroundColor = .white
    }
    
    func fetchPosts()  {
        PostResource().fetchPost(completionHandler: { [self] result in
            if result != nil {
                DispatchQueue.main.async {
                    self.totalPosts = result!
                    self.displayPosts()
                    
                }
            }
        })
    }
    
    private func configureScrollViewLayout()
    {
        scrollView.delegate = self
        
        view.addSubview(scrollView)
        
        // Auto layout
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
            .isActive = true
        
        scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                        constant: padding).isActive = true
        
        scrollView.widthAnchor.constraint(equalToConstant: pageWidth).isActive = true
        
        scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                                        constant: -padding * 3).isActive = true
    }
    
    private func configureStackViewLayout()
    {
        scrollView.addSubview(stackView)
        
        // Auto layout
        
        stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor)
            .isActive = true
        
        stackView.topAnchor.constraint(equalTo: scrollView.topAnchor)
            .isActive = true
        
        stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor)
            .isActive = true
        
        stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
            .isActive = true
        
        stackView.heightAnchor.constraint(equalTo: scrollView.heightAnchor,
                                          multiplier: 1).isActive = true
    }
    
    
    private func configurePageControl()
    {
        pageControl.numberOfPages = totalPosts.count/10
        pageControl.currentPage = 0
        pageControl.tintColor = randomColor()
        pageControl.pageIndicatorTintColor = UIColor.gray
        pageControl.currentPageIndicatorTintColor = UIColor.blue
        
        view.addSubview(pageControl)
        
        // Auto layout
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        
        pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            .isActive = true
        
        pageControl.topAnchor.constraint(equalTo: scrollView.bottomAnchor)
            .isActive = true
        
        pageControl.widthAnchor.constraint(equalToConstant: 200)
            .isActive = true
        
        pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            .isActive = true
    }
    
    private func addTableViewsToStackView()
    {
            for i in 0 ..< postsArray.count
            {
                let tableView = UITableView()
                tableView.separatorStyle = .singleLine
                tableView.translatesAutoresizingMaskIntoConstraints = false
                tableView.rowHeight = UITableView.automaticDimension
                tableView.rowHeight = 80
                // Uniquely identify each table which will come in handy
                // when figuring out which posts should be loaded for a specific
                // table view
                tableView.tag = tableViewUniqueIdFactor + i
                
                // Register a default UITableView Cell
                tableView.register(UINib(nibName: "PostCell", bundle: nil), forCellReuseIdentifier: tableViewCellIdentifier)
                
                tableView.dataSource = self
                
                tableView.backgroundColor = UIColor.clear
                
                // remove additional rows
                tableView.tableFooterView = UIView()
                
                stackView.addArrangedSubview(tableView)
                
                tableView.widthAnchor.constraint(equalToConstant: pageWidth)
                    .isActive = true
                
                // height is calculated automatically based on the height
                // of the stack view
            }
        }
        

    func displayPosts()  {
        postsArray = createPosts()
        
        // Configure everything, functions come later
        configureScrollViewLayout()
        configureStackViewLayout()
        configurePageControl()
        addTableViewsToStackView()
    }
    
    func createPosts() -> NSMutableArray {

        let postArray = NSMutableArray()
        for i in 0...10 {
            
            var postViewArray: [PostResponse] = []
            let k = 10 * (1 * i)
            let l = 10 + k
            if(k < totalPosts.count) {
                for j in k...l-1 {
                    let postObject = totalPosts[j]
                    postViewArray.append(postObject)
                }
            }
            if(postViewArray.count > 0) {
                postArray.add(postViewArray)
            }
        }
        return postArray
    }
    

}

extension ViewController: UIScrollViewDelegate
{
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView)
    {
        // Make sure you don't do anything with table view scrolls
        // This is only a worry if the view controller is the table view's
        // delegate also
        if !(scrollView is UITableView)
        {
            let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
            pageControl.currentPage = Int(pageNumber)
        }
    }
}

extension ViewController: UITableViewDataSource
{
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int
    {
        // Retrieve the correct model using the unique identifier created earlier
        let id = tableView.tag - tableViewUniqueIdFactor
        
        // Get the correct array needed from model
        let postsForCurrentTable = postsArray[id]
        
        return (postsForCurrentTable as AnyObject).count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        // Retrieve the correct model using the unique identifier created earlier
        let postIndex = tableView.tag - tableViewUniqueIdFactor
        
        // Get the correct array needed from model
        let postsForCurrentTable: [PostResponse]  = postsArray[postIndex] as! [PostResponse]
        
        
        let cell:PostCell = tableView.dequeueReusableCell(withIdentifier: tableViewCellIdentifier) as! PostCell
        let post: PostResponse = postsForCurrentTable[indexPath.row] as PostResponse
        
        //cell.userIdLabel.text = "UserId :" + String(post.userId)
        cell.idLabel.text = "Id: " + String(post.id)
        cell.titleLabel.text = "Title: " + post.title
        //cell.bodyLabel.text = "Body: " + post.body
        
        
        return cell
    }
}


