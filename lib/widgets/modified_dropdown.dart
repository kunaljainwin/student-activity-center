import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ModifiedDropDownMenu extends StatelessWidget {
  final String titleText;

  final List<String> stringItems;

  final void Function(Object?)? onChanged;
  final List<String> selectedValue;
  final isExpanded;
  const ModifiedDropDownMenu(
      {Key? key,
      required this.titleText,
      required this.stringItems,
      this.onChanged,
      required this.selectedValue,
      this.isExpanded = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2(
        autofocus: true,
        onMenuStateChange: (b) {},

        hint: Row(
          children: [
            Text(
              "          " + titleText,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                // color: Colors.yellow,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        isExpanded: true,

        items: stringItems
            .map((item) => DropdownMenuItem<String>(
                  value: item,
                  child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                      decoration: BoxDecoration(
                        color: selectedValue.contains(item)
                            ? Color.fromRGBO(255, 176, 255, 0.78)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            item,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          selectedValue.contains(item)
                              ? Icon(
                                  Icons.check,
                                  color: Color.fromRGBO(126, 17, 133, 1),
                                )
                              : SizedBox.shrink()
                        ],
                      )),
                ))
            .toList(),
        // value: selectedValue,
        onChanged: onChanged,

        icon: const Icon(
          CupertinoIcons.chevron_down,
        ),
        iconSize: 24,
        iconOnClick: Icon(
          CupertinoIcons.chevron_up,
        ),

        buttonPadding: const EdgeInsets.only(left: 10, right: 10),
        buttonDecoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.grey.shade300,
          ),
          // color: Colors.redAccent,
        ),
        buttonElevation: 5,
        dropdownMaxHeight: MediaQuery.of(context).size.height * 0.5,

        dropdownPadding:
            EdgeInsets.only(top: 30, bottom: 20, left: 23, right: 12),

        offset: Offset(0, -7),

        dropdownDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).bottomAppBarColor,
        ),

        // dropdownElevation: 8,c
        scrollbarRadius: Radius.circular(20),
        scrollbarThickness: 3,
        scrollbarAlwaysShow: true,
        itemHeight: 69,
        buttonHeight: 50,
      ),
    );
  }
}
