// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:kods/common/widgets/notification_bell.dart';
// import 'package:provider/provider.dart';
// import 'package:kods/utils/theme.dart';
// import 'package:kods/book_services/modules/electrician/model/electrician_model.dart';
// import 'package:kods/book_services/modules/electrician/provider/electrical_provider.dart';

// class ElectricalListScreen extends StatefulWidget {
//   const ElectricalListScreen({super.key});

//   @override
//   State<ElectricalListScreen> createState() => _ElectricalListScreenState();
// }

// class _ElectricalListScreenState extends State<ElectricalListScreen> {
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       context.read<ElectricalProvider>().loadElectricalShops();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);

//     return Scaffold(
//       backgroundColor: theme.colorScheme.background,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back, color: theme.textTheme.bodyLarge?.color),
//           onPressed: () => context.pop(),
//         ),
//         title: Text(
//           'Electrical',
//           style: TextStyle(
//             color: theme.textTheme.bodyLarge?.color,
//             fontSize: 18,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//         centerTitle: true,
//         actions: [NotificationBell(onTap: () {})],
//       ),
//       body: Consumer<ElectricalProvider>(
//         builder: (context, provider, child) {
//           if (provider.isLoading) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           if (provider.error != null) {
//             return Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     provider.error!,
//                     style: TextStyle(color: Colors.red),
//                     textAlign: TextAlign.center,
//                   ),
//                   const SizedBox(height: 16),
//                   ElevatedButton(
//                     onPressed: () {
//                       provider.clearError();
//                       provider.loadElectricalShops();
//                     },
//                     child: const Text('Retry'),
//                   ),
//                 ],
//               ),
//             );
//           }

//           if (provider.shops.isEmpty) {
//             return const Center(child: Text('No electrical shops found'));
//           }

//           return Padding(
//             padding: const EdgeInsets.all(16),
//             child: ListView.separated(
//               itemCount: provider.shops.length,
//               separatorBuilder: (context, index) => const SizedBox(height: 16),
//               itemBuilder: (context, index) {
//                 final shop = provider.shops[index];
//                 return _buildElectricalCard(context, shop);
//               },
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildElectricalCard(BuildContext context, ElectricalShop shop) {
//     return GestureDetector(
//       onTap: () {
//         context.push('/electricservice', extra: shop);
//       },
//       child: Container(
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(12),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.withOpacity(0.1),
//               spreadRadius: 1,
//               blurRadius: 4,
//               offset: const Offset(0, 2),
//             ),
//           ],
//         ),
//         child: Row(
//           children: [
//             Container(
//               width: 80,
//               height: 80,
//               decoration: BoxDecoration(
//                 color: AppTheme.secondaryColor,
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(8),
//                 child: Image.asset(
//                   shop.imageUrl,
//                   fit: BoxFit.cover,
//                   errorBuilder: (context, error, stackTrace) {
//                     return Icon(
//                       Icons.electrical_services,
//                       size: 40,
//                       color: Colors.grey[600],
//                     );
//                   },
//                 ),
//               ),
//             ),
//             const SizedBox(width: 16),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     shop.name,
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.w600,
//                       color: AppTheme.primaryColor,
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   Text(
//                     shop.details,
//                     style: TextStyle(
//                       fontSize: 12,
//                       color: Colors.grey[600],
//                       height: 1.3,
//                     ),
//                     maxLines: 2,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     'Timings: ${shop.timings}',
//                     style: TextStyle(fontSize: 11, color: Colors.grey[600]),
//                   ),
//                   const SizedBox(height: 8),
//                   Row(
//                     children: [
//                       Icon(
//                         Icons.location_on,
//                         size: 14,
//                         color: Colors.grey[600],
//                       ),
//                       const SizedBox(width: 4),
//                       Text(
//                         shop.location,
//                         style: TextStyle(fontSize: 12, color: Colors.grey[600]),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
