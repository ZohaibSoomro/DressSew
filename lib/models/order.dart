class DresssewOrder {
  String? orderId;
  double totalAmount;
  double advanceDeposited;
  String customerId;
  String customerEmail;
  String tailorId;
  String deliveryDate;
  String category;
  OrderStatus status;
  DresssewOrder({
    this.orderId,
    required this.tailorId,
    required this.category,
    required this.advanceDeposited,
    required this.customerEmail,
    required this.customerId,
    required this.deliveryDate,
    required this.status,
    required this.totalAmount,
  });
  static DresssewOrder fromJson(Map<String, dynamic> json) {
    return DresssewOrder(
      orderId: json['orderId'],
      totalAmount: json['totalAmount'],
      advanceDeposited: json['advanceDeposited'],
      customerId: json['customerId'],
      customerEmail: json['customerEmail'],
      tailorId: json['tailorId'],
      deliveryDate: json['deliveryDate'],
      category: json['category'],
      status: getOrderStatus(json['status']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
      'totalAmount': totalAmount,
      'advanceDeposited': advanceDeposited,
      'customerId': customerId,
      'customerEmail': customerEmail,
      'tailorId': tailorId,
      'deliveryDate': deliveryDate,
      'category': category,
      'status': status.name,
    };
  }
}

OrderStatus getOrderStatus(String type) {
  OrderStatus orderStatus = type == OrderStatus.pending.name
      ? OrderStatus.pending
      : type == OrderStatus.started.name
          ? OrderStatus.started
          : type == OrderStatus.inProgress.name
              ? OrderStatus.inProgress
              : OrderStatus.completed;
  return orderStatus;
}

enum OrderStatus {
  pending,
  started,
  inProgress,
  completed,
}
