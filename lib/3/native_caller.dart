import 'dart:ffi' as ffi;
import 'dart:ffi';
import 'dart:io';
import 'package:ffi/ffi.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

ffi.DynamicLibrary _lib = Platform.isAndroid
    ? ffi.DynamicLibrary.open('libnative_quadratic.so')
    : ffi.DynamicLibrary.process();

final Pointer<Utf8> Function(int a, int b, int c) call_native_func = _lib
    .lookup<NativeFunction<Pointer<Utf8> Function(Int32, Int32, Int32)>>(
        "native_quadratic")
    .asFunction();

class Quadratic_equation extends StatefulWidget {
  const Quadratic_equation({super.key});

  @override
  State<Quadratic_equation> createState() => _Quadratic_equationState();
}

class _Quadratic_equationState extends State<Quadratic_equation> {
  final TextEditingController _controller1 = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();
  final TextEditingController _controller3 = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomTextField(
                controller: _controller1,
                hintText: 'Nhập a',
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _controller2,
                hintText: 'Nhập b',
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _controller3,
                hintText: 'Nhập c',
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  setState(() {});
                },
                child: const Text('Calculate'),
              ),
              const SizedBox(
                height: 10,
              ),
              (_controller1.text.isEmpty && _controller2.text.isEmpty)
                  ? Container()
                  : Text(
                      style: const TextStyle(fontSize: 20),
                      call_native_func(
                              int.parse(_controller1.text),
                              int.parse(_controller2.text.isEmpty
                                  ? "0"
                                  : _controller2.text),
                              int.parse(_controller3.text.isEmpty
                                  ? "0"
                                  : _controller3.text))
                          .toDartString()),
            ]),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;

  const CustomTextField({
    super.key,
    required this.hintText,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^[+-]?\d*\.?\d*$')),
      ],
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(width: 2.0),
          borderRadius: BorderRadius.circular(12.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(width: 2.5),
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
    );
  }
}
