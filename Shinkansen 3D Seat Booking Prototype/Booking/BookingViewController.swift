//
//  BookingViewController.swift
//  Shinkansen Tickets Booking Prototype
//
//  Created by Virakri Jinangkul on 6/1/19.
//  Copyright © 2019 Virakri Jinangkul. All rights reserved.
//

import UIKit

class BookingViewController: ViewController {
    
    struct HeaderInformation {
        var dayOfWeek: String
        var date: String
        var fromStation: String
        var fromTime: String? = nil
        var toStation: String
        var toTime: String? = nil
        var trainNumber: String? = nil
        var trainName: String? = nil
        var carNumber: String? = nil
        var className: String? = nil
        var seatNumber: String? = nil
        var price: String? = nil
        
        init(dayOfWeek: String, date: String, fromStation: String, toStation: String) {
            self.dayOfWeek = dayOfWeek
            self.date = date
            self.fromStation = fromStation
            self.toStation = toStation
            fromTime = nil
            toTime = nil
            trainNumber = nil
            trainName = nil
            carNumber = nil
            className = nil
            seatNumber = nil
            price = nil
        }
    }
    
    enum MainViewType {
        case tableView
        case view
    }
    
    var headerInformation: HeaderInformation? {
        didSet {
            setHeaderInformationValue(headerInformation)
        }
    }
    
    var mainViewType: MainViewType = .tableView {
        didSet {
            switch mainViewType {
            case .tableView:
                mainTableView.isHidden = false
                mainContentView.isHidden = true
                mainCallToActionButton.isHidden = true
            case .view:
                mainTableView.isHidden = true
                mainContentView.isHidden = false
                mainCallToActionButton.isHidden = false
            }
        }
    }
    
    static let feedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
    
    var isPopPerforming: Bool = false {
        didSet {
            if oldValue != isPopPerforming && isPopPerforming == true {
                navigationController?.popViewController(animated: true)
                BookingViewController.feedbackGenerator.impactOccurred()
            }
        }
    }
    
    var mainCallToActionButton: Button!
    
    var mainStackView: UIStackView!
    
    var headerWithTopBarStackView: UIStackView!
    
    var backButton: BackButtonControl!
    
    var dateLabel: Label!
    
    var datePlaceholderLabel: Label!
    
    var headerRouteInformationView: HeaderRouteInformationView!
    
    var mainContentView: UIView!
    
