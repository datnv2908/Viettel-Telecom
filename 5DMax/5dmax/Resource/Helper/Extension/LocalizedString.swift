//
//  LocalizedString.swift
//  5dmax
//
//  Created by Huy Nguyen on 4/24/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import Foundation
extension String {
    //mark: - Common
    static var okString: String { return RTLocalizationSystem.rtLocalize("OK", comment: "")}
    static var cancel: String { return RTLocalizationSystem.rtLocalize("Cancel", comment: "")}
    static var ignore: String { return RTLocalizationSystem.rtLocalize("Ignore", comment: "")}
    static var logout: String { return RTLocalizationSystem.rtLocalize("Logout", comment: "")}
    static var logoutConfirmMsg: String { return RTLocalizationSystem.rtLocalize("LogoutConfirm", comment: "")}
    static var loginFailedMsg: String { return RTLocalizationSystem.rtLocalize("LoginFailMessage", comment: "")}
    static var loginSuccessMsg: String {return RTLocalizationSystem.rtLocalize("LoginSuccessMessage", comment: "")}
    static var internetConnectionLost: String { return RTLocalizationSystem.rtLocalize("InternetConnectLost", comment: "")}
    static var dataNotFound: String { return RTLocalizationSystem.rtLocalize("DataNotFound", comment: "")}
    static var enterOTP: String { return RTLocalizationSystem.rtLocalize("EnterOTP", comment: "")}
    static var enterfailOTP: String {return RTLocalizationSystem.rtLocalize("EnterfailOTP", comment: "")}
    static var enterPhoneNumber: String { return RTLocalizationSystem.rtLocalize("EnterPhoneNumber", comment: "")}
    static var enterPassword: String { return RTLocalizationSystem.rtLocalize("EnterPassword", comment: "")}
    static var invalidPhoneNumber: String { return RTLocalizationSystem.rtLocalize("InvalidPhoneNumber", comment: "")}
    static var messageNotSupport: String { return RTLocalizationSystem.rtLocalize("DeviceCannotSendMsg", comment: "")}
    static var register: String { return RTLocalizationSystem.rtLocalize("Register", comment: "")}
    static var buyRetail: String { return RTLocalizationSystem.rtLocalize("BuyRetail", comment: "")}
    static var rentFilm: String { return RTLocalizationSystem.rtLocalize("rentFilm", comment: "")}
    static var buyFilm: String { return RTLocalizationSystem.rtLocalize("buyFilm", comment: "")}
    static var auto: String { return RTLocalizationSystem.rtLocalize("Auto", comment: "")}

    //mark: -- package list
    static var registerSubTitle: String { return RTLocalizationSystem.rtLocalize("RegisterSubTitle", comment: "")}
    static var unregisterSubTitle: String { return RTLocalizationSystem.rtLocalize("UnregisterSubTitle", comment: "")}
    static var registerSubSuccess: String { return RTLocalizationSystem.rtLocalize("RegisterSubSuccess", comment: "")}
    static var registerSubNotSuccess: String { return RTLocalizationSystem.rtLocalize("RegisterSubNotSuccess", comment: "")}
    static var unregisterSubSuccess: String { return RTLocalizationSystem.rtLocalize("UnregisterSubSuccess", comment: "")}
    static var unregisterSubNotSuccess: String { return RTLocalizationSystem.rtLocalize("UnregisterSubNotSuccess", comment: "")}

    //mark: -- register
    static var registerSuccess: String { return RTLocalizationSystem.rtLocalize("RegisterSuccess", comment: "")}
    static var rentSuccess: String { return RTLocalizationSystem.rtLocalize("RentSuccess", comment: "")}
    static var enterConfirmPassword: String { return RTLocalizationSystem.rtLocalize("EnterConfirmPassword", comment: "")}
    static var confirmPasswordNotMatch: String { return RTLocalizationSystem.rtLocalize("ConfirmPasswordNotMatch", comment: "")}

    //mark: -- change password
    static var changePasswordSuccess: String { return RTLocalizationSystem.rtLocalize("ChangePasswordSuccess", comment: "")}
    static var enterNewPassword: String { return RTLocalizationSystem.rtLocalize("EnterNewPassword", comment: "")}
    static var enterCaptcha: String { return RTLocalizationSystem.rtLocalize("EnterCaptcha", comment: "")}

