// ignore_for_file: no_logic_in_create_state, avoid_print

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:sqlitedatabases/model/cashflow.dart';
import 'package:sqlitedatabases/database/dbhelper.dart';

class Pengeluaran extends StatefulWidget {
  const Pengeluaran({Key? key}) : super(key: key);

  @override
  State<Pengeluaran> createState() => _PengeluaranState();
}

class _PengeluaranState extends State<Pengeluaran> {
  late Cashflow cashflow;
  final formKey = GlobalKey<FormState>();

  TextEditingController dateInput = TextEditingController();
  TextEditingController nominalInput = TextEditingController();
  TextEditingController keteranganInput = TextEditingController();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future insertData() async {
    var db = DBHelper();
    var cashflow = Cashflow(
      dateInput.text,
      int.parse(nominalInput.text),
      keteranganInput.text,
      'Pengeluaran',
    );
    await db.saveCashflow(cashflow);
    print('Saved');
  }

  void _saveData() {
    if (formKey.currentState!.validate()) {
      insertData();
      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    dateInput.dispose();
    nominalInput.dispose();
    keteranganInput.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton(
              onPressed: () {
                dateInput.clear();
                nominalInput.clear();
                keteranganInput.clear();
              },
              child: const Text('Reset'),
              style: ElevatedButton.styleFrom(
                primary: Colors.blueGrey,
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                ),
                textStyle: const TextStyle(
                  fontSize: 20,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                ),
                minimumSize: const Size.fromHeight(50),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: _saveData,
              child: const Text('Simpan'),
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                ),
                textStyle: const TextStyle(
                  fontSize: 20,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                ),
                minimumSize: const Size.fromHeight(50),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Kembali'),
              style: ElevatedButton.styleFrom(
                primary: Color.fromARGB(255, 0, 247, 255),
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                ),
                textStyle: const TextStyle(
                  fontSize: 20,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                ),
                minimumSize: const Size.fromHeight(50),
              ),
            ),
          ],
        ),
      ),
      key: _scaffoldKey,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Flexible(
            child: Form(
              key: formKey,
              child: Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Tambah Pengeluaran',
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Poppins',
                          color: Colors.red),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      'Tanggal :',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    SizedBox(
                      child: Center(
                        child: TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Tanggal wajib diisi!';
                            }
                            return null;
                          },
                          controller: dateInput,
                          readOnly: true,
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1950),
                              lastDate: DateTime(2100),
                            );

                            if (pickedDate != null) {
                              String formattedDate =
                                  DateFormat('yyyy-MM-dd').format(pickedDate);
                              setState(() {
                                dateInput.text = formattedDate;
                              });
                            } else {}
                          },
                          decoration: const InputDecoration(
                            labelText: "Masukkan Tanggal",
                            labelStyle: TextStyle(
                              fontFamily: 'Poppins',
                              color: Colors.black,
                            ),
                            hintStyle: TextStyle(
                              fontFamily: 'Poppins',
                              color: Colors.black,
                            ),
                            focusColor: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      'Nominal :',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Nominal wajib diisi!';
                        }
                        return null;
                      },
                      controller: nominalInput,
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      decoration: const InputDecoration(
                        labelText: 'Masukkan Nominal',
                        labelStyle: TextStyle(
                          fontFamily: 'Poppins',
                          color: Colors.black,
                        ),
                        hintStyle: TextStyle(
                          fontFamily: 'Poppins',
                          color: Colors.black,
                        ),
                        focusColor: Colors.black,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      'Keterangan :',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Keterangan wajib diisi!';
                        }
                        return null;
                      },
                      controller: keteranganInput,
                      decoration: const InputDecoration(
                        labelText: 'Masukkan Keterangan',
                        labelStyle: TextStyle(
                          fontFamily: 'Poppins',
                          color: Colors.black,
                        ),
                        hintStyle: TextStyle(
                          fontFamily: 'Poppins',
                          color: Colors.black,
                        ),
                        focusColor: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
