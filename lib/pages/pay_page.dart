import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:pango_lite/locale/locale.dart';
import 'package:pango_lite/model/elements/payment.dart';
import 'package:pango_lite/pages/pay_page_vm.dart';
import 'package:pango_lite/pages/routes.dart';
import 'package:pango_lite/pages/widget_keys.dart';

class PayPage extends StatefulWidget {
  PayPage({Key key}) : super(key: WidgetKeys.payPageKey);

  @override
  PayPageState createState() => PayPageState();
}

class PayPageState extends State<PayPage> {
  PayPageVM vm;
  final plugin = FlutterWebviewPlugin();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: vm.actionStream,
        initialData: PayPageVMAction(),
        builder: (context, snapshot) {
          final action = snapshot.data;
          switch (action.state) {
            case PayPageVMActionState.pay:
              return pay(context, action.data[PayPageVMActionDataKey.payment]);
            default:
              return Scaffold(
                  appBar: AppBar(
                    title: Text(AppLocalizations.of(context).payTitle),
                  ),
                  body: Container());
          }
        });
  }

  @override
  void dispose() {
    plugin.dispose();
    vm.close();
    super.dispose();
  }

  @override
  void initState() {
    vm = PayPageVM();
    vm.init().then((_) {});
    vm.otherActionStream.listen((action) {
      switch (action.state) {
        case PayPageVMOtherActionState.rootPage:
          Navigator.of(context).popUntil(ModalRoute.withName(Routes.rootPage));
          break;
        default:
          break;
      }
    });
    plugin.onUrlChanged.listen((url) async {
      await vm.onUrlChanged(url);
    });
    super.initState();
  }

  Widget pay(BuildContext context, Payment payment) {
    final url = Uri.dataFromString(
      '''
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Sample Site</title>
    <script src="https://js.stripe.com/v3/"></script>
    <link rel="stylesheet" href="//maxcdn.bootstrapcdn.com/bootstrap/3.3.1/css/bootstrap.min.css">
    <style>
        body { padding-top:50px; }
    </style>
</head>
<body>
    <div class="container">
        <div class="jumbotron">
            <script>
              const stripe = Stripe('pk_test_V4IMbysDTdphjZ7GV2f2iNSp');
              stripe.redirectToCheckout({sessionId: '${payment.sessionId}'})
              .then((result) => {});
            </script>
        </div>
    </div>

</body>
</html>''',
      mimeType: 'text/html',
    ).toString();
    return WebviewScaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context).payTitle)),
      url: url,
    );
  }
}
