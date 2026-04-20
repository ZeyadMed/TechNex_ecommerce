import 'dart:async';
import 'dart:convert';

import 'package:e_commerce/core/extensions/extensions.dart';
import 'package:e_commerce/core/theme/app_colors.dart';
import 'package:e_commerce/core/theme/text_styles.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart' as latlng;

class AddressLocationSelection {
  final double lat;
  final double lng;
  final String currentAddress;

  const AddressLocationSelection({
    required this.lat,
    required this.lng,
    required this.currentAddress,
  });
}

class AddressMapPicker extends StatefulWidget {
  final AddressLocationSelection? initialSelection;
  final ValueChanged<AddressLocationSelection> onLocationChanged;

  const AddressMapPicker({
    super.key,
    this.initialSelection,
    required this.onLocationChanged,
  });

  @override
  State<AddressMapPicker> createState() => _AddressMapPickerState();
}

class _AddressMapPickerState extends State<AddressMapPicker> {
  static const latlng.LatLng _fallbackLatLng = latlng.LatLng(30.0444, 31.2357);

  late latlng.LatLng _selectedLatLng;
  late String _resolvedAddress;
  final List<_PlaceSuggestion> _recentSearches = [];

  @override
  void initState() {
    super.initState();
    _selectedLatLng = widget.initialSelection == null
        ? _fallbackLatLng
        : latlng.LatLng(
            widget.initialSelection!.lat,
            widget.initialSelection!.lng,
          );
    _resolvedAddress = widget.initialSelection?.currentAddress ?? '';
  }

  Future<String> _reverseGeocode(double lat, double lng) async {
    try {
      final places = await placemarkFromCoordinates(lat, lng);
      if (places.isEmpty) return '';
      final p = places.first;
      return [
        p.street,
        p.subLocality,
        p.locality,
        p.administrativeArea,
      ].where((e) => (e ?? '').trim().isNotEmpty).join(', ');
    } catch (_) {
      return '';
    }
  }

  Future<List<_PlaceSuggestion>> _searchPlaces(
    String query, {
    int limit = 6,
    bool egyptOnly = true,
  }) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return [];

    final uri = Uri.https(
      'nominatim.openstreetmap.org',
      '/search',
      {
        'q': trimmed,
        'format': 'jsonv2',
        'addressdetails': '1',
        'limit': '$limit',
        if (egyptOnly) 'countrycodes': 'eg',
      },
    );

    final response = await http.get(
      uri,
      headers: {
        'User-Agent': 'e_commerce/1.0',
      },
    );

    if (response.statusCode != 200) return [];

    final data = jsonDecode(response.body);
    if (data is! List) return [];

    final List<_PlaceSuggestion> result = [];
    for (final item in data) {
      if (item is! Map) continue;
      final displayName = (item['display_name'] ?? '').toString();
      final lat = double.tryParse((item['lat'] ?? '').toString());
      final lng = double.tryParse((item['lon'] ?? '').toString());
      if (displayName.isEmpty || lat == null || lng == null) continue;
      result.add(
        _PlaceSuggestion(
          displayName: displayName,
          lat: lat,
          lng: lng,
        ),
      );
    }

