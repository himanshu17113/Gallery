class PixabayImage {
  final String webformatURL;
  final String previewURL;
  final int likes;
  final String largeImageURL;
  final int views;
  final int imageWidth;
  final int imageHeight;

  PixabayImage({
    required this.webformatURL,
    required this.previewURL,
    required this.likes,
    required this.largeImageURL,
    required this.views,
    required this.imageWidth,
    required this.imageHeight,
  });

  factory PixabayImage.fromMap(Map<String, dynamic> map) {
    return PixabayImage(
      webformatURL: map['webformatURL'],
      previewURL: map['previewURL'],
      likes: map['likes'],
      largeImageURL: map['largeImageURL'],
      views: map['views'],
      imageWidth: map['imageWidth'],
      imageHeight: map['imageHeight'],
    );
  }
}
