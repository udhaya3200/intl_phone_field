import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/helpers.dart';
import 'package:blurrycontainer/blurrycontainer.dart';

class PickerDialogStyle {
  final Color? backgroundColor;

  final TextStyle? countryCodeStyle;

  final TextStyle? countryNameStyle;

  final Widget? listTileDivider;

  final EdgeInsets? listTilePadding;

  final EdgeInsets? padding;

  final Color? searchFieldCursorColor;

  final InputDecoration? searchFieldInputDecoration;

  final EdgeInsets? searchFieldPadding;

  final double? width;

  final TextStyle? headingStyle;
  final Color? backIconblurryContinerColor;
  final Color? backIconColor;
  final Decoration? containerDecoration;

  PickerDialogStyle(
      {this.backgroundColor,
      this.countryCodeStyle,
      this.countryNameStyle,
      this.listTileDivider,
      this.listTilePadding,
      this.padding,
      this.searchFieldCursorColor,
      this.searchFieldInputDecoration,
      this.searchFieldPadding,
      this.width,
      this.headingStyle,
      this.backIconColor,
      this.backIconblurryContinerColor,
      this.containerDecoration});
}

class CountryPickerDialog extends StatefulWidget {
  final List<Country> countryList;
  final Country selectedCountry;
  final ValueChanged<Country> onCountryChanged;
  final String searchText;
  final List<Country> filteredCountries;
  final PickerDialogStyle? style;
  final String languageCode;

  const CountryPickerDialog({
    Key? key,
    required this.searchText,
    required this.languageCode,
    required this.countryList,
    required this.onCountryChanged,
    required this.selectedCountry,
    required this.filteredCountries,
    this.style,
  }) : super(key: key);

  @override
  _CountryPickerDialogState createState() => _CountryPickerDialogState();
}

class _CountryPickerDialogState extends State<CountryPickerDialog> {
  late List<Country> _filteredCountries;
  late Country _selectedCountry;

  @override
  void initState() {
    _selectedCountry = widget.selectedCountry;
    _filteredCountries = widget.filteredCountries.toList()
      ..sort(
        (a, b) => a
            .localizedName(widget.languageCode)
            .compareTo(b.localizedName(widget.languageCode)),
      );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mediaWidth = MediaQuery.of(context).size.width;
    final width = widget.style?.width ?? mediaWidth;
    const defaultHorizontalPadding = 40.0;
    const defaultVerticalPadding = 24.0;
    return Card(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: widget.style?.padding ?? const EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: widget.style?.backgroundColor,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        child: Column(
          children: <Widget>[
            Container(
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: BlurryContainer(
                        height: 32,
                        width: 32,
                        padding: const EdgeInsets.all(3),
                        color: widget.style?.backIconblurryContinerColor ??
                            Colors.black.withOpacity(0.132),
                        borderRadius: BorderRadius.circular(10),
                        child: Icon(
                          Icons.arrow_back,
                          color: widget.style?.backIconColor ?? Colors.black,
                        )),
                  ),
                  Text(
                    "Choose a Country",
                    style: widget.style?.headingStyle ??
                        const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.black),
                  ),
                  const Text(
                    "Choo",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.transparent),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            Padding(
              padding:
                  widget.style?.searchFieldPadding ?? const EdgeInsets.all(0),
              child: TextField(
                cursorColor: widget.style?.searchFieldCursorColor,
                decoration: widget.style?.searchFieldInputDecoration ??
                    InputDecoration(
                      suffixIcon: const Icon(Icons.search),
                      labelText: widget.searchText,
                    ),
                onChanged: (value) {
                  _filteredCountries = widget.countryList.stringSearch(value)
                    ..sort(
                      (a, b) => a
                          .localizedName(widget.languageCode)
                          .compareTo(b.localizedName(widget.languageCode)),
                    );
                  if (mounted) setState(() {});
                },
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _filteredCountries.length,
                itemBuilder: (ctx, index) => Column(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        _selectedCountry = _filteredCountries[index];
                        widget.onCountryChanged(_selectedCountry);
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        decoration: widget.style?.containerDecoration,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            kIsWeb
                                ? Image.asset(
                                    'assets/flags/${_filteredCountries[index].code.toLowerCase()}.png',
                                    package: 'intl_phone_field',
                                    width: 32,
                                  )
                                : Text(
                                    _filteredCountries[index].flag,
                                    style: const TextStyle(fontSize: 18),
                                  ),
                            Text(
                              _filteredCountries[index]
                                  .localizedName(widget.languageCode),
                              style: widget.style?.countryNameStyle ??
                                  const TextStyle(fontWeight: FontWeight.w700),
                            ),
                            Text(
                              '+${_filteredCountries[index].dialCode}',
                              style: widget.style?.countryCodeStyle ??
                                  const TextStyle(fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ListTile(
//   leading: kIsWeb
//       ? Container(
//           height: 150,
//           width: 150,
//           decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               border: Border.all(color: Colors.grey)),
//           child: Image.asset(
//             'assets/flags/${_filteredCountries[index].code.toLowerCase()}.png',
//             package: 'intl_phone_field',
//             width: 32,
//           ),
//         )
//       : Text(
//           _filteredCountries[index].flag,
//           style: const TextStyle(fontSize: 18),
//         ),
//   contentPadding: widget.style?.listTilePadding,
//   title: Text(
//     _filteredCountries[index]
//         .localizedName(widget.languageCode),
//     style: widget.style?.countryNameStyle ??
//         const TextStyle(fontWeight: FontWeight.w700),
//   ),
//   trailing: Text(
//     '+${_filteredCountries[index].dialCode}',
//     style: widget.style?.countryCodeStyle ??
//         const TextStyle(fontWeight: FontWeight.w700),
//   ),
//   onTap: () {
//     _selectedCountry = _filteredCountries[index];
//     widget.onCountryChanged(_selectedCountry);
//     Navigator.of(context).pop();
//   },
// ),
// widget.style?.listTileDivider ??
//     const Divider(thickness: 1),

// insetPadding: EdgeInsets.symmetric(
//     vertical: defaultVerticalPadding,
//     horizontal: mediaWidth > (width + defaultHorizontalPadding * 2)
//         ? (mediaWidth - width) / 2
//         : defaultHorizontalPadding),
