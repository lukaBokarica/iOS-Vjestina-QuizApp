//
//  PageViewController.swift
//  QuizApp
//
//  Created by Pero Bokarica on 04.05.2021..
//

import UIKit

class PageViewController: UIPageViewController, UIPageViewControllerDataSource  {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        <#code#>
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        <#code#>
    }
    
    private let controllers: [UIViewController] = [
        QuizViewController()
    ]
    private var displayedIndex = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        guard let firstVC = controllers.first else { return }
        //postavljanje boje indikatora stranice
        let pageAppearance = UIPageControl.appearance()
        pageAppearance.currentPageIndicatorTintColor = .black
        pageAppearance.pageIndicatorTintColor = .lightGray
        dataSource = self
        setViewControllers([firstVC], direction: .forward, animated: true,
        completion: nil)
    }
}
