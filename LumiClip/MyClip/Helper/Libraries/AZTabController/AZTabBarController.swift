//
//  ViewController.swift
//  AZTabBarController
//
//  Created by Antonio Zaitoun on 9/13/16.
//  Copyright © 2016 Crofis. All rights reserved.
//

import UIKit
import EasyNotificationBadge
import GoogleCast
import SnapKit

public typealias AZTabBarAction = () -> Void

public protocol AZTabBarDelegate {
    
    ///This function is called after `didMoveToTabAtIndex` is called. In order for this function to work you must override the var `childViewControllerForStatusBarStyle` in the root controller to return this instance of AZTabBarController.
    /// - parameter tabBar: The current instance of AZTabBarController.
    /// - parameter index: The index of the child view controller which you wish to set a status bar style for.
    func tabBar(_ tabBar: AZTabBarController, statusBarStyleForIndex index: Int)-> UIStatusBarStyle
    
    ///This function is called whenever user clicks the menu a long click. If returned false, the action will be ignored.
    /// - parameter tabBar: The current instance of AZTabBarController.
    /// - parameter index: The index of the child view controller which you wish to disable the long menu click for.
    func tabBar(_ tabBar: AZTabBarController, shouldLongClickForIndex index: Int)-> Bool
    
    func tabBar(_ tabBar: AZTabBarController, shouldOpenTab index: Int)-> Bool
    
    ///This function is called whenever user taps one of the menu buttons.
    /// - parameter tabBar: The current instance of AZTabBarController.
    /// - parameter index: The index of the menu the user tapped.
    func tabBar(_ tabBar: AZTabBarController, didSelectTabAtIndex index: Int, previousIndex: Int)
    
    ///This function is called whenever user taps and hold one of the menu buttons. Note that this function will not be called for a certain index if `shouldLongClickForIndex` is implemented and returns false for that very same index.
    /// - parameter tabBar: The current instance of AZTabBarController.
    /// - parameter index: The index of the menu the user long clicked.
    func tabBar(_ tabBar: AZTabBarController, didLongClickTabAtIndex index:Int)
    
    ///This function is called before the child view controllers are switched.
    /// - parameter tabBar: The current instance of AZTabBarController.
    /// - parameter index: The index of the controller which the tab bar will be switching to.
    func tabBar(_ tabBar: AZTabBarController, willMoveToTabAtIndex index:Int)
    
    ///This function is called after the child view controllers are switched.
    /// - parameter tabBar: The current instance of AZTabBarController.
    /// - parameter index: The index of the controller which the tab bar had switched to.
    func tabBar(_ tabBar: AZTabBarController, didMoveToTabAtIndex index: Int)
    
}

//The point of this extension is to make the delegate functions optional.
public extension AZTabBarDelegate{
    
    func tabBar(_ tabBar: AZTabBarController, statusBarStyleForIndex index: Int)-> UIStatusBarStyle{
        return .default
    }
    
    func tabBar(_ tabBar: AZTabBarController, shouldLongClickForIndex index: Int)-> Bool{
        return true
    }
    func tabBar(_ tabBar: AZTabBarController, shouldOpenTab index: Int)-> Bool {
        return true
    }
    
    func tabBar(_ tabBar: AZTabBarController, didSelectTabAtIndex index: Int, previousIndex: Int){}
    
    func tabBar(_ tabBar: AZTabBarController, didLongClickTabAtIndex index:Int){}
    
    func tabBar(_ tabBar: AZTabBarController, willMoveToTabAtIndex index:Int){}
    
    func tabBar(_ tabBar: AZTabBarController, didMoveToTabAtIndex index: Int){}
    
}

public class AZTabBarController: UIViewController {
    
    /*
     *  MARK: - Static instance methods
     */
    
    ///This function creates an instance of AZTabBarController using the specifed icons and inserts it into the provided view controller.
    /// - parameter parent: The controller which we are inserting our Tab Bar controller into.
    /// - parameter names: An array which contains the names of the icons that will be displayed as default.
    /// - parameter sNames: An optional array which contains the names of the icons that will be displayed when the menu is selected.
    /// - returns: The instance of AZTabBarController which was created.
    open class func insert(into parent:UIViewController, withTabIconNames names: [String],andSelectedIconNames sNames: [String]? = nil)->AZTabBarController {
        let controller = AZTabBarController(withTabIconNames: names,highlightedIcons: sNames)
        parent.addChild(controller)
        parent.view.addSubview(controller.view)
        controller.view.frame = parent.view.bounds
        controller.didMove(toParent: parent)
        
