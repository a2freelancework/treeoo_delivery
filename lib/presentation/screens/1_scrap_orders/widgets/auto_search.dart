
import 'package:flutter/material.dart';
import 'package:treeo_delivery/data/orders/model/scrap_model.dart';

class AutoSearch extends StatelessWidget {
  const AutoSearch({
    required this.options,
    required this.onSelected,
    super.key,
  });
  final List<ScrapModel> options;
  final void Function(ScrapModel) onSelected;
  @override
  Widget build(BuildContext context) {
    return Autocomplete<ScrapModel>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text == '') {
          return const Iterable<ScrapModel>.empty();
        }
        return options.where(
          (scrap) => scrap.scrapName
              .toLowerCase()
              .contains(textEditingValue.text.toLowerCase()),
        );
      },
      displayStringForOption: (sp) {
        return sp.scrapName;
      },
      optionsViewBuilder: (_, callback, options) {
        return Material(
          child: SizedBox(
            height: 200,
            child: SingleChildScrollView(
              child: Column(
                children: options.map((opt) {
                  return GestureDetector(
                    onTap: () {
                      onSelected(opt);
                      callback(opt);
                    },
                    child: Container(
                      padding: const EdgeInsets.only(right: 40),
                      child: Card(
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(10),
                          child: Text(opt.scrapName),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        );
      },
    );
  }
}