    //mark: -- detail view
    static var addedToWatchLater: String { return RTLocalizationSystem.rtLocalize("AddedToWatchLater", comment: "")}

    //mark: -- content filter
    static var changePinSuccess: String { return RTLocalizationSystem.rtLocalize("ChangePinSuccess", comment: "")}
    static var pinCodeNotCorrect: String { return RTLocalizationSystem.rtLocalize("PinCodeNotCorrect", comment: "")}
    static var enterPinCode: String { return RTLocalizationSystem.rtLocalize("EnterPinCode", comment: "")}
    static var setupPinCodeSuccess: String { return RTLocalizationSystem.rtLocalize("SetupPinCodeSuccess", comment: "")}

    //mark: -- LINK FACEBOOK ACCOUNT TO PHONE NUMBER
    static var otpSentToPhoneNumber: String { return RTLocalizationSystem.rtLocalize("OtpSentToPhoneNumber", comment: "")}
    static var linkSuccess: String { return RTLocalizationSystem.rtLocalize("LinkSuccess", comment: "")}

    //mark: -- LINK FACEBOOK ACCOUNT TO PHONE NUMBER
    static var badUrl: String { return RTLocalizationSystem.rtLocalize("BadUrl", comment: "")}
    
    static var dang_ky: String { return RTLocalizationSystem.rtLocalize("dang_ky", comment: "")}
    static var dang_ky_sub: String { return RTLocalizationSystem.rtLocalize("dang_ky_sub", comment: "")}
    static var mat_khau_tam_thoi: String { return RTLocalizationSystem.rtLocalize("mat_khau_tam_thoi", comment: "")}
    static var check_term_msg: String { return RTLocalizationSystem.rtLocalize("check_term_msg", comment: "")}
    static var phim_mien_phi: String { return RTLocalizationSystem.rtLocalize("phim_mien_phi", comment: "")}
    static var phim_theo_the_loai: String { return RTLocalizationSystem.rtLocalize("phim_theo_the_loai", comment: "")}
    static var phim_hot: String { return RTLocalizationSystem.rtLocalize("phim_hot", comment: "")}
    static var phim_de_cu: String { return RTLocalizationSystem.rtLocalize("phim_de_cu", comment: "")}
    static var phim_moi: String { return RTLocalizationSystem.rtLocalize("phim_moi", comment: "")}
    static var phim_theo_quoc_gia_dien_vien_dao_dien: String { return RTLocalizationSystem.rtLocalize("phim_theo_quoc_gia_dien_vien_dao_dien", comment: "")}
    static var phim_loc_theo_nam: String { return RTLocalizationSystem.rtLocalize("phim_loc_theo_nam", comment: "")}
    static var phim_cua_toi: String { return RTLocalizationSystem.rtLocalize("phim_cua_toi", comment: "")}
    static var phim_da_xem: String { return RTLocalizationSystem.rtLocalize("phim_da_xem", comment: "")}
    static var lich_su_giao_dich_thue_bao: String { return RTLocalizationSystem.rtLocalize("lich_su_giao_dich_thue_bao", comment: "")}
    static var thong_bao: String { return RTLocalizationSystem.rtLocalize("thong_bao", comment: "")}
    static var trang_chu: String { return RTLocalizationSystem.rtLocalize("trang_chu", comment: "")}
    static var phim_co_phi: String { return RTLocalizationSystem.rtLocalize("phim_co_phi", comment: "")}
    static var cho_thue_noi_dung: String { return RTLocalizationSystem.rtLocalize("cho_thue_noi_dung", comment: "")}
    static var the_loai: String { return RTLocalizationSystem.rtLocalize("the_loai", comment: "")}
    static var xem_sau: String { return RTLocalizationSystem.rtLocalize("xem_sau", comment: "")}
    static var download: String { return RTLocalizationSystem.rtLocalize("download", comment: "")}
    static var dang_ky_vip: String { return RTLocalizationSystem.rtLocalize("dang_ky_vip", comment: "")}
    static var moi_cap_nhat: String { return RTLocalizationSystem.rtLocalize("moi_cap_nhat", comment: "")}
    static var thiet_lap: String { return RTLocalizationSystem.rtLocalize("thiet_lap", comment: "")}
    static var tai_khoan: String { return RTLocalizationSystem.rtLocalize("tai_khoan", comment: "")}
    static var dieu_khoan: String { return RTLocalizationSystem.rtLocalize("dieu_khoan", comment: "")}
    static var xem_dieu_khoan: String { return RTLocalizationSystem.rtLocalize("xem_dieu_khoan", comment: "")}
    static var ho_tro: String { return RTLocalizationSystem.rtLocalize("ho_tro", comment: "")}
    static var dang_xuat: String { return RTLocalizationSystem.rtLocalize("dang_xuat", comment: "")}
    static var odd_Movie: String { return RTLocalizationSystem.rtLocalize("odd_Movie", comment: "")}
    static var series_Movie: String { return RTLocalizationSystem.rtLocalize("series_Movie", comment: "")}
    static var quan_ly_goi_cuoc: String { return RTLocalizationSystem.rtLocalize("quan_ly_goi_cuoc", comment: "")}
    static var facebook: String { return RTLocalizationSystem.rtLocalize("facebook", comment: "")}
    static var doi_mat_khau: String { return RTLocalizationSystem.rtLocalize("doi_mat_khau", comment: "")}
    static var chat_luong: String { return RTLocalizationSystem.rtLocalize("chat_luong", comment: "")}
    static var quan_ly_noi_dung: String { return RTLocalizationSystem.rtLocalize("quan_ly_noi_dung", comment: "")}
    static var tro_giup: String { return RTLocalizationSystem.rtLocalize("tro_giup", comment: "")}
    static var dieu_khoan_dich_vu: String { return RTLocalizationSystem.rtLocalize("dieu_khoan_dich_vu", comment: "")}
    static var chinh_sach_bao_mat: String { return RTLocalizationSystem.rtLocalize("chinh_sach_bao_mat", comment: "")}
    static var phien_ban: String { return RTLocalizationSystem.rtLocalize("phien_ban", comment: "")}
    static var phim_bo: String { return RTLocalizationSystem.rtLocalize("phim_bo", comment: "")}
    static var dang_xem: String { return RTLocalizationSystem.rtLocalize("dang_xem", comment: "")}
    static var truoc: String { return RTLocalizationSystem.rtLocalize("truoc", comment: "")}
    static var huy_goi_cuoc_dk: String { return RTLocalizationSystem.rtLocalize("huy_goi_cuoc_dk", comment: "")}
    static var si_dong_y: String { return RTLocalizationSystem.rtLocalize("si_dong_y", comment: "")}
    static var dong_y: String { return RTLocalizationSystem.rtLocalize("dong_y", comment: "")}
    static var huy_bo: String { return RTLocalizationSystem.rtLocalize("huy_bo", comment: "")}
    static var bo_qua: String { return RTLocalizationSystem.rtLocalize("bo_qua", comment: "")}
    static var thiet_bi_khong_the_thuc_hien_cuoc_goi: String { return RTLocalizationSystem.rtLocalize("thiet_bi_khong_the_thuc_hien_cuoc_goi", comment: "")}
    static var xin_moi_noi: String { return RTLocalizationSystem.rtLocalize("xin_moi_noi", comment: "")}
    static var tu_dong: String { return RTLocalizationSystem.rtLocalize("tu_dong", comment: "")}
    static var tai_ve: String { return RTLocalizationSystem.rtLocalize("tai_ve", comment: "")}
    static var chon_chat_luong: String { return RTLocalizationSystem.rtLocalize("chon_chat_luong", comment: "")}
    static var dang_cap_nhat: String { return RTLocalizationSystem.rtLocalize("dang_cap_nhat", comment: "")}
    static var quoc_gia: String { return RTLocalizationSystem.rtLocalize("quoc_gia", comment: "")}
    static var thoi_gian_su_dung: String { return RTLocalizationSystem.rtLocalize("thoi_gian_su_dung", comment: "")}
    static var thue_phim: String { return RTLocalizationSystem.rtLocalize("thue_phim", comment: "")}
    static var thue_tap_drm: String { return RTLocalizationSystem.rtLocalize("thue_tap_drm", comment: "")}
    static var thue_toan_bo_drm: String { return RTLocalizationSystem.rtLocalize("thue_toan_bo_drm", comment: "")}
    static var thue_tap: String { return RTLocalizationSystem.rtLocalize("thue_tap", comment: "")}
    static var thue_toan_bo: String { return RTLocalizationSystem.rtLocalize("thue_toan_bo", comment: "")}
    static var gia_cuoc: String { return RTLocalizationSystem.rtLocalize("gia_cuoc", comment: "")}
    static var dang_ky_goi_cuoc: String { return RTLocalizationSystem.rtLocalize("dang_ky_goi_cuoc", comment: "")}
    static var ngay_thang: String { return RTLocalizationSystem.rtLocalize("ngay_thang", comment: "")}
    static var danh_sach_cua_toi: String { return RTLocalizationSystem.rtLocalize("danh_sach_cua_toi", comment: "")}
    static var thiet_bi_khong_ho_tro_nhan_tin: String { return RTLocalizationSystem.rtLocalize("thiet_bi_khong_ho_tro_nhan_tin", comment: "")}
    static var danh_sach_tap: String { return RTLocalizationSystem.rtLocalize("danh_sach_tap", comment: "")}
    static var tap_tiep_theo: String { return RTLocalizationSystem.rtLocalize("tap_tiep_theo", comment: "")}
    static var tap: String { return RTLocalizationSystem.rtLocalize("tap", comment: "")}
    static var dien_vien: String { return RTLocalizationSystem.rtLocalize("dien_vien", comment: "")}
    static var danh_gia: String { return RTLocalizationSystem.rtLocalize("danh_gia", comment: "")}
    static var season_1: String { return RTLocalizationSystem.rtLocalize("season_1", comment: "")}
    static var seasons: String { return RTLocalizationSystem.rtLocalize("seasons", comment: "")}
    static var trailers: String { return RTLocalizationSystem.rtLocalize("trailers", comment: "")}
    static var phim_lien_quan: String { return RTLocalizationSystem.rtLocalize("phim_lien_quan", comment: "")}
    static var thanh_cong: String { return RTLocalizationSystem.rtLocalize("thanh_cong", comment: "")}
    static var xem_them: String { return RTLocalizationSystem.rtLocalize("xem_them", comment: "")}
    static var xac_thuc_lien_ket_tai_khoan: String { return RTLocalizationSystem.rtLocalize("xac_thuc_lien_ket_tai_khoan", comment: "")}
    static var quy_khach_vui_long_lien_ket_tai_khoan_voi_so_dien_thoai_de_xem_cac_noi_dung_tinh_phi_tren_5Dmax: String { return RTLocalizationSystem.rtLocalize("quy_khach_vui_long_lien_ket_tai_khoan_voi_so_dien_thoai_de_xem_cac_noi_dung_tinh_phi_tren_5Dmax", comment: "")}
    static var lay_ma_xac_thuc: String { return RTLocalizationSystem.rtLocalize("lay_ma_xac_thuc", comment: "")}
    static var lien_he_198_de_duoc_ho_tro: String { return RTLocalizationSystem.rtLocalize("lien_he_198_de_duoc_ho_tro", comment: "")}
    static var so_dien_thoai: String { return RTLocalizationSystem.rtLocalize("so_dien_thoai", comment: "")}
    static var nhap_ma_xac_nhan: String { return RTLocalizationSystem.rtLocalize("nhap_ma_xac_nhan", comment: "")}
    static var nhap_mat_khau_tam_thoi: String { return RTLocalizationSystem.rtLocalize("nhap_mat_khau_tam_thoi", comment: "")}
    static var gui_mat_khau_tam_thoi_thanh_cong: String { return RTLocalizationSystem.rtLocalize("gui_mat_khau_tam_thoi_thanh_cong", comment: "")}
    static var gui_lai_ma: String { return RTLocalizationSystem.rtLocalize("gui_lai_ma", comment: "")}
    static var gui_lai_mat_khau_tam_thoi: String { return RTLocalizationSystem.rtLocalize("gui_lai_mat_khau_tam_thoi", comment: "")}
    static var lien_ket_tai_khoan: String { return RTLocalizationSystem.rtLocalize("lien_ket_tai_khoan", comment: "")}
    static var ma_xac_thuc: String { return RTLocalizationSystem.rtLocalize("ma_xac_thuc", comment: "")}
    static var nhap_ma_xac_thuc_da_duoc_gui_toi_so: String { return RTLocalizationSystem.rtLocalize("nhap_ma_xac_thuc_da_duoc_gui_toi_so", comment: "")}
    static var dang_nhap: String { return RTLocalizationSystem.rtLocalize("dang_nhap", comment: "")}
    static var hoac: String { return RTLocalizationSystem.rtLocalize("hoac", comment: "")}
    static var tu_dong_dang_nhap_bang_3G_4G: String { return RTLocalizationSystem.rtLocalize("tu_dong_dang_nhap_bang_3G_4G", comment: "")}
    static var lay_mat_khau_mac_dinh: String { return RTLocalizationSystem.rtLocalize("lay_mat_khau_mac_dinh", comment: "")}
    static var dang_nhap_bang_SMS: String { return RTLocalizationSystem.rtLocalize("dang_nhap_bang_SMS", comment: "")}
    static var dang_ky_moi: String { return RTLocalizationSystem.rtLocalize("dang_ky_moi", comment: "")}
    static var da_gui_lai_ma: String { return RTLocalizationSystem.rtLocalize("da_gui_lai_ma", comment: "")}
    static var dang_nhap_bang_facebook: String { return RTLocalizationSystem.rtLocalize("dang_nhap_bang_facebook", comment: "")}
    static var mat_khau: String { return RTLocalizationSystem.rtLocalize("mat_khau", comment: "")}
    static var ma_xac_nhan: String { return RTLocalizationSystem.rtLocalize("ma_xac_nhan", comment: "")}
    static var tiep_tuc: String { return RTLocalizationSystem.rtLocalize("tiep_tuc", comment: "")}
    static var nhap_mat_khau: String { return RTLocalizationSystem.rtLocalize("nhap_mat_khau", comment: "")}
    static var nhap_mat_khau_cu: String { return RTLocalizationSystem.rtLocalize("nhap_mat_khau_cu", comment: "")}
    static var nhap_mat_khau_moi: String { return RTLocalizationSystem.rtLocalize("nhap_mat_khau_moi", comment: "")}
    static var xac_nhan_mat_khau_moi: String { return RTLocalizationSystem.rtLocalize("xac_nhan_mat_khau_moi", comment: "")}
    static var nhap_ma_captcha: String { return RTLocalizationSystem.rtLocalize("nhap_ma_captcha", comment: "")}
    static var nhap_lai_mat_khau: String { return RTLocalizationSystem.rtLocalize("nhap_lai_mat_khau", comment: "")}
    static var nhap_ma_xac_thuc: String { return RTLocalizationSystem.rtLocalize("nhap_ma_xac_thuc", comment: "")}
    static var quen_mat_khau: String { return RTLocalizationSystem.rtLocalize("quen_mat_khau", comment: "")}
    static var thong_tin: String { return RTLocalizationSystem.rtLocalize("thong_tin", comment: "")}
    static var chua_lien_ket: String { return RTLocalizationSystem.rtLocalize("chua_lien_ket", comment: "")}
    static var chua_dang_ky: String { return RTLocalizationSystem.rtLocalize("chua_dang_ky", comment: "")}
    static var huy: String { return RTLocalizationSystem.rtLocalize("huy", comment: "")}
    static var chinh_sua: String { return RTLocalizationSystem.rtLocalize("chinh_sua", comment: "")}
    static var ho_ten: String { return RTLocalizationSystem.rtLocalize("ho_ten", comment: "")}
    static var lien_ket: String { return RTLocalizationSystem.rtLocalize("lien_ket", comment: "")}
    static var xac_nhan_chinh_sua: String { return RTLocalizationSystem.rtLocalize("xac_nhan_chinh_sua", comment: "")}
    static var vui_long_nhap_mat_khau_de_bat_dau_chinh_sua_thong_tin_Tai_khoan: String { return RTLocalizationSystem.rtLocalize("vui_long_nhap_mat_khau_de_bat_dau_chinh_sua_thong_tin_Tai_khoan", comment: "")}
    static var kiem_soat_cua_phu_huynh: String { return RTLocalizationSystem.rtLocalize("kiem_soat_cua_phu_huynh", comment: "")}
    static var ma_PIN_dang_tat: String { return RTLocalizationSystem.rtLocalize("ma_PIN_dang_tat", comment: "")}
    static var cho_phep_xem_tat_ca_noi_dung_ma_khong_can_den_ma_PIN: String { return RTLocalizationSystem.rtLocalize("cho_phep_xem_tat_ca_noi_dung_ma_khong_can_den_ma_PIN", comment: "")}
    static var ma_PIN_dang_bat_nNoi_dung_Nguoi_lon_tro_len_duoc_bao_ve_boi_ma_PIN: String { return RTLocalizationSystem.rtLocalize("ma_PIN_dang_bat_nNoi_dung_Nguoi_lon_tro_len_duoc_bao_ve_boi_ma_PIN", comment: "")}
    static var ma_PIN_dang_bat_nNoi_dung_Thieu_nien_tro_len_duoc_bao_ve_boi_ma_PIN: String { return RTLocalizationSystem.rtLocalize("ma_PIN_dang_bat_nNoi_dung_Thieu_nien_tro_len_duoc_bao_ve_boi_ma_PIN", comment: "")}
    static var ma_PIN_dang_bat_nNoi_dung_Teens_tro_len_duoc_bao_ve_boi_ma_PIN: String { return RTLocalizationSystem.rtLocalize("ma_PIN_dang_bat_nNoi_dung_Teens_tro_len_duoc_bao_ve_boi_ma_PIN", comment: "")}
    static var ma_PIN_dang_bat_nTat_ca_noi_dung_deu_duoc_cho_phep: String { return RTLocalizationSystem.rtLocalize("ma_PIN_dang_bat_nTat_ca_noi_dung_deu_duoc_cho_phep", comment: "")}
    
