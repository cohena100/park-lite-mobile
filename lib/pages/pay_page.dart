import 'package:flutter/material.dart';
import 'package:pango_lite/locale/locale.dart';
import 'package:pango_lite/model/elements/payment.dart';
import 'package:pango_lite/pages/pay_page_vm.dart';
import 'package:pango_lite/pages/routes.dart';
import 'package:pango_lite/pages/widget_keys.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PayPage extends StatefulWidget {
  PayPage({Key key}) : super(key: WidgetKeys.payPageKey);

  @override
  PayPageState createState() => PayPageState();
}

class PayPageState extends State<PayPage> {
  PayPageVM vm;
  bool isDirty = true;

  @override
  Widget build(BuildContext context) {
    if (isDirty) {
      vm.init().then((_) {});
      isDirty = false;
    }
    return StreamBuilder(
        stream: vm.actionStream,
        initialData: PayPageVMAction(),
        builder: (context, snapshot) {
          final action = snapshot.data;
          switch (action.state) {
            case PayPageVMActionState.pay:
              return pay(context, action.data[PayPageVMActionDataKey.payment]);
            default:
              return Container();
          }
        });
  }

  @override
  void dispose() {
    vm.close();
    super.dispose();
  }

  @override
  void initState() {
    vm = PayPageVM();
    vm.otherActionStream.listen((action) {
      switch (action.state) {
        case PayPageVMOtherActionState.fullRootPage:
          Navigator.of(context).popUntil(ModalRoute.withName(Routes.rootPage));
          Navigator.of(context).pushReplacementNamed(Routes.rootPage);
          break;
        default:
          break;
      }
      isDirty = true;
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
    return Scaffold(
        appBar: AppBar(title: Text(AppLocalizations.of(context).payTitle)),
        body: WebView(
          initialUrl: url,
          javascriptMode: JavascriptMode.unrestricted,
        ));
  }
}