        return controller
    }
    
    ///This function creates an instance of AZTabBarController using the specifed icons and inserts it into the provided view controller.
    /// - parameter parent: The controller which we are inserting our Tab Bar controller into.
    /// - parameter icons: An array which contains the images of the icons that will be displayed as default.
    /// - parameter sIcons: An optional array which contains the images of the icons that will be displayed when the menu is selected.
    /// - returns: The instance of AZTabBarController which was created.
    open class func insert(into parent:UIViewController, withTabIcons icons: [UIImage],andSelectedIcons sIcons: [UIImage]? = nil)->AZTabBarController {
        let controller = AZTabBarController(withTabIcons: icons,highlightedIcons: sIcons)
        parent.addChild(controller)
        parent.view.addSubview(controller.view)
        controller.view.frame = parent.view.bounds
        controller.didMove(toParent: parent)
        return controller
    }
    
    /*
     * MARK: - Public Properties
     */
    
    ///The color of icon in the tab bar when the menu is selected.
    open var selectedColor:UIColor! {
        didSet{
            self.updateInterfaceIfNeeded()
            if selectedIndex >= 0 {
                buttons[self.selectedIndex].isSelected = true
            }
        }
    }
    
    open var normalFont: UIFont!
    
    open var selectedFont: UIFont!
    
    ///The default icon color of the buttons in the tab bar.
    open var defaultColor:UIColor! {
        didSet{
            self.updateInterfaceIfNeeded()
            if selectedIndex >= 0 {
                buttons[self.selectedIndex].isSelected = true
            }
        }
    }
    
    ///The background color of the buttons in the tab bar.
    open var buttonsBackgroundColor:UIColor!{
        didSet{
            if buttonsBackgroundColor != oldValue {
                self.updateInterfaceIfNeeded()
            }
            
        }
    }
    
    ///The current selected index.
    private (set) open var selectedIndex:Int!
    
    open func selectedViewController() -> UIViewController {
        return controllers[selectedIndex] as! UIViewController
    }
    
    ///If the separator line view that is between the buttons container and the primary view container is visable.
    open var separatorLineVisible:Bool = true{
        didSet{
            if separatorLineVisible != oldValue {
                self.setupSeparatorLine()
            }
        }
    }
    
    ///The color of the separator.
    open var separatorLineColor:UIColor!{
        didSet{
            if self.separatorLine != nil {
                self.separatorLine.backgroundColor = separatorLineColor
            }
        }
    }
    
    ///Change the alpha of the deselected menus that do not have actions set on them to 0.5
    open var highlightsSelectedButton:Bool = false
    
    ///The appearance of the notification badge.
    open var notificationBadgeAppearance: BadgeAppearance = BadgeAppearance()
    
    ///The height of the selection indicator.
    open var selectionIndicatorHeight:CGFloat = 3.0{
        didSet{
            updateInterfaceIfNeeded()
        }
    }
    
    open var delegate: AZTabBarDelegate!
    
    /*
     * MARK: - Internal Properties
     */
    
    override public var preferredStatusBarStyle: UIStatusBarStyle{
        return self.statusBarStyle
    }
    
    override public var childForStatusBarStyle: UIViewController?{
        return nil
    }
    
    ///A var to change the status bar appearnce
    internal var statusBarStyle: UIStatusBarStyle = .default{
        didSet{
            if oldValue != statusBarStyle {
                self.setNeedsStatusBarAppearanceUpdate()
            }
        }
    }
    
    ///The view that holds the views of the controllers.
    @IBOutlet fileprivate weak var controllersContainer:UIView!
    
    ///The view which holds the buttons.
    @IBOutlet public weak var buttonsContainer:UIView!
    
    @IBOutlet weak var miniChromeCastView: UIView!
    @IBOutlet weak var miniChromeCastViewHeight: NSLayoutConstraint!
    var miniChromecastPlayerVC: GCKUIMiniMediaControlsViewController!
    var castContainerVC: GCKUICastContainerViewController!
    
    ///The separator line between the controllers container and the buttons container.
    @IBOutlet fileprivate weak var separatorLine:UIView!
    
    ///NSLayoutConstraint of the height of the seperator line.
    @IBOutlet fileprivate weak var separatorLineHeightConstraint:NSLayoutConstraint!
    
