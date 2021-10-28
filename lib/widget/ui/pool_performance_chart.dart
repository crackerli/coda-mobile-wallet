import 'package:coda_wallet/stake_pool_rank/blocs/block_produced_entity.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class PoolPerformanceChart extends StatelessWidget {
  final List<charts.Series<dynamic, String>> epochList;
  final bool animate;
  late List<EpochBlocks> canonicalBlocks;
  late List<EpochBlocks> orphanBlocks;

  PoolPerformanceChart(this.epochList, {this.animate = false});

  factory PoolPerformanceChart.withSampleData(List<EpochBlocks> canonicalBlocks, List<EpochBlocks> orphanBlocks) {
    return PoolPerformanceChart(
      _createSampleData(canonicalBlocks, orphanBlocks),
      // Disable animations for image tests.
      animate: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return charts.BarChart(
      epochList,
      animate: animate,
      barGroupingType: charts.BarGroupingType.stacked,
      barRendererDecorator: charts.BarLabelDecorator<String>(),
      domainAxis: charts.OrdinalAxisSpec(),
    );
  }

  /// Create series list with multiple series
  static List<charts.Series<EpochBlocks, String>> _createSampleData(
    List<EpochBlocks> canonicalBlocks,
    List<EpochBlocks> orphanBlocks
  ) {
    return [
      charts.Series<EpochBlocks, String>(
        id: 'OrphanBlocks',
        domainFn: (EpochBlocks epochBlocks, _) => 'E${epochBlocks.epoch}',
        measureFn: (EpochBlocks epochBlocks, _) => epochBlocks.blocks.length,
        seriesColor: charts.ColorUtil.fromDartColor(Colors.red),
        labelAccessorFn: (EpochBlocks epochBlocks, _) =>
          '${epochBlocks.blocks.length == 0 ? '' : epochBlocks.blocks.length.toString()}',
        data: orphanBlocks,
      ),
      charts.Series<EpochBlocks, String>(
        id: 'CanonicalBlocks',
        domainFn: (EpochBlocks epochBlocks, _) => 'E${epochBlocks.epoch}',
        measureFn: (EpochBlocks epochBlocks, _) => epochBlocks.blocks.length,
        seriesColor: charts.ColorUtil.fromDartColor(Colors.green),
        labelAccessorFn: (EpochBlocks epochBlocks, _) =>
          '${epochBlocks.blocks.length == 0 ? '' : epochBlocks.blocks.length.toString()}',
        data: canonicalBlocks,
      ),
    ];
  }
}

