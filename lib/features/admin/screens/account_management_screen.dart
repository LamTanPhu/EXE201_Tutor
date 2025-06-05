import 'package:flutter/material.dart';
import 'package:tutor/common/models/account.dart';
import 'package:tutor/common/widgets/list_view_widget.dart';
import 'package:tutor/routes/app_routes.dart';

class AccountManagementScreen extends StatelessWidget {
  const AccountManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    //fake data
    final List<Account> accounts = [
      Account(
        id: '1',
        fullName: 'Nguyen Van A',
        avatar: null,
        email: 'a@example.com',
        phone: '0123456789',
        status: 'active',
        role: 'tutor',
        balance: 500000,
      ),
      Account(
        id: '2',
        fullName: 'Tran Thi B',
        avatar: null,
        email: 'b@example.com',
        phone: '0987654321',
        status: 'inactive',
        role: 'student',
        balance: 200000,
      ),
      Account(
        id: '3',
        fullName: 'Le Van C',
        avatar: null,
        email: 'c@example.com',
        phone: '0909090909',
        status: 'active',
        role: 'admin',
        balance: 1000000,
      ),
    ];

    //lấy những account không phải admin
    final filteredAccounts = accounts.where((account) => account.role != 'admin').toList();

    return Scaffold(
      appBar: AppBar(title: const Text('List of Accounts')),
      body: ListViewWidget<Account>(
        items: filteredAccounts,
        itemBuilder: (account) {
          return ListTile(
            //nếu như có avatar thì sẽ được hiển thị
            //nếu không sẽ hiển thị hình mặc định
            leading:
                account.avatar != null
                    ? CircleAvatar(
                      backgroundImage: NetworkImage(account.avatar!),
                    )
                    : const CircleAvatar(child: Icon(Icons.person)),
            title: Text(account.fullName ?? "N/A"),
            //hiển thị email và role
            subtitle: Text('${account.email} - ${account.role}'),
            //hiẻn thị status
            trailing: Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: account.status == 'active' ? Colors.green : Colors.red,
              ),
            ),
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.accountDetail);
            },
          );
        },
      ),
    );
  }
}