    return result;
  }

  List<_PlaceSuggestion> _pushRecent(
    List<_PlaceSuggestion> source,
    _PlaceSuggestion item,
  ) {
    final filtered = source
        .where(
          (e) =>
              !(e.lat == item.lat && e.lng == item.lng) &&
              e.displayName != item.displayName,
        )
        .toList();
    filtered.insert(0, item);
    if (filtered.length > 5) {
      return filtered.sublist(0, 5);
    }
    return filtered;
  }

  Future<void> _openMapPickerDialog() async {
    final parentContext = context;
    latlng.LatLng tempSelected = _selectedLatLng;
    String tempAddress = _resolvedAddress;
    final searchController = TextEditingController();
    final mapController = MapController();
    bool isSearching = false;
    bool isFetchingSuggestions = false;
    List<_PlaceSuggestion> suggestions = [];
    List<_PlaceSuggestion> recentSearches = List<_PlaceSuggestion>.from(
      _recentSearches,
    );
    Timer? debounce;
    bool routeActive = true;

    void safeSetModal(StateSetter setModalState, VoidCallback fn) {
      if (!mounted || !routeActive) return;
      setModalState(fn);
    }

    void showNotFoundMessage() {
      if (!mounted) return;
      final messenger = ScaffoldMessenger.maybeOf(parentContext);
      messenger?.showSnackBar(
        SnackBar(content: Text('locationSearchNotFound'.tr())),
      );
    }

    final result = await Navigator.of(context).push<AddressLocationSelection>(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) {
          final dark = context.isDarkMode;

          Future<void> searchForPlace(StateSetter setModalState) async {
            final query = searchController.text.trim();
            if (query.isEmpty) return;

            safeSetModal(setModalState, () {
              isSearching = true;
            });

            try {
              final places = await _searchPlaces(query, limit: 1);
              if (places.isEmpty) {
                showNotFoundMessage();
                return;
              }

              final first = places.first;
              final found = latlng.LatLng(first.lat, first.lng);

              safeSetModal(setModalState, () {
                tempSelected = found;
                tempAddress = first.displayName;
                suggestions = [];
                recentSearches = _pushRecent(recentSearches, first);
              });

              if (!mounted || !routeActive) return;
              mapController.move(found, 16);

              final resolved = await _reverseGeocode(
                first.lat,
                first.lng,
              );

              safeSetModal(setModalState, () {
                tempAddress = resolved.isEmpty ? query : resolved;
              });
            } catch (_) {
              showNotFoundMessage();
            } finally {
              safeSetModal(setModalState, () {
                isSearching = false;
              });
            }
          }

          Future<void> fetchSuggestions(
            String rawValue,
            StateSetter setModalState,
          ) async {
            final query = rawValue.trim();
            if (query.length < 2) {
              safeSetModal(setModalState, () {
                suggestions = [];
                isFetchingSuggestions = false;
              });
              return;
            }

            safeSetModal(setModalState, () {
              isFetchingSuggestions = true;
            });

            try {
              final result = await _searchPlaces(query, limit: 6);
              safeSetModal(setModalState, () {
                suggestions = result;
              });
            } catch (_) {
              safeSetModal(setModalState, () {
                suggestions = [];
              });
            } finally {
              safeSetModal(setModalState, () {
                isFetchingSuggestions = false;
              });
            }
          }

          return Scaffold(
            backgroundColor:
                dark ? const Color(0xFF111827) : AppColors.whiteColor,
            appBar: AppBar(
              backgroundColor:
                  dark ? const Color(0xFF111827) : AppColors.whiteColor,
              elevation: 0,
              surfaceTintColor: Colors.transparent,
              title: Text(
                'mapPickerTitle'.tr(),
                style: TextStyles.blackBold20.copyWith(
                  color: dark ? Colors.white : AppColors.darkTextColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
              iconTheme: IconThemeData(
                color: dark ? Colors.white : AppColors.darkTextColor,
              ),
            ),
            body: StatefulBuilder(
              builder: (context, setModalState) {
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 10, 12, 8),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: searchController,
                              onChanged: (value) {
                                debounce?.cancel();
                                debounce = Timer(
                                  const Duration(milliseconds: 350),
                                  () => fetchSuggestions(value, setModalState),
                                );
                              },
                              onSubmitted: (_) => searchForPlace(setModalState),
                              style: TextStyles.blackRegular14.copyWith(
                                color:
                                    dark ? Colors.white : AppColors.darkTextColor,
                              ),
                              decoration: InputDecoration(
                                hintText: 'searchLocationHint'.tr(),
                                hintStyle: TextStyles.blackRegular14.copyWith(
                                  color: dark
                                      ? Colors.white54
                                      : AppColors.greyColor,
                                ),
                                filled: true,
                                fillColor: dark
                                    ? const Color(0xFF21283B)
                                    : AppColors.whiteColor,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 12,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: dark
                                        ? Colors.white12
                                        : const Color(0xFFE8ECF3),
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: dark
                                        ? Colors.white12
                                        : const Color(0xFFE8ECF3),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: AppColors.primaryColor,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          SizedBox(
                            height: 46,
                            child: ElevatedButton(
                              onPressed: isSearching
                                  ? null
                                  : () => searchForPlace(setModalState),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryColor,
                                foregroundColor: AppColors.whiteColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: isSearching
                                  ? const SizedBox(
                                      height: 18,
                                      width: 18,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: AppColors.whiteColor,
                                      ),
                                    )
                                  : Text(
                                      'search'.tr(),
                                      style: TextStyles.whiteBold14,
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (isFetchingSuggestions)
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: LinearProgressIndicator(minHeight: 2),
                      ),
                    if (suggestions.isNotEmpty)
                      Container(
                        margin: const EdgeInsets.fromLTRB(12, 6, 12, 8),
                        constraints: const BoxConstraints(maxHeight: 190),
                        decoration: BoxDecoration(
                          color:
                              dark ? const Color(0xFF21283B) : AppColors.whiteColor,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: dark ? Colors.white12 : const Color(0xFFE8ECF3),
                          ),
                        ),
                        child: ListView.separated(
                          itemCount: suggestions.length,
                          separatorBuilder: (_, __) => Divider(
                            height: 1,
                            color:
                                dark ? Colors.white10 : const Color(0xFFE8ECF3),
                          ),
                          itemBuilder: (_, index) {
                            final suggestion = suggestions[index];
                            return ListTile(
                              dense: true,
                              leading: Icon(
                                Icons.place_outlined,
                                color: AppColors.primaryColor,
                              ),
                              title: Text(
                                suggestion.displayName,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyles.blackRegular14.copyWith(
                                  color: dark
                                      ? Colors.white
                                      : AppColors.darkTextColor,
                                ),
                              ),
                              onTap: () async {
                                searchController.text = suggestion.displayName;

                                final found = latlng.LatLng(
                                  suggestion.lat,
                                  suggestion.lng,
                                );

                                safeSetModal(setModalState, () {
                                  tempSelected = found;
                                  tempAddress = suggestion.displayName;
                                  suggestions = [];
                                  recentSearches =
                                      _pushRecent(recentSearches, suggestion);
                                });

                                if (!mounted || !routeActive) return;
                                mapController.move(found, 16);

                                final resolved = await _reverseGeocode(
                                  suggestion.lat,
                                  suggestion.lng,
                                );

                                safeSetModal(setModalState, () {
                                  tempAddress = resolved.isEmpty
                                      ? suggestion.displayName
                                      : resolved;
                                });
                              },
                            );
                          },
                        ),
                      ),
                    if (searchController.text.trim().isEmpty &&
                        recentSearches.isNotEmpty)
                      Container(
                        margin: const EdgeInsets.fromLTRB(12, 2, 12, 8),
                        constraints: const BoxConstraints(maxHeight: 190),
                        decoration: BoxDecoration(
                          color:
                              dark ? const Color(0xFF21283B) : AppColors.whiteColor,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: dark ? Colors.white12 : const Color(0xFFE8ECF3),
                          ),
                        ),
                        child: Column(
                          children: [
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.fromLTRB(12, 10, 12, 8),
                              child: Text(
                                'recentSearches'.tr(),
                                style: TextStyles.blackRegular12.copyWith(
                                  color:
                                      dark ? Colors.white70 : AppColors.greyColor,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            const Divider(height: 1),
                            Expanded(
                              child: ListView.separated(
                                itemCount: recentSearches.length,
                                separatorBuilder: (_, __) => Divider(
                                  height: 1,
                                  color: dark
                                      ? Colors.white10
                                      : const Color(0xFFE8ECF3),
                                ),
                                itemBuilder: (_, index) {
                                  final item = recentSearches[index];
                                  return ListTile(
                                    dense: true,
                                    leading: Icon(
                                      Icons.history,
                                      color: AppColors.primaryColor,
                                    ),
                                    title: Text(
                                      item.displayName,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyles.blackRegular14.copyWith(
                                        color: dark
                                            ? Colors.white
                                            : AppColors.darkTextColor,
                                      ),
                                    ),
                                    onTap: () async {
                                      searchController.text = item.displayName;

                                      final found =
                                          latlng.LatLng(item.lat, item.lng);

                                      safeSetModal(setModalState, () {
                                        tempSelected = found;
                                        tempAddress = item.displayName;
                                        recentSearches =
                                            _pushRecent(recentSearches, item);
                                      });

                                      if (!mounted || !routeActive) return;
                                      mapController.move(found, 16);

                                      final resolved = await _reverseGeocode(
                                        item.lat,
                                        item.lng,
                                      );

                                      safeSetModal(setModalState, () {
                                        tempAddress = resolved.isEmpty
                                            ? item.displayName
                                            : resolved;
                                      });
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    Expanded(
                      child: FlutterMap(
                        mapController: mapController,
                        options: MapOptions(
                          initialCenter: tempSelected,
                          initialZoom: 15,
                          onTap: (tapPosition, point) async {
                            safeSetModal(setModalState, () {
                              tempSelected = point;
                              suggestions = [];
                            });
                            final address = await _reverseGeocode(
                              point.latitude,
                              point.longitude,
                            );
                            safeSetModal(setModalState, () {
                              tempAddress = address;
                            });
                          },
                        ),
                        children: [
                          TileLayer(
                            urlTemplate:
                                'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                            userAgentPackageName: 'com.example.e_commerce',
                          ),
                          MarkerLayer(
                            markers: [
                              Marker(
                                point: tempSelected,
                                width: 44,
                                height: 44,
                                child: const Icon(
                                  Icons.location_on_rounded,
                                  color: Colors.red,
                                  size: 34,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${'latitude'.tr()}: ${tempSelected.latitude.toStringAsFixed(6)} | ${'longitude'.tr()}: ${tempSelected.longitude.toStringAsFixed(6)}',
                            style: TextStyles.blackRegular12.copyWith(
                              color: dark ? Colors.white70 : AppColors.greyColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            tempAddress.isEmpty
                                ? 'tapOnMapToSelect'.tr()
                                : '${'currentAddress'.tr()}: $tempAddress',
                            style: TextStyles.blackRegular12.copyWith(
                              color: dark ? Colors.white70 : AppColors.greyColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryColor,
                                foregroundColor: AppColors.whiteColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop(
                                  AddressLocationSelection(
                                    lat: tempSelected.latitude,
                                    lng: tempSelected.longitude,
                                    currentAddress: tempAddress,
                                  ),
                                );
                              },
                              child: Text(
                                'confirmLocation'.tr(),
                                style: TextStyles.whiteBold14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          );
        },
      ),
    );

    routeActive = false;

    debounce?.cancel();
    _recentSearches
      ..clear()
      ..addAll(recentSearches);

    if (result == null) return;

    setState(() {
      _selectedLatLng = latlng.LatLng(result.lat, result.lng);
      _resolvedAddress = result.currentAddress;
    });

    widget.onLocationChanged(result);
  }

  @override
  Widget build(BuildContext context) {
    final dark = context.isDarkMode;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'selectLocationOnMap'.tr(),
          style: TextStyles.blackBold14.copyWith(
            color: dark ? Colors.white : AppColors.darkTextColor,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: dark ? const Color(0xFF21283B) : AppColors.whiteColor,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: dark ? Colors.white12 : const Color(0xFFE8ECF3),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  _resolvedAddress.isEmpty
                      ? 'tapOnMapToSelect'.tr()
                      : _resolvedAddress,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyles.blackRegular14.copyWith(
                    color: dark ? Colors.white70 : AppColors.greyColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Material(
                color: dark ? const Color(0xFF2C3550) : const Color(0xFFEEF2FF),
                shape: const CircleBorder(),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: _openMapPickerDialog,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Icon(
                      Icons.map_outlined,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '${'latitude'.tr()}: ${_selectedLatLng.latitude.toStringAsFixed(6)} | ${'longitude'.tr()}: ${_selectedLatLng.longitude.toStringAsFixed(6)}',
          style: TextStyles.blackRegular12.copyWith(
            color: dark ? Colors.white70 : AppColors.greyColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          _resolvedAddress.isEmpty
              ? 'tapOnMapToSelect'.tr()
              : '${'currentAddress'.tr()}: $_resolvedAddress',
          style: TextStyles.blackRegular12.copyWith(
            color: dark ? Colors.white70 : AppColors.greyColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _PlaceSuggestion {
  final String displayName;
  final double lat;
  final double lng;

  const _PlaceSuggestion({
    required this.displayName,
    required this.lat,
    required this.lng,
  });
}