   @IBOutlet fileprivate weak  var seprateView: UIView!
   ///NSLayoutConstraint of the height of the button container.
    @IBOutlet fileprivate weak var buttonsContainerHeightConstraint:NSLayoutConstraint!
    
    ///Array which holds the buttons.
    internal var buttons = [AZBarButtonItem]()
    
    ///Array which holds the default tab icons.
    internal var tabIcons:[UIImage]!
    
    ///Optional Array which holds the highlighted tab icons.
    internal var selectedTabIcons: [UIImage]?
    
    internal var tabbarTitles: [String]?
    
    ///The view that goes inside the buttons container and indicates which menu is selected.
    internal var selectionIndicator:UIView!
    
    internal var selectionIndicatorLeadingConstraint:NSLayoutConstraint!
    
    internal var buttonsContainerHeightConstraintInitialConstant:CGFloat!
    
    internal var selectionIndicatorHeightConstraint:NSLayoutConstraint!
    
    /*
     * MARK: - Private Properties
     */
    
    ///Array which holds the controllers.
    fileprivate var controllers:NSMutableDictionary!
    
    ///Array which holds the actions.
    fileprivate var actions:NSMutableDictionary!
    
    ///A flag to indicate if the interface was set up.
    fileprivate var didSetupInterface:Bool = false
    
    ///An array which keeps track of the highlighted menus.
    fileprivate var highlightedButtonIndexes:NSMutableSet!
    
    /*
     * MARK: - Init
     */
    
    public init(withTabIcons tabIcons: [UIImage],highlightedIcons: [UIImage]? = nil) {
        let bundle = Bundle(for: AZTabBarController.self)
        super.init(nibName: "AZTabBarController", bundle: bundle)
        self.initialize(withTabIcons: tabIcons,highlightedIcons: highlightedIcons)
    }
    
    public convenience init(withTabIconNames iconNames: [String],highlightedIcons: [String]? = nil) {
        var icons = [UIImage]()
        for name in iconNames {
            icons.append(UIImage(named: name)!)
        }
        
        var highlighted: [UIImage]?
        if let imageNames = highlightedIcons{
            highlighted = [UIImage]()
            for name in imageNames{
                highlighted?.append(UIImage(named: name)!)
            }
        }
        
        self.init(withTabIcons: icons,highlightedIcons: highlighted)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*
     * MARK: - UIViewController
     */
    
    override public func viewDidLoad() {
        super.viewDidLoad()
      self.seprateView.backgroundColor = UIColor.setDarkModeColor(color1: UIColor.lightGray, color2: UIColor.darkGray)
        self.buttonsContainerHeightConstraintInitialConstant = self.buttonsContainerHeightConstraint.constant
        self.view.backgroundColor = UIColor.setViewColor()
        let castContext = GCKCastContext.sharedInstance()
        miniChromecastPlayerVC = castContext.createMiniMediaControlsViewController()
        miniChromecastPlayerVC.delegate = self
        miniChromecastPlayerVC.view.backgroundColor = AppColor.blackBackgroundColor()
        let btnPlay = miniChromecastPlayerVC.customButton(at: UInt(GCKUIMediaButtonType.playPauseToggle.rawValue))
        btnPlay?.setTitleColor(UIColor.white, for: .normal)
        btnPlay?.tintColor = UIColor.white
        
        self.addChild(miniChromecastPlayerVC)
        miniChromecastPlayerVC.view.frame = miniChromeCastView.bounds
        miniChromeCastView.addSubview(miniChromecastPlayerVC.view)
        miniChromecastPlayerVC.didMove(toParent: self)
        miniChromecastPlayerVC.view.snp.remakeConstraints { (make: ConstraintMaker) in
            make.edges.equalToSuperview()
        }
        
        updateMiniPlayer()
        buttonsContainer.snp.makeConstraints { (maker) in
            maker.bottom.equalTo(self.bottomLayoutGuide.snp.top)
        }
        
        
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if self.selectedIndex == -1 {
            // We only setup everything if there isn't any selected index.
            self.setupInterface()
            self.moveToController(at: 0, animated: false)
        }
    }
    
    func updateMiniPlayer() {
        
        if GCKCastContext.sharedInstance().castState == .connected {
            if miniChromecastPlayerVC.active {
                miniChromeCastViewHeight.constant = 60
            } else {
                miniChromeCastViewHeight.constant = 0
            }
        } else {
            miniChromeCastViewHeight.constant = 0
        }
    }
    
    override public func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        // When rotating, have to update the selection indicator leading to match
        // the selected button x, that might have changed because of the rotation.
        
        let selectedButtonX: CGFloat = (self.buttons[self.selectedIndex]).frame.origin.x
        
        if self.selectionIndicatorLeadingConstraint.constant != selectedButtonX {
            UIView.animate(withDuration: 0.1, animations: {() -> Void in
                self.selectionIndicatorLeadingConstraint.constant = selectedButtonX
                self.view.layoutIfNeeded()
            })
        }
    }
    
