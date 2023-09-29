import 'package:flutter/material.dart';
import 'package:sqlitedatabases/model/cashflow.dart';

class CashflowPage extends StatefulWidget {
  final List<Cashflow> cashflowData;

  const CashflowPage(this.cashflowData, {Key? key}) : super(key: key);

  @override
  State<CashflowPage> createState() => _CashflowPageState();
}

class _CashflowPageState extends State<CashflowPage> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: widget.cashflowData.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.only(bottom: 15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            boxShadow: const [
              BoxShadow(
                color: Colors.grey,
                blurRadius: 2,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Rp. ${widget.cashflowData[index].nominal.toString()}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Poppins',
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        widget.cashflowData[index].keterangan,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Poppins',
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        widget.cashflowData[index].tanggal,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Poppins',
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  Image(
                    image: widget.cashflowData[index].tipe == 'Pemasukan'
                        ? const AssetImage('assets/icons/left.png')
                        : const AssetImage('assets/icons/right.png'),
                    width: 50,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
