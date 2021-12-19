import 'package:flutter/material.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/blocs/generalBloc/portfolio_bloc.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/blocs/marketBloc/market_bloc.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/dialog/dialog_handler.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/loader/component_loader.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/commons/response/response_failure.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/manager/provider.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/orderModel/contract.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/models/responseModel/response_result.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/views/observer/future_observer.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/views/orderSchedule/contract/contract_tile.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/views/orderSchedule/contract/trade_book_contract_detail_screen.dart';

class ContractTradebookScreen extends StatefulWidget {
  final MarketBloc marketBloc;

  ContractTradebookScreen({@required this.marketBloc});

  @override
  _ContractTradebookScreenState createState() =>
      _ContractTradebookScreenState();
}

class _ContractTradebookScreenState extends State<ContractTradebookScreen> {
  final double minValue = 8.0;

  Future<ResponseResult> _futureResult;
  ResponseResult _result;

  Failure _failure;

  Future<void> _onCreated() async {
    _futureResult = widget.marketBloc.getTradeContracts();
    _result = await _futureResult;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    _onCreated();
    super.initState();
  }

  void _onTapContract(Contract contract) async {
    DialogHandler.openPortfolioDialog(
        context: context,
        child: ContractDetailScreen(
          contract: contract,
          portfolioBloc: Provider.of(context).fetch(PortfolioBloc),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Container(
        child: RefreshIndicator(
          onRefresh: () async {
            await _onCreated();
            return true;
          },
          child: FutureObserver(
            onWaiting: (context) => MyComponentsLoader(),
            future: _futureResult,
            onError: (context, Failure failed) => ResponseFailure(
              title: "${failed.responseMessage}",
            ),
            onSuccess: (context, List<Contract> contractSet) {
              if (contractSet.length == 0)
                return ResponseFailure(
                  title: "No Data Available",
                  hasDark: true,
                  subtitle: "Make a deal",
                );
              return ListView.separated(
                  padding: EdgeInsets.symmetric(
                      vertical: minValue * 1.5, horizontal: minValue),
                  itemBuilder: (BuildContext context, int index) {
                    final Contract _contract = contractSet[index];

                    return ContractTile(
                      contract: _contract,
                      onTap: () => _onTapContract(_contract),
                    );
                  },
                  separatorBuilder: (context, index) => Divider(
                        color: Colors.grey[800],
                      ),
                  itemCount: contractSet.length);
            },
          ),
        ),
      ),
    );
  }
}