    /*
     * MARK: - AZTabBarController
     */
    
    ///Set a UIViewController at an index.
    /// - parameter controller: The view controller which you wish to display at a certain index.
    /// - parameter index: The index of the menu.
    open func set(viewController controller: UIViewController, atIndex index: Int) {
        if let currentViewController:UIViewController = (self.controllers[index] as? UIViewController){
            currentViewController.removeFromParent()
        }
        self.controllers[index] = controller
        if index == self.selectedIndex {
            // If the index is the selected one, we have to update the view
            // controller at that index so that the change is reflected.
            self.moveToController(at: index, animated: false)
        }
    }
    
    ///Change the current menu programatically.
    /// - parameter index: The index of the menu.
    /// - parameter animated: animate the selection indicator or not.
    open func set(selectedIndex index:Int,animated:Bool){
        if delegate.tabBar(self, shouldOpenTab: index) {
            if self.selectedIndex != index {
                moveToController(at: index, animated: animated)
            }
            
            if let action:AZTabBarAction = actions[index] as? AZTabBarAction {
                action()
            }
        }
    }
    
    ///Set an action at a certain index.
    /// - parameter action: A closure which contains the action that will be executed when clicking the menu at a certain index.
    /// - parameter index: The index of the menu of which you would like to add an action to.
    open func set(action: @escaping AZTabBarAction, atIndex index: Int) {
        self.actions[(index)] = action
    }
    
    ///Set a badge with a text on a menu at a certain index. In order to remove an existing badge use `nil` for the `text` parameter.
    /// - parameter text: The text you wish to set.
    /// - parameter index: The index of the menu in which you would like to add the badge.
    open func set(badgeText text: String?, atIndex index:Int){
        self.notificationBadgeAppearance.distanceFromCenterX = 15
        self.notificationBadgeAppearance.distanceFromCenterY = -10
        buttons[index].badge(text: text, appearance: self.notificationBadgeAppearance)
    }
    
    ///Make a button look highlighted.
    /// - parameter index: The index of the button which you would like to highlight.
    open func highlightButton(atIndex index: Int) {
        self.highlightedButtonIndexes.add(index)
        self.updateInterfaceIfNeeded()
    }
    
    ///Set a tint color for a button at a certain index.
    /// - parameter color: The color which you would like to set as tint color for the button at a certain index.
    /// - parameter index: The index of the button.
//    open func setButtonTintColor(color: UIColor, atIndex index: Int) {
//        if !self.highlightedButtonIndexes.contains((index)) {
//            let button:UIButton = self.buttons[index] as! UIButton
//            button.tintColor! = color
//            let buttonImage = button.image(for: .normal)!
//            button.setImage(buttonImage.withRenderingMode(.alwaysTemplate), for: .normal)
//            button.setImage(buttonImage.withRenderingMode(.alwaysTemplate), for: .selected)
//        }
//    }
    
    ///Show and hide the tab bar.
    /// - parameter hidden: To hide or show.
    /// - parameter animated: To animate or not.
    open func setBar(hidden: Bool, animated: Bool) {
        let animations = {() -> Void in
            self.buttonsContainerHeightConstraint.constant = hidden ? 0 : self.buttonsContainerHeightConstraintInitialConstant
            self.view.layoutIfNeeded()
        }
        if animated {
            self.view.layoutIfNeeded()
            UIView.animate(withDuration: 0.5, animations: animations)
        }
        else {
            animations()
        }
    }
    
    /*
     * MARK: - Actions
     */
    
    @objc func tabButtonAction(button:UIButton){
        let index = button.tag
        if let delegate = delegate{
            delegate.tabBar(self, didSelectTabAtIndex: index, previousIndex: selectedIndex)
        }
        
        if index != NSNotFound {
            self.set(selectedIndex: index, animated: true)
        }
    }
    
