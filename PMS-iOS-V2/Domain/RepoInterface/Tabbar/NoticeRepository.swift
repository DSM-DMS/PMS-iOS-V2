//
//  NoticeRepository.swift
//  PMS-iOS-V2
//
//  Created by GoEun Jeong on 2021/05/19.
//

import Foundation
import RxSwift
import Moya

public protocol NoticeRepository {
    func getNoticeList(page: Int) -> Single<NoticeList>
    func getDetailNotice(id: Int) -> Single<DetailNotice>
    func addComment(id: Int, body: String) -> Single<Bool>
    func searchNotice(search: String) -> Single<NoticeList>
    func getLetterList(page: Int) -> Single<NoticeList>
    func searchLetter(search: String) -> Single<NoticeList>
    func getAlbumList(page: Int) -> Single<AlbumList>
    func getDetailAlbum(id: Int) -> Single<DetailAlbum>
}