    static var ban_co_the_kiem_soat: String { return RTLocalizationSystem.rtLocalize("ban_co_the_kiem_soat", comment: "")}
    static var yeu_cau_nhap_ma_pin_4_so: String { return RTLocalizationSystem.rtLocalize("yeu_cau_nhap_ma_pin_4_so", comment: "")}
    static var thiet_lap_ma_pin: String { return RTLocalizationSystem.rtLocalize("thiet_lap_ma_pin", comment: "")}
    static var cap_do_kiem_soat_noi_dung: String { return RTLocalizationSystem.rtLocalize("cap_do_kiem_soat_noi_dung", comment: "")}
    static var noi_dung_Nguoi_lon_tro_len_duoc_bao_ve_boi_ma_PIN: String { return RTLocalizationSystem.rtLocalize("noi_dung_Nguoi_lon_tro_len_duoc_bao_ve_boi_ma_PIN", comment: "")}
    static var tre_em: String { return RTLocalizationSystem.rtLocalize("tre_em", comment: "")}
    static var thieu_nien: String { return RTLocalizationSystem.rtLocalize("thieu_nien", comment: "")}
    static var thieu_nien_sub: String { return RTLocalizationSystem.rtLocalize("thieu_nien_sub", comment: "")}
    static var teens: String { return RTLocalizationSystem.rtLocalize("teens", comment: "")}
    static var nguoi_lon: String { return RTLocalizationSystem.rtLocalize("nguoi_lon", comment: "")}
    static var nguoi_lon_sub: String { return RTLocalizationSystem.rtLocalize("nguoi_lon_sub", comment: "")}
    static var luu: String { return RTLocalizationSystem.rtLocalize("luu", comment: "")}
    static var nhap_ma_pin_hien_tai: String { return RTLocalizationSystem.rtLocalize("nhap_ma_pin_hien_tai", comment: "")}
    static var ma_pin_khong_dung: String { return RTLocalizationSystem.rtLocalize("ma_pin_khong_dung", comment: "")}
    static var chat_luong_phim: String { return RTLocalizationSystem.rtLocalize("chat_luong_phim", comment: "")}
    static var chi_tai_bang_wifi: String { return RTLocalizationSystem.rtLocalize("chi_tai_bang_wifi", comment: "")}
    static var phim_chat_luong_cao_se_su_dung_nhieu_data_hon: String { return RTLocalizationSystem.rtLocalize("phim_chat_luong_cao_se_su_dung_nhieu_data_hon", comment: "")}
    static var bat_dau: String { return RTLocalizationSystem.rtLocalize("bat_dau", comment: "")}
    static var tiep_theo: String { return RTLocalizationSystem.rtLocalize("tiep_theo", comment: "")}
    static var xin_chao: String { return RTLocalizationSystem.rtLocalize("xin_chao", comment: "")}
    static var cap_nhat_phim_moi_moi_ngay: String { return RTLocalizationSystem.rtLocalize("cap_nhat_phim_moi_moi_ngay", comment: "")}
    static var cac_bo_phim_xuat_sac_tu_Hollywood_chau_A_va_hon_nua: String { return RTLocalizationSystem.rtLocalize("cac_bo_phim_xuat_sac_tu_Hollywood_chau_A_va_hon_nua", comment: "")}
    static var xem_tren_thiet_bi_yeu_thich: String { return RTLocalizationSystem.rtLocalize("xem_tren_thiet_bi_yeu_thich", comment: "")}
    static var dmax_ho_tro_tat_ca_cac_dong_may_Andorid_iOS_va_Smart_TV: String { return RTLocalizationSystem.rtLocalize("5Dmax_ho_tro_tat_ca_cac_dong_may_Andorid_iOS_va_Smart_TV", comment: "")}
    static var tang_kem_goi_Data_cuc_khung: String { return RTLocalizationSystem.rtLocalize("tang_kem_goi_Data_cuc_khung", comment: "")}
    static var voi_dung_luong_len_toi_30GB_cho_phep_ban_xem_phim_moi_luc_moi_noi: String { return RTLocalizationSystem.rtLocalize("voi_dung_luong_len_toi_30GB_cho_phep_ban_xem_phim_moi_luc_moi_noi", comment: "")}
    static var mien_phi_n_hoan_toan_Data_3G_4G_n_toc_do_cao: String { return RTLocalizationSystem.rtLocalize("mien_phi_n_hoan_toan_Data_3G_4G_n_toc_do_cao", comment: "")}
    static var khong_bo_lo_n_phim_chau_A_an_khach_voi_n_hang_ty_luot_xem: String { return RTLocalizationSystem.rtLocalize("khong_bo_lo_n_phim_chau_A_an_khach_voi_n_hang_ty_luot_xem", comment: "")}
    static var hang_ngan_gio_phim_n_dac_sac_tu_FOX_WBros_n_Universal_MBC_TVB: String { return RTLocalizationSystem.rtLocalize("hang_ngan_gio_phim_n_dac_sac_tu_FOX_WBros_n_Universal_MBC_TVB", comment: "")}
    static var danh_gia_ung_dung: String { return RTLocalizationSystem.rtLocalize("danh_gia_ung_dung", comment: "")}
    static var ban_co_muon_danh_gia_ung_dung: String { return RTLocalizationSystem.rtLocalize("ban_co_muon_danh_gia_ung_dung", comment: "")}
    static var goi_cuoc_dang_su_dung: String { return RTLocalizationSystem.rtLocalize("goi_cuoc_dang_su_dung", comment: "")}
    static var goi_cuoc_vip_khong_gioi_han: String { return RTLocalizationSystem.rtLocalize("goi_cuoc_vip_khong_gioi_han", comment: "")}
    static var mien_phi_luu_luong_3G_4G: String { return RTLocalizationSystem.rtLocalize("mien_phi_luu_luong_3G_4G", comment: "")}
    static var quyen_rieng_tu: String { return RTLocalizationSystem.rtLocalize("quyen_rieng_tu", comment: "")}
    static var huy_goi_cuoc: String { return RTLocalizationSystem.rtLocalize("huy_goi_cuoc", comment: "")}
    static var danh_sach_goi_cuoc: String { return RTLocalizationSystem.rtLocalize("danh_sach_goi_cuoc", comment: "")}
    static var luu_y: String { return RTLocalizationSystem.rtLocalize("luu_y", comment: "")}
    static var luu_luong_data_duoc_cong_them: String { return RTLocalizationSystem.rtLocalize("luu_luong_data_duoc_cong_them", comment: "")}
    static var phat_trailer: String { return RTLocalizationSystem.rtLocalize("phat_trailer", comment: "")}
    static var noi_bat: String { return RTLocalizationSystem.rtLocalize("noi_bat", comment: "")}
    static var danh_muc: String { return RTLocalizationSystem.rtLocalize("danh_muc", comment: "")}
    static var xu_huong: String { return RTLocalizationSystem.rtLocalize("xu_huong", comment: "")}
    static var nhap_ten_phim_dien_vien: String { return RTLocalizationSystem.rtLocalize("nhap_ten_phim_dien_vien", comment: "")}
    static var tim_kiem: String { return RTLocalizationSystem.rtLocalize("tim_kiem", comment: "")}
    static var khong_tim_thay_ket_qua: String { return RTLocalizationSystem.rtLocalize("khong_tim_thay_ket_qua", comment: "")}
    static var khong_tim_thay_ket_qua_cho_tu_khoa: String { return RTLocalizationSystem.rtLocalize("khong_tim_thay_ket_qua_cho_tu_khoa", comment: "")}
    static var goi_y_ket_qua: String { return RTLocalizationSystem.rtLocalize("goi_y_ket_qua", comment: "")}
    static var vui_long_cho_phep_quyen_su_dung_MicroPhone_de_tiep_tuc: String { return RTLocalizationSystem.rtLocalize("vui_long_cho_phep_quyen_su_dung_MicroPhone_de_tiep_tuc", comment: "")}
    static var yeu_cau_khoi_dong_lai_app: String { return RTLocalizationSystem.rtLocalize("yeu_cau_khoi_dong_lai_app", comment: "")}
    static var ngon_ngu: String { return RTLocalizationSystem.rtLocalize("ngon_ngu", comment: "")}
    static var chon_ngon_ngu: String { return RTLocalizationSystem.rtLocalize("chon_ngon_ngu", comment: "")}
    static var tieng_anh: String { return RTLocalizationSystem.rtLocalize("tieng_anh", comment: "")}
    static var tieng_viet: String { return RTLocalizationSystem.rtLocalize("tieng_viet", comment: "")}
    static var price: String { return RTLocalizationSystem.rtLocalize("price", comment: "")}
    static var mua: String { return RTLocalizationSystem.rtLocalize("mua", comment: "")}
    static var nam_san_xuat: String { return RTLocalizationSystem.rtLocalize("nam_san_xuat", comment: "")}
    static var tieng_tay_ban_nha: String { return RTLocalizationSystem.rtLocalize("tieng_tay_ban_nha", comment: "")}
    static var chuyen_ve_man_hinh_chi_tiet_film: String { return RTLocalizationSystem.rtLocalize("chuyen_ve_man_hinh_chi_tiet_film", comment: "")}
    static var yeu_cau_doi_mat_khau: String { return RTLocalizationSystem.rtLocalize("yeu_cau_doi_mat_khau", comment: "")}
    static var user_moi: String { return RTLocalizationSystem.rtLocalize("user_moi", comment: "")}
    static var OK_base: String { return RTLocalizationSystem.rtLocalize("OK_base", comment: "")}
    static var share_1: String { return RTLocalizationSystem.rtLocalize("share_1", comment: "")}
    static var share_2: String { return RTLocalizationSystem.rtLocalize("share_2", comment: "")}
    static var first_month_free: String { return RTLocalizationSystem.rtLocalize("first_month_free", comment: "")}
    
    static var country: String { return RTLocalizationSystem.rtLocalize("country", comment: "")}
    static var directors: String { return RTLocalizationSystem.rtLocalize("directors", comment: "")}
    static var previous : String { return RTLocalizationSystem.rtLocalize("previous", comment: "")}
}
