import 'package:flutter/material.dart';
import 'package:nopcart_flutter/bloc/all_manufacturer_bloc.dart';
import 'package:nopcart_flutter/customWidget/CustomAppBar.dart';
import 'package:nopcart_flutter/customWidget/error.dart';
import 'package:nopcart_flutter/customWidget/home/manufacturer_box.dart';
import 'package:nopcart_flutter/customWidget/loading.dart';
import 'package:nopcart_flutter/model/home/ManufacturersResponse.dart';
import 'package:nopcart_flutter/networking/ApiResponse.dart';

class AllManufacturersScreen extends StatefulWidget {
  static const routeName = '/all-manufacturers-screen';
  final AllManufacturersScreenArgs args;

  const AllManufacturersScreen({Key key, this.args})
      : super(key: key);

  @override
  _AllManufacturersScreenState createState() => _AllManufacturersScreenState();
}

class _AllManufacturersScreenState extends State<AllManufacturersScreen> {
  AllManufacturerBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = AllManufacturerBloc();

    _bloc.fetchManufacturers();
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.blue,
        title: Text(widget.args.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder<ApiResponse<List<ManufacturerData>>>(
          stream: _bloc.manufacturersStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              switch (snapshot.data.status) {
                case Status.LOADING:
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Loading(loadingMessage: snapshot.data.message),
                  );
                  break;
                case Status.COMPLETED:
                  return rootWidget(snapshot?.data?.data ?? []);
                  break;
                case Status.ERROR:
                  return Error(
                    errorMessage: snapshot.data.message,
                    onRetryPressed: () => _bloc.fetchManufacturers(),
                  );
                  break;
              }
            }
            return SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget rootWidget(List<ManufacturerData> manufacturerList) {
    return GridView.builder(
      itemBuilder: (context, index) {
        return ManufacturerBox(manufacturerList[index]);
      },
      itemCount: manufacturerList.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: (MediaQuery.of(context).size.width / 175).round(),
        childAspectRatio: 1.25,
        mainAxisExtent: 150,
      ),
      scrollDirection: Axis.vertical,
    );
  }
}

class AllManufacturersScreenArgs {
  final String title;

  const AllManufacturersScreenArgs(this.title);
}
