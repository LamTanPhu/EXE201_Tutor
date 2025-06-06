import 'package:flutter/material.dart';

class ListViewWidget<T> extends StatelessWidget {
  //list và hàm xử lý
  final List<T> items;
  final Widget Function(T) itemBuilder;
  const ListViewWidget({
    Key? key,
    required this.items,
    required this.itemBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      // Số lượng item trong danh sách
      itemCount: items.length,
      // Hàm builder để xây dựng từng item
      itemBuilder: (context, index) {
        // Gọi hàm itemBuilder để tạo widget cho item tại một vị trí index
        return itemBuilder(items[index]);
      },
    );
  }
}
