import 'package:e_commerce/core/extensions/extensions.dart';
import 'package:e_commerce/core/theme/app_colors.dart';
import 'package:e_commerce/core/widgets/common_widget/custom_app_bar.dart';
import 'package:e_commerce/core/widgets/stateful/custom_button.dart';
import 'package:e_commerce/features/address/presentation/widgets/address_card_tile.dart';
import 'package:e_commerce/features/address/presentation/widgets/address_form_bottom_sheet.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class AddressScreen extends StatefulWidget {
  const AddressScreen({super.key});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  final List<_AddressItem> _addresses = [
    _AddressItem(
      id: '1',
      label: 'homeAddressLabel',
      fullAddress: '123 Main St, New York, NY 10001',
      phone: '+1 234-567-8900',
      isDefault: true,
      lat: 40.7128,
      lng: -74.0060,
      currentAddress: '123 Main St, New York, NY 10001',
    ),
    _AddressItem(
      id: '2',
      label: 'workAddressLabel',
      fullAddress: '456 Office Blvd, New York, NY 10002',
      phone: '+1 234-567-8901',
      isDefault: false,
      lat: 40.7152,
      lng: -73.9961,
      currentAddress: '456 Office Blvd, New York, NY 10002',
    ),
  ];

  String _displayAddressLabel(String rawLabel) {
    const translatableKeys = {'homeAddressLabel', 'workAddressLabel'};
    if (translatableKeys.contains(rawLabel)) {
      return rawLabel.tr();
    }
    return rawLabel;
  }

  Future<void> _openAddressSheet({_AddressItem? item}) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return AddressFormBottomSheet(
          initialData: item == null
              ? null
              : AddressFormData(
                  label: item.label,
                  fullAddress: item.fullAddress,
                  phone: item.phone,
                  isDefault: item.isDefault,
                  lat: item.lat,
                  lng: item.lng,
                  currentAddress: item.currentAddress,
                ),
          onSave: (data) {
            setState(() {
              if (item == null) {
                final newItem = _AddressItem(
                  id: DateTime.now().microsecondsSinceEpoch.toString(),
                  label: data.label,
                  fullAddress: data.fullAddress,
                  phone: data.phone,
                  isDefault: data.isDefault,
                  lat: data.lat,
                  lng: data.lng,
                  currentAddress: data.currentAddress,
                );

                if (newItem.isDefault) {
                  for (final a in _addresses) {
                    a.isDefault = false;
                  }
                }

                _addresses.add(newItem);
              } else {
                if (data.isDefault) {
                  for (final a in _addresses) {
                    a.isDefault = false;
                  }
                }

                item
                  ..label = data.label
                  ..fullAddress = data.fullAddress
                  ..phone = data.phone
                  ..isDefault = data.isDefault
                  ..lat = data.lat
                  ..lng = data.lng
                  ..currentAddress = data.currentAddress;
              }

              if (_addresses.isNotEmpty &&
                  !_addresses.any((address) => address.isDefault)) {
                _addresses.first.isDefault = true;
              }
            });
          },
        );
      },
    );
  }

  void _deleteAddress(_AddressItem item) {
    setState(() {
      final wasDefault = item.isDefault;
      _addresses.removeWhere((e) => e.id == item.id);

      if (wasDefault && _addresses.isNotEmpty) {
        _addresses.first.isDefault = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final dark = context.isDarkMode;

    return Scaffold(
      backgroundColor: dark ? const Color(0xFF111827) : const Color(0xFFF3F5F9),
      appBar: CustomAppBar(
        title: 'myAddresses',
        showBackButton: true,
        backgroundColor: dark ? const Color(0xFF111827) : AppColors.whiteColor,
      ),
      body: Column(
        children: [
          Divider(
              height: 1,
              color: dark ? Colors.white12 : const Color(0xFFE8ECF3)),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(14),
              itemBuilder: (_, index) {
                final item = _addresses[index];
                return AddressCardTile(
                  label: _displayAddressLabel(item.label),
                  address: item.fullAddress,
                  phone: item.phone,
                  isDefault: item.isDefault,
                  onEdit: () => _openAddressSheet(item: item),
                  onDelete: () => _deleteAddress(item),
                );
              },
              separatorBuilder: (_, __) => const Gap(12),
              itemCount: _addresses.length,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
            child: CustomButton(
              title: 'addNewAddress',
              onPressed: () => _openAddressSheet(),
              borderRadius: 16,
              padding: const EdgeInsets.symmetric(vertical: 16),
              gradient: const LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Color(0xFF4653DE), Color(0xFF2E63F6)],
              ),
              icon: const Icon(Icons.add, color: AppColors.whiteColor),
              isIcon: true,
              textColor: AppColors.whiteColor,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _AddressItem {
  final String id;
  String label;
  String fullAddress;
  String phone;
  bool isDefault;
  double? lat;
  double? lng;
  String currentAddress;

  _AddressItem({
    required this.id,
    required this.label,
    required this.fullAddress,
    required this.phone,
    required this.isDefault,
    required this.lat,
    required this.lng,
    required this.currentAddress,
  });
}