    @objc func longClick(sender:AnyObject?){
        guard let button = (sender as! UIGestureRecognizer).view as? UIButton else {
            return
        }
        let index = button.tag
        
        if let delegate = delegate{
            if !delegate.tabBar(self, shouldLongClickForIndex: index) {
                return
            }
        }
        
        
        if let delegate = delegate {
            delegate.tabBar(self, didLongClickTabAtIndex: index)
        }
        
        
        if selectedIndex != index {
            tabButtonAction(button: button)
        }
        
    }
    
    
    /*
     * MARK: - Private methods
     */
    
    private func initialize(withTabIcons tabIcons:[UIImage],highlightedIcons: [UIImage]? = nil){
        assert(tabIcons.count > 0, "The array of tab icons shouldn't be empty.")
        
        if let highlightedIcons = highlightedIcons {
            assert(tabIcons.count == highlightedIcons.count,"Default and highlighted icons must come in pairs.")
        }
        
        self.tabIcons = tabIcons
        
        self.selectedTabIcons = highlightedIcons
        
        self.controllers = NSMutableDictionary(capacity: tabIcons.count)
        
        self.actions = NSMutableDictionary(capacity: tabIcons.count)
        
        self.highlightedButtonIndexes = NSMutableSet()
        
        self.selectedIndex = -1
        
        self.separatorLineColor = UIColor.lightGray
        
        self.modalPresentationCapturesStatusBarAppearance = true
        
    }
    
    private func updateInterfaceIfNeeded() {
        if self.didSetupInterface {
            // If the UI was already setup, it's necessary to update it.
            self.setupInterface()
        }
    }
    
    private func setupInterface(){
        self.setupButtons()
        self.setupSelectionIndicator()
        self.setupSeparatorLine()
        self.didSetupInterface = true
    }
    
    private func setupButtons(){
        
        if self.buttons.isEmpty {
            self.buttons = [AZBarButtonItem]()
            
            for i in 0 ..< self.tabIcons.count {
                
                let button:AZBarButtonItem = self.createButton(forIndex: i)
                
                self.buttonsContainer.addSubview(button)
                
                self.buttons.append(button)
            }
            self.setupButtonsConstraints()
        }
        self.customizeButtons()
        
        self.buttonsContainer.backgroundColor = self.buttonsBackgroundColor != nil ? self.buttonsBackgroundColor : UIColor.lightGray
    }
    
    private func customizeButtons(){
        for i in 0 ..< self.tabIcons.count {
            let button = self.buttons[i]
            
            let isHighlighted = self.highlightedButtonIndexes.contains(i)
            
            var highlightedImage: UIImage?
            if let selectedImages = self.selectedTabIcons {
                highlightedImage = selectedImages[i]
            }
            
            button.customizeForTabBarWithImage(image: self.tabIcons[i],
                                               highlightImage: highlightedImage,
                                               selectedColor: self.selectedColor ?? UIColor.black,
                                               highlighted: isHighlighted,
                                               defaultColor: self.defaultColor ?? UIColor.gray,
                                               normalFont: normalFont,
                                               selectedFont: selectedFont)
        }
    }
    
