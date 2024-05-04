// // ignore_for_file: cascade_invocations

 
// import '../repository/pixabay_repository.dart';

// class SearchResultService {
//   final PixabayRepository _pixabayRepository = PixabayRepository();

//   ///
//   Future<SearchResultResponseState> getSearchResultList(String q, int page) async {
//     // pixabayリポジトリのパラメータ生成
//     final pixabayApiRequest = _pixabayRepository.pixabayApiInitialRequest;

//     pixabayApiRequest.q = q;
//     pixabayApiRequest.page = page.toString();

//     // pixabayリポジトリのAPI実行
//     final pixabayApiResponse = await _pixabayRepository.getPixabay(pixabayApiRequest);

//     // pixabayリポジトリからSearchResultリストに変換
//     final searchResultList = transformPixabayApiResponseIntoSearchResult(pixabayApiResponse);

//     return searchResultList;
//   }

//   ///
//   SearchResultResponseState transformPixabayApiResponseIntoSearchResult(PixabayApiResponse pixabayApiResponse) {
//     final imageList = <ImageList>[];

//     for (final hit in pixabayApiResponse.hits) {
//       final image = ImageList(imageUrl: hit.webformatURL, views: hit.views, likes: hit.likes);

//       imageList.add(image);
//     }

//     return SearchResultResponseState(imageList, pixabayApiResponse.total);
//   }
// }
