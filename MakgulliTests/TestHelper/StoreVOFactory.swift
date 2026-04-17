import Foundation
@testable import Makgulli

enum StoreVOFactory {
    static func make(
        placeName: String = "테스트 막걸리집",
        distance: String = "100",
        placeURL: String = "https://example.com",
        categoryName: String = "막걸리",
        addressName: String = "서울시 종로구",
        roadAddressName: String = "종로1길 10",
        id: String = "store-001",
        phone: String? = "02-1234-5678",
        x: Double = 126.97,
        y: Double = 37.57,
        categoryType: CategoryType = .makgulli,
        rate: Int = 0,
        bookmark: Bool = false,
        bookmarkDate: Date? = nil,
        episode: [EpisodeVO] = []
    ) -> StoreVO {
        StoreVO(
            placeName: placeName,
            distance: distance,
            placeURL: placeURL,
            categoryName: categoryName,
            addressName: addressName,
            roadAddressName: roadAddressName,
            id: id,
            phone: phone,
            x: x,
            y: y,
            categoryType: categoryType,
            rate: rate,
            bookmark: bookmark,
            bookmarkDate: bookmarkDate,
            episode: episode
        )
    }
}

enum EpisodeVOFactory {
    static func make(
        id: String = "ep-001",
        date: Date = Date(),
        comment: String = "맛있었다",
        imageURL: String = "ep-001.jpg",
        alcohol: String = "막걸리",
        drink: Double = 1.0,
        drinkQuantity: QuantityType = .bottle
    ) -> EpisodeVO {
        EpisodeVO(
            id: id,
            date: date,
            comment: comment,
            imageURL: imageURL,
            alcohol: alcohol,
            drink: drink,
            drinkQuantity: drinkQuantity
        )
    }
}
