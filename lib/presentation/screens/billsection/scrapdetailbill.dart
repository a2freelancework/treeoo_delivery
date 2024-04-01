import 'package:flutter/material.dart';
import 'package:treeo_delivery/presentation/widget/appbarsection.dart';
import 'package:treeo_delivery/presentation/widget/reusable_colors.dart';

class ScrapdetailBill extends StatefulWidget {
  const ScrapdetailBill({super.key});

  @override
  State<ScrapdetailBill> createState() => _ScrapdetailBillState();
}

class _ScrapdetailBillState extends State<ScrapdetailBill> {
  
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: whiteColor,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.only(left: width * .05, right: width * .05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: height * .065,
              ),
              const AppbarSection(
                heading: ' Order Details',
              ),
              SizedBox(
                height: height * .02,
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Vehicle Number',
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Gilroy',
                          fontSize: 15,
                          letterSpacing: .4,
                          color: otpgrey,),),
                  Text('KL 16 A 8765',
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Gilroy',
                          fontSize: 15,
                          letterSpacing: .4,
                          color: blackColor,),),
                ],
              ),
              SizedBox(
                height: height * .01,
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Status',
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Gilroy',
                          fontSize: 15,
                          letterSpacing: .4,
                          color: otpgrey,),),
                  Text('In Progress',
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Gilroy',
                          fontSize: 15,
                          letterSpacing: .4,
                          color: blackColor,),),
                ],
              ),
              SizedBox(
                height: height * .01,
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Name',
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Gilroy',
                          fontSize: 15,
                          letterSpacing: .4,
                          color: otpgrey,),),
                  Text('Abhilash',
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Gilroy',
                          fontSize: 15,
                          letterSpacing: .4,
                          color: blackColor,),),
                ],
              ),
              SizedBox(
                height: height * .01,
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Scheduled Date',
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Gilroy',
                          fontSize: 15,
                          letterSpacing: .4,
                          color: otpgrey,),),
                  Text('12-Nov-2023',
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Gilroy',
                          fontSize: 15,
                          letterSpacing: .4,
                          color: blackColor,),),
                ],
              ),
              SizedBox(
                height: height * .02,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('ITEM',
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Gilroy',
                          fontSize: 15,
                          letterSpacing: .4,
                          color: blackColor,),),
                  const Spacer(),
                  const Text('QTY',
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Gilroy',
                          fontSize: 15,
                          letterSpacing: .4,
                          color: blackColor,),),
                  SizedBox(
                    width: width * .17,
                  ),
                  const Text('PRICE',
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Gilroy',
                          fontSize: 15,
                          letterSpacing: .4,
                          color: blackColor,),),
                ],
              ),
              const Line(),
              ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero, // padding around the grid
                  itemCount: 10, // total number of items
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 4, bottom: 4),
                      child: Container(
                        height: height * .05,
                        width: width,
                        decoration: BoxDecoration(
                            color: peahcream,
                            borderRadius: BorderRadius.circular(5),),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: width * .02,
                              ),
                              const Text('Cartoon Box',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Gilroy',
                                      fontSize: 15,
                                      letterSpacing: .4,
                                      color: blackColor,),),
                              const Spacer(),
                              SizedBox(
                                width: width * .13,
                                height: height,
                                child: const Center(
                                  child: TextField(
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: '1',
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: width * .1,
                              ),
                              SizedBox(
                                width: width * .12,
                                height: height,
                                child: const Center(
                                  child: TextField(
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: '100',
                                    ),
                                  ),
                                ),
                              ),
                            ],),
                      ),
                    );
                  },),
              SizedBox(
                height: height * .01,
              ),
              const Line(),
              SizedBox(
                height: height * .01,
              ),
              const Text('Add More Items',
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Gilroy',
                      fontSize: 15,
                      letterSpacing: .4,
                      color: blackColor,),),
              SizedBox(
                height: height * .01,
              ),
              SizedBox(
                height: height * .06,
                width: width,
                child: TextField(
                  cursorColor: blackColor,
                  // controller: _emailController,
                  decoration: InputDecoration(
                    fillColor: whiteColor,
                    filled: true,
                    hintText: 'Select Item',
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: subtext),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: subtext),
                    ),
                  ),
                  style: const TextStyle(
                    fontSize: 13,
                    height: 1,
                    color: blackColor,
                  ),
                  // maxLines: maxLines,
                ),
              ),
              SizedBox(
                height: height * .01,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: height * .06,
                    width: width * .4,
                    child: TextField(
                      cursorColor: blackColor,
                      // controller: _emailController,
                      decoration: InputDecoration(
                        fillColor: whiteColor,
                        filled: true,
                        hintText: 'Qty',
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              const BorderSide(color: subtext),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              const BorderSide(color: subtext),
                        ),
                      ),
                      style: const TextStyle(
                        fontSize: 13,
                        height: 1,
                        color: blackColor,
                      ),
                      // maxLines: maxLines,
                    ),
                  ),
                  SizedBox(
                    height: height * .06,
                    width: width * .4,
                    child: TextField(
                      cursorColor: blackColor,
                      // controller: _emailController,
                      decoration: InputDecoration(
                        fillColor: whiteColor,
                        filled: true,
                        hintText: 'Price',
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              const BorderSide(color: subtext),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              const BorderSide(color: subtext),
                        ),
                      ),
                      style: const TextStyle(
                        fontSize: 13,
                        height: 1,
                        color: blackColor,
                      ),
                      // maxLines: maxLines,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: height * .01,
              ),
              OrderContainer(name: 'Add item', onTap: () {},),
              SizedBox(
                height: height * .01,
              ),
              const Line(),
              SizedBox(
                height: height * .01,
              ),
              SizedBox(
                height: height * .06,
                width: width,
                child: TextField(
                  cursorColor: blackColor,
                  // controller: _emailController,
                  decoration: InputDecoration(
                    fillColor: whiteColor,
                    filled: true,
                    hintText: 'Add Service charge',
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: subtext),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: subtext),
                    ),
                  ),
                  style: const TextStyle(
                    fontSize: 13,
                    height: 1,
                    color: blackColor,
                  ),
                  // maxLines: maxLines,
                ),
              ),
              SizedBox(
                height: height * .01,
              ),
              OrderContainer(name: 'Confirm Order', onTap: () {},),
              SizedBox(
                height: height * .1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