    private func createButton(forIndex index:Int)-> AZBarButtonItem{
        let tabbarItem = AZBarButtonItem(frame: .zero)
//        let button = UIButton(type: .custom)
        tabbarItem.button.setTitleColor(defaultColor, for: .normal)
        tabbarItem.button.setTitleColor(selectedColor, for: .selected)
        tabbarItem.button.isExclusiveTouch = true
        tabbarItem.button.tag = index
        tabbarItem.button.addTarget(self, action: #selector(self.tabButtonAction(button:)), for: .touchUpInside)
        tabbarItem.button.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(self.longClick(sender:))))
        tabbarItem.titleLabel.text = tabbarTitles?[index]
        return tabbarItem
    }
    
    private func moveToController(at index:Int,animated:Bool){
        let subController:UIViewController? = controllers[index] as? UIViewController
        if let controller = subController {
            
            // Deselect all the buttons excepting the selected one.
            for i in 0 ..< self.tabIcons.count{
                let button = self.buttons[i]
                let selected:Bool = i == index
                
                button.isSelected = selected
                
                if self.highlightsSelectedButton && !(self.actions[i] != nil && self.controllers[i] != nil){
                    button.alpha = selected ? 1.0 : 0.5
                }
            }
            
            if let delegate = delegate {
                delegate.tabBar(self, willMoveToTabAtIndex: index)
            }
            
            if self.selectedIndex >= 0 {
                let currentController:UIViewController = self.controllers[selectedIndex] as! UIViewController
                currentController.view.removeFromSuperview()
                currentController.removeFromParent()
            }
            
            if !self.children.contains(controller){
                controller.willMove(toParent: self)
            }
            
            if NSFoundationVersionNumber <= NSFoundationVersionNumber_iOS_7_1 {
                // Table views have an issue when disabling autoresizing
                // constraints in iOS 7.
                // Their width is set to zero initially and then it's not able to
                // adjust it again, causing constraint conflicts with the cells
                // inside the table.
                // For this reason, we just adjust the frame to the container
                // bounds leaving the autoresizing constraints enabled.
                controller.view.frame = self.controllersContainer.bounds
                self.controllersContainer.addSubview(controller.view)
                
            }else{
                controller.view.translatesAutoresizingMaskIntoConstraints = false
                self.controllersContainer.addSubview(controller.view)
                self.setupConstraints(forChildController: controller)
            }
            self.addChild(controller)
            controller.didMove(toParent: self)
            self.moveSelectionIndicator(toIndex: index,animated:animated)
            self.selectedIndex = index
            if let delegate = delegate {
                delegate.tabBar(self, didMoveToTabAtIndex: index)
                self.statusBarStyle = delegate.tabBar(self, statusBarStyleForIndex: index)
            }
        }
        
    }
    
    private func setupSelectionIndicator() {
        if self.selectionIndicator == nil {
            self.selectionIndicator = UIView()
            self.selectionIndicator.translatesAutoresizingMaskIntoConstraints = false
            self.buttonsContainer.addSubview(self.selectionIndicator)
            self.setupSelectionIndicatorConstraints()
        }
        self.selectionIndicatorHeightConstraint.constant = self.selectionIndicatorHeight
        self.selectionIndicator.backgroundColor = self.selectedColor ?? UIColor.black
    }
    
    private func setupSeparatorLine() {
        self.separatorLine.backgroundColor = self.separatorLineColor
        self.separatorLine.isHidden = !self.separatorLineVisible
        self.separatorLineHeightConstraint.constant = 0.5
    }
    
    private func moveSelectionIndicator(toIndex index: Int,animated:Bool){
        let constant:CGFloat = self.buttons[index].frame.origin.x
        
        self.buttonsContainer.layoutIfNeeded()
        
        let animations = {() -> Void in
            self.selectionIndicatorLeadingConstraint.constant = constant
            self.buttonsContainer.layoutIfNeeded()
        }
        
        if animated {
            UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseIn, animations: animations, completion: { _ in })
        }
        else {
            animations()
        }
    }
}


/*
 * MARK: - AutoLayout
 */

