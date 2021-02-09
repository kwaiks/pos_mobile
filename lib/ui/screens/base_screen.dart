import 'package:flutter/material.dart';
import 'package:pos_mobile/core/models/cart.dart';
import 'package:pos_mobile/core/utils/shared_preference.dart';
import 'package:pos_mobile/core/viewmodels/base_model.dart';
import 'package:provider/provider.dart';
import 'package:pos_mobile/injector.dart';

class BaseScreen<T extends BaseModel> extends StatefulWidget {
  final Widget Function(BuildContext context, T model, Widget child) builder;
  final Function(T) onModelReady;
  final Function(T) onDestroy;

  BaseScreen({this.builder, this.onModelReady, this.onDestroy});

  @override
  _BaseViewState<T> createState() => _BaseViewState<T>();
}

class _BaseViewState<T extends BaseModel> extends State<BaseScreen<T>> {
  T model = injector<T>();

  @override
  void initState() {
    if (widget.onModelReady != null) {
      widget.onModelReady(model);
    }
    super.initState();
  }

  @override
  void dispose() {
    if (widget.onDestroy != null) {
      widget.onDestroy(model);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<T>(
        create: (context) => model,
        child: Consumer<T>(builder: widget.builder));
  }
}
