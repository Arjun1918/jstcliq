import 'package:flutter/material.dart';
import 'package:kods/menu_drawer/order_status/model/order_status.dart';
import 'package:kods/menu_drawer/order_status/repo/order_status_repo.dart';

class OrderStatusProvider extends ChangeNotifier {
  OrderStatus? _currentOrder;
  bool _isLoading = false;
  String? _error;

  OrderStatus? get currentOrder => _currentOrder;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadOrderStatus(String orderId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await Future.delayed(const Duration(seconds: 1));
      
      _currentOrder = DummyOrderData.getSampleOrder();
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = "Failed to load order status: ${e.toString()}";
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshOrderStatus() async {
    if (_currentOrder == null) return;
    
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      
      _currentOrder = DummyOrderData.getSampleOrder();
      notifyListeners();
    } catch (e) {
      _error = "Failed to refresh order status";
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  Future<void> cancelOrder(String reason) async {
    if (_currentOrder == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      await Future.delayed(const Duration(seconds: 1));
            _currentOrder = OrderStatus(
        id: _currentOrder!.id,
        bookingId: _currentOrder!.bookingId,
        status: OrderStatusType.cancelled,
        serviceName: _currentOrder!.serviceName,
        customerName: _currentOrder!.customerName,
        customerAddress: _currentOrder!.customerAddress,
        scheduledDate: _currentOrder!.scheduledDate,
        scheduledTime: _currentOrder!.scheduledTime,
        assignedElectrician: _currentOrder!.assignedElectrician,
        estimatedArrival: _currentOrder!.estimatedArrival,
        workDescription: _currentOrder!.workDescription,
        statusUpdates: [
          ..._currentOrder!.statusUpdates,
          StatusUpdate(
            id: "SU_CANCEL",
            message: "Order cancelled by customer. Reason: $reason",
            timestamp: DateTime.now(),
            status: OrderStatusType.cancelled,
          ),
        ],
        totalAmount: _currentOrder!.totalAmount,
        paymentStatus: _currentOrder!.paymentStatus,
      );
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = "Failed to cancel order";
      _isLoading = false;
      notifyListeners();
    }
  }
}