fileprivate extension AZTabBarController {
    
    
    /*
     * MARK: - Public Methods
     */
    
    func setupButtonsConstraints(){
        for i in 0 ..< self.tabIcons.count {
            let button = self.buttons[i]
            
            button.translatesAutoresizingMaskIntoConstraints = false
            
            self.view.addConstraints(self.leftLayoutConstraintsForButtonAtIndex(index: i))
            self.view.addConstraints(self.verticalLayoutConstraintsForButtonAtIndex(index: i))
            self.view.addConstraint(self.widthLayoutConstraintForButtonAtIndex(index: i))
            self.view.addConstraint(self.heightLayoutConstraintForButtonAtIndex(index: i))
        }
    }
    
    func setupSelectionIndicatorConstraints(){
        self.selectionIndicatorLeadingConstraint = self.leadingLayoutConstraintForIndicator()
        
        self.buttonsContainer.addConstraint(self.selectionIndicatorLeadingConstraint)
        self.buttonsContainer.addConstraints(self.widthLayoutConstraintsForIndicator())
        self.buttonsContainer.addConstraints(self.heightLayoutConstraintsForIndicator())
        self.buttonsContainer.addConstraints(self.bottomLayoutConstraintsForIndicator())
    }
    
    func setupConstraints(forChildController controller: UIViewController) {
        let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[view]-0-|", options: [], metrics: nil, views: ["view": controller.view])
        self.controllersContainer.addConstraints(horizontalConstraints)
        let verticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[view]-0-|", options: [], metrics: nil, views: ["view": controller.view])
        self.controllersContainer.addConstraints(verticalConstraints)
    }
    
    /*
     * MARK: - Private Methods
     */
    private func leftLayoutConstraintsForButtonAtIndex(index: Int)-> [NSLayoutConstraint]{
        let button = self.buttons[index]
        var leftConstraints:[NSLayoutConstraint]!
        
        if index == 0 {
            leftConstraints = NSLayoutConstraint.constraints(withVisualFormat: "|-(0)-[button]", options: [], metrics: nil, views: ["button": button])
        }else {
            
            let views = ["previousButton": self.buttons[index - 1], "button": button]
            
            leftConstraints = NSLayoutConstraint.constraints(withVisualFormat: "[previousButton]-(0)-[button]", options: [], metrics: nil, views: views)
            
        }
        return leftConstraints
    }
    
    private func verticalLayoutConstraintsForButtonAtIndex(index: Int)-> [NSLayoutConstraint]{
        let button = self.buttons[index]
        
        return NSLayoutConstraint.constraints(withVisualFormat: "V:|-(0)-[button]", options: [], metrics: nil, views: ["button": button])
        
    }
    
    private func widthLayoutConstraintForButtonAtIndex(index: Int)->NSLayoutConstraint {
        let button = self.buttons[index]
        
        return NSLayoutConstraint(item: button, attribute: .width, relatedBy: .equal, toItem: self.buttonsContainer, attribute: .width, multiplier: 1.0 / CGFloat(self.buttons.count), constant: 0.0)
    }
    
    private func heightLayoutConstraintForButtonAtIndex(index: Int)-> NSLayoutConstraint {
        let button = self.buttons[index]
        
        return NSLayoutConstraint(item: button, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: self.buttonsContainerHeightConstraintInitialConstant)
    }
    
    private func leadingLayoutConstraintForIndicator()->NSLayoutConstraint {
        let constraints = NSLayoutConstraint.constraints(withVisualFormat: "|-(0)-[selectionIndicator]", options: [], metrics: nil, views: ["selectionIndicator": self.selectionIndicator])
        
        return constraints.first!
    }
    
    private func widthLayoutConstraintsForIndicator()-> [NSLayoutConstraint]{
        let views = ["button": self.buttons[0], "selectionIndicator": self.selectionIndicator]
        
        return NSLayoutConstraint.constraints(withVisualFormat: "[selectionIndicator(==button)]", options: [], metrics: nil, views: views)
    }
    
    private func heightLayoutConstraintsForIndicator()-> [NSLayoutConstraint] {
        let heightConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:[selectionIndicator(==3)]", options: [], metrics: nil, views: ["selectionIndicator": self.selectionIndicator])
        
        self.selectionIndicatorHeightConstraint = heightConstraints.first!
        
        return heightConstraints
    }
    
    private func bottomLayoutConstraintsForIndicator()-> [NSLayoutConstraint] {
        return NSLayoutConstraint.constraints(withVisualFormat: "V:[selectionIndicator]-(0)-|", options: [], metrics: nil, views: ["selectionIndicator": self.selectionIndicator])
    }
}

/*
 * MARK: - Button Extension
 */

fileprivate extension AZBarButtonItem {
    // MARK: - Public methods
    
    func customizeForTabBarWithImage(image: UIImage,highlightImage: UIImage? = nil, selectedColor: UIColor, highlighted: Bool,defaultColor: UIColor? = UIColor.gray, normalFont: UIFont, selectedFont: UIFont) {
        self.normalImage = image.imageWithColor(color: defaultColor!)
        self.selectedImage = image.imageWithColor(color: selectedColor)
        self.selectedColor = selectedColor
        self.normalColor = defaultColor!
        self.selectedFont = selectedFont
        self.normalFont = normalFont
    }
}

fileprivate extension UIImage {
    func imageWithColor(color: UIColor) -> UIImage? {
        var image = withRenderingMode(.alwaysTemplate)
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        color.set()
        image.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}

extension AZTabBarController: GCKUIMiniMediaControlsViewControllerDelegate {
    public func miniMediaControlsViewController(_ miniMediaControlsViewController: GCKUIMiniMediaControlsViewController,
                                         shouldAppear: Bool) {
        updateMiniPlayer()
    }
}
