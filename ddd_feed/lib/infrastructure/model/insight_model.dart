class InsightModel {
  final String? plotImage;

  InsightModel({this.plotImage});

  factory InsightModel.fromJson(Map<String, dynamic> json) => InsightModel(plotImage: json["plot_image"] ?? '');

  Map<String, dynamic> toJson() => {"plot_image": plotImage};
}