    var mainTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupView() {
        super.setupView()
        
        dateLabel = Label()
        
        datePlaceholderLabel = Label()
        datePlaceholderLabel
            .translatesAutoresizingMaskIntoConstraints = false
        datePlaceholderLabel.heightAnchor
            .constraint(equalToConstant: 44)
            .isActive = true
        datePlaceholderLabel.text = " "
        
        headerRouteInformationView = HeaderRouteInformationView(fromStation: " ", toStation: " ")
        
        headerWithTopBarStackView = UIStackView([datePlaceholderLabel,
                                                 headerRouteInformationView],
                                                axis: .vertical,
                                                distribution: .fill,
                                                alignment: .fill,
                                                spacing: 8)
        
        let headerWithTopBarContainerView = UIView(containingView: headerWithTopBarStackView, withConstaintEquals: [.topSafeArea, .leadingMargin, .trailingMargin, .bottom])
        headerWithTopBarContainerView.preservesSuperviewLayoutMargins = true
        
        
        let headerWithTopBarContainerViewWidthConstraint = headerWithTopBarContainerView.widthAnchor.constraint(equalToConstant: DesignSystem.layout.maximumWidth)
        headerWithTopBarContainerViewWidthConstraint.priority = .defaultHigh
        headerWithTopBarContainerViewWidthConstraint.isActive = true
        
        mainContentView = UIView()
        mainContentView.preservesSuperviewLayoutMargins = true
        mainContentView.backgroundColor = .clear
        mainContentView.isHidden = true
        
        mainTableView = UITableView(frame: .zero, style: .plain)
        mainTableView.preservesSuperviewLayoutMargins = true
        mainTableView.showsVerticalScrollIndicator = false
        mainTableView.backgroundColor = .clear
        mainTableView.separatorStyle = .none
        mainTableView.contentInset.top = 12
        mainTableView.contentOffset.y = -12
        mainTableView.delegate = self
        
        let mainTableViewWidthConstraint = mainTableView.widthAnchor.constraint(equalToConstant: DesignSystem.layout.maximumWidth)
        mainTableViewWidthConstraint.priority = .defaultHigh
        mainTableViewWidthConstraint.isActive = true
        
        mainStackView = UIStackView([headerWithTopBarContainerView,
                                     mainContentView,
                                     mainTableView],
                                    axis: .vertical,
                                    distribution: .fill,
                                    alignment: .center,
                                    spacing: 20)
        mainStackView.preservesSuperviewLayoutMargins = true
        
        mainContentView.widthAnchor.constraint(equalTo: mainStackView.widthAnchor).isActive = true
        
        view.addSubview(mainStackView, withConstaintEquals: .edges)
        
        // MARK: Setup Button
        mainCallToActionButton = Button(type: .contained)
        view.addSubview(mainCallToActionButton, withConstaintEquals: .centerHorizontal)
        
        view.addConstraints(toView: mainCallToActionButton, withConstaintGreaterThanOrEquals: [.leadingMargin, .trailingMargin])
        
        view.constraintBottomSafeArea(to: mainCallToActionButton,
                                      withGreaterThanConstant: 16,
                                      minimunConstant: 8)
        
        let mainCallToActionButtonWidthConstraint = mainCallToActionButton.widthAnchor.constraint(equalToConstant: DesignSystem.layout.maximumWidth)
        mainCallToActionButtonWidthConstraint.priority = .defaultHigh
        mainCallToActionButtonWidthConstraint.isActive = true
        
        view.addSubview(dateLabel)
        datePlaceholderLabel
            .addConstraints(toView: dateLabel,
                            withConstaintEquals: .center)
        
        backButton = BackButtonControl()
        view.addSubview(backButton)
        backButton
            .centerYAnchor
            .constraint(equalTo:
                datePlaceholderLabel
                    .centerYAnchor)
            .isActive = true
        backButton
            .leadingAnchor
            .constraint(equalTo:
                datePlaceholderLabel
                .leadingAnchor,
                        constant: -10)
            .isActive = true
        
        setHeaderInformationValue(headerInformation)
        
    }
    
    override func setupTheme() {
        super.setupTheme()
        
        mainCallToActionButton.setupTheme()
        backButton.setupTheme()
        headerRouteInformationView.setupTheme()
        mainTableView.setupTheme()
        
        dateLabel.textStyle = textStyle.headline()
        dateLabel.textAlignment = .center
        dateLabel.textColor = currentColorTheme.componentColor.primaryText
        
        datePlaceholderLabel.textStyle = dateLabel.textStyle
        
    }
    
    override func setupInteraction() {
        super.setupInteraction()
    }
    
    func setHeaderInformationValue(_ headerInformation: HeaderInformation?) {
        guard let headerInformation = headerInformation,
            let dateLabel = dateLabel,
            let headerRouteInformationView = headerRouteInformationView else { return }
        
        dateLabel.text = "\(headerInformation.dayOfWeek), \(headerInformation.date)"
        headerRouteInformationView.setupValue(fromStation: headerInformation.fromStation,
                                              fromTime: headerInformation.fromTime,
                                              toStation: headerInformation.toStation,
                                              toTime: headerInformation.toTime,
                                              trainNumber: headerInformation.trainNumber,
                                              trainName: headerInformation.trainName,
                                              carNumber: headerInformation.carNumber,
                                              className: headerInformation.className,
                                              seatNumber: headerInformation.seatNumber,
                                              price: headerInformation.price)
    }
    
}

extension BookingViewController: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let verticalContentOffset = scrollView.contentOffset.y + scrollView.contentInset.top
       
        if !isPopPerforming {
            headerRouteInformationView.verticalRubberBandEffect(byVerticalContentOffset: verticalContentOffset)
        }
    }
}