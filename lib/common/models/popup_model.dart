class PopupModel {
	int? id;
	String? title;
	String? image;
	int? productId;
	int? status;
	int? categoryId;
	DateTime? createdAt;
	DateTime? updatedAt;

	PopupModel({
		this.id, 
		this.title, 
		this.image, 
		this.productId, 
		this.status, 
		this.categoryId, 
		this.createdAt, 
		this.updatedAt, 
	});

	factory PopupModel.fromJson(Map<String, dynamic> json) => PopupModel(
				id: json['id'] as int?,
				title: json['title'] as String?,
				image: json['image'] as String?,
				productId: json['product_id'] as int?,
				status: json['status'] as int?,
				categoryId: json['category_id'] as int?,
				createdAt: json['created_at'] == null
						? null
						: DateTime.parse(json['created_at'] as String),
				updatedAt: json['updated_at'] == null
						? null
						: DateTime.parse(json['updated_at'] as String),
			);

	Map<String, dynamic> toJson() => {
				'id': id,
				'title': title,
				'image': image,
				'product_id': productId,
				'status': status,
				'category_id': categoryId,
				'created_at': createdAt?.toIso8601String(),
				'updated_at': updatedAt?.toIso8601String(),
			};
}
