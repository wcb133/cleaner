//
//  ViewController.swift
//  Cleaner
//
//  Created by fst on 2021/3/12.
//

import UIKit
import QMUIKit
import AppTrackingTransparency


class HomeVC: AppBaseVC {

    
    @IBOutlet weak var clearAllBtn: QMUIButton!
    
    @IBOutlet weak var memeryLab: UILabel!
    
    @IBOutlet weak var bottomHeightCons: NSLayoutConstraint!
    
    @IBAction func clearAllBtnAction(btn:QMUIButton) {
        
        if DateTool.shared.isExpired() {
            let vc = PurchaseServiceVC()
            vc.successBlock = {
                //继续之前的操作
                let vc = AllAnalyseVC()
                vc.refreshMemeryBlock = {
                    self.refreshPieViewData()
                }
                self.navigationController?.pushViewController(vc, animated: true)
            }
            let nav = AppBaseNav(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            self.navigationController?.present(nav, animated: true, completion: nil)
            return
        }
        
        let vc = AllAnalyseVC()
        vc.refreshMemeryBlock = {
            self.refreshPieViewData()
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func preferredNavigationBarHidden() -> Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        refreshPieViewData()
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            self.bottomHeightCons.constant = 450 + cIndicatorHeight
        }else{
            self.bottomHeightCons.constant = 340 + cIndicatorHeight
        }
        
        //申请权限
        if #available(iOS 14.0, *) {
            ATTrackingManager.requestTrackingAuthorization { (status) in
                
            }
        }
        
        clearAllBtn.layer.cornerRadius = 24
        clearAllBtn.layer.masksToBounds = true
        self.view.backgroundColor = HEX("#B9DFE8")
        
        //杂代码
//        _ = MaintenanceVC()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.clearAllBtn.addGradientLayer()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        ImageAndVideoAnalyseTool.shared.isStopScan = true
        ImageAndVideoAnalyseTool.shared.resetData()
    }
    
    func refreshPieViewData()  {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            let usedSpace = MemoryAnalyseTool.getUsedSpace()
            let totalSpace = MemoryAnalyseTool.getTotalSpace()
//            self.pview.memeryLab.text = String(format: "%0.2f/%0.2fGB", usedSpace,totalSpace)
            let percent = usedSpace / totalSpace
            self.memeryLab.text = String(format: "%0.2f%%", percent * 100.0)
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    
    @IBAction func menuBtanAction(_ sender: UIButton) {
        self.turnToBottomMenuItemAction(idx: sender.tag)
    }
    
    func turnToBottomMenuItemAction(idx:Int) {
        switch idx {
        case 0:
            let vc = ImageAndVideoAnalyseVC()
            vc.refreshMemeryBlock = {
                self.refreshPieViewData()
            }
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case 1:
            let vc = AddressBookManagerVC()
            self.navigationController?.pushViewController(vc, animated: true)
        case 2:
            let vc = CalendarManagerVC()
            vc.setup()
            self.navigationController?.pushViewController(vc, animated: true)
        case 3:
            let vc = ImageAndVideoAnalyseVC()
            vc.isScanPhoto = false
            vc.refreshMemeryBlock = {
                self.refreshPieViewData()
            }
            self.navigationController?.pushViewController(vc, animated: true)
        case 4:
            self.navigationController?.pushViewController(EquipmentInfoVC(), animated: true)
        case 5:
            self.navigationController?.pushViewController(AboutUsInfoVC(), animated: true)
        default:
            break
        }
    }
}

