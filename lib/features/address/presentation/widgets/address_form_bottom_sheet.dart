import 'package:e_commerce/core/extensions/extensions.dart';
import 'package:e_commerce/core/helpers/validators.dart';
import 'package:e_commerce/core/theme/app_colors.dart';
import 'package:e_commerce/core/theme/text_styles.dart';
import 'package:e_commerce/core/widgets/custom_phone_field.dart';
import 'package:e_commerce/core/widgets/custom_text_field.dart';
import 'package:e_commerce/core/widgets/stateful/custom_button.dart';
import 'package:e_commerce/features/address/presentation/widgets/address_map_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class AddressFormData {
  final String label;
  final String fullAddress;
  final String phone;
  final bool isDefault;
  final double? lat;
  final double? lng;
  final String currentAddress;

  const AddressFormData({
    required this.label,
    required this.fullAddress,
    required this.phone,
    required this.isDefault,
    required this.lat,
    required this.lng,
    required this.currentAddress,
  });
}

class AddressFormBottomSheet extends StatefulWidget {
  final AddressFormData? initialData;
  final ValueChanged<AddressFormData> onSave;

  const AddressFormBottomSheet({
    super.key,
    this.initialData,
    required this.onSave,
  });

  @override
  State<AddressFormBottomSheet> createState() => _AddressFormBottomSheetState();
}

class _AddressFormBottomSheetState extends State<AddressFormBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _labelController;
  late final TextEditingController _addressController;
  late final TextEditingController _phoneController;

  bool _isDefault = false;
  AddressLocationSelection? _selectedLocation;

  @override
  void initState() {
    super.initState();
    _labelController = TextEditingController(text: widget.initialData?.label ?? '');
    _addressController = TextEditingController(text: widget.initialData?.fullAddress ?? '');
    _phoneController = TextEditingController(text: widget.initialData?.phone ?? '');
    _isDefault = widget.initialData?.isDefault ?? false;

    if (widget.initialData?.lat != null && widget.initialData?.lng != null) {
      _selectedLocation = AddressLocationSelection(
        lat: widget.initialData!.lat!,
        lng: widget.initialData!.lng!,
        currentAddress: widget.initialData?.currentAddress ?? '',
      );
    }
  }

  @override
  void dispose() {
    _labelController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _save() {
    if (_formKey.currentState?.validate() != true) return;

    widget.onSave(
      AddressFormData(
        label: _labelController.text.trim(),
        fullAddress: _addressController.text.trim(),
        phone: _phoneController.text.trim(),
        isDefault: _isDefault,
        lat: _selectedLocation?.lat,
        lng: _selectedLocation?.lng,
        currentAddress: _selectedLocation?.currentAddress ?? '',
      ),
    );

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final dark = context.isDarkMode;

    return Container(
      decoration: BoxDecoration(
        color: dark ? const Color(0xFF111827) : AppColors.whiteColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(26)),
      ),
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.initialData == null ? 'addNewAddress'.tr() : 'editAddress'.tr(),
                      style: TextStyles.blackBold32.copyWith(
                        fontSize: context.responsiveValue(mobile: 25.0, smallMobile: 18.0, tablet: 28.0),
                        color: dark ? Colors.white : AppColors.darkTextColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(Icons.close, color: dark ? Colors.white : AppColors.darkTextColor),
                  ),
                ],
              ),
              const Gap(8),
              Text(
                'addressLabel'.tr(),
                style: TextStyles.blackBold14.copyWith(
                  color: dark ? Colors.white : AppColors.darkTextColor,
                ),
              ),
              const Gap(6),
              Customtextfield(
                hintText: 'addressLabelHint',
                textEditingController: _labelController,
                validator: Validators.validateEmpty,
              ),
              const Gap(10),
              Text(
                'fullAddress'.tr(),
                style: TextStyles.blackBold14.copyWith(
                  color: dark ? Colors.white : AppColors.darkTextColor,
                ),
              ),
              const Gap(6),
              Customtextfield(
                hintText: 'fullAddressHint',
                textEditingController: _addressController,
                minLines: 2,
                maxLines: 5,
                validator: Validators.validateEmpty,
              ),
              const Gap(10),
              Text(
                'phoneNumber'.tr(),
                style: TextStyles.blackBold14.copyWith(
                  color: dark ? Colors.white : AppColors.darkTextColor,
                ),
              ),
              const Gap(6),
              CustomPhoneField(
                controller: _phoneController,
                onChanged: (phone) {
                  _phoneController.text = phone.completeNumber;
                },
              ),
              const Gap(10),
              AddressMapPicker(
                initialSelection: _selectedLocation,
                onLocationChanged: (selection) {
                  _selectedLocation = selection;
                  if (selection.currentAddress.trim().isNotEmpty &&
                      _addressController.text.trim().isEmpty) {
                    _addressController.text = selection.currentAddress;
                  }
                },
              ),
              const Gap(8),
              Row(
                children: [
                  Checkbox(
                    value: _isDefault,
                    onChanged: (v) {
                      setState(() {
                        _isDefault = v ?? false;
                      });
                    },
                  ),
                  Expanded(
                    child: Text(
                      'setDefaultAddress'.tr(),
                      style: TextStyles.blackRegular16.copyWith(
                        color: dark ? Colors.white : AppColors.darkTextColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const Gap(6),
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      title: 'cancel',
                      onPressed: () => Navigator.of(context).pop(),
                      borderRadius: 14,
                      borderColor: AppColors.greyColor3,
                      backgroundColor: dark ? const Color(0xFF21283B) : AppColors.whiteColor,
                      textColor: dark ? AppColors.whiteColor : AppColors.darkTextColor,
                    ),
                  ),
                  const Gap(10),
                  Expanded(
                    child: CustomButton(
                      title: widget.initialData == null ? 'saveAddress' : 'updateAddress',
                      onPressed: _save,
                      borderRadius: 14,
                      gradient: const LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [Color(0xFF4653DE), Color(0xFF2E63F6)],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
