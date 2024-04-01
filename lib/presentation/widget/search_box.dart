
import 'package:flutter/material.dart';
import 'package:treeo_delivery/presentation/widget/reusable_colors.dart';

class SearchBox extends StatefulWidget {
  const SearchBox({required this.onEditingComplete, super.key});
  final void Function(String text) onEditingComplete;

  @override
  State<SearchBox> createState() => _SearchBoxState();
}

class _SearchBoxState extends State<SearchBox> {
  late final TextEditingController _searchController;
  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Container(
      height: height * .05,
      width: width * .9,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: shadowcolor,
            // offset: Offset(0, 2),
            blurRadius: 1,
            spreadRadius: 1,
          ),
        ],
      ),
      child: TextField(
        cursorColor: blackColor,
        controller: _searchController,
        onEditingComplete: () {
          widget.onEditingComplete(_searchController.text);
        },
        // controller: _emailController,
        decoration: InputDecoration(
          fillColor: whiteColor,
          filled: true,
          prefixIcon: const Icon(
            Icons.search,
            size: 18,
            color: otpgrey,
          ),
          hintText: 'Search Order',
          contentPadding: const EdgeInsets.all(1),
          hintStyle: const TextStyle(fontSize: 12, color: Color(0xff6B6B6B)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: whiteColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: whiteColor),
          ),
        ),
        style: const TextStyle(
          fontSize: 12,
          height: 1,
          fontWeight: FontWeight.w400,
          color: Color(0xff6B6B6B),
        ),
        // maxLines: maxLines,
      ),
    );
  }
}
