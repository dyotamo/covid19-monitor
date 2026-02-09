import 'package:covid19/src/client/api.dart';
import 'package:covid19/src/delegate/search.dart';
import 'package:covid19/src/models/country.dart';
import 'package:covid19/src/models/global.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();

  static Widget buildListView(List<Country> countries) => ListView.builder(
        padding: EdgeInsets.only(top: 8),
        itemCount: countries.length,
        itemBuilder: (context, index) =>
            _buildCountryTile(context, countries[index]),
      );

  static Widget _buildCountryTile(BuildContext context, Country country) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Card(
        child: ExpansionTile(
          tilePadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          leading: FutureBuilder<String>(
            future: country.flag,
            builder: (context, snapshot) {
              return Container(
                width: 48,
                height: 32,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    )
                  ],
                ),
                clipBehavior: Clip.antiAlias,
                child: snapshot.hasData
                    ? SvgPicture.network(
                        snapshot.data!,
                        fit: BoxFit.cover,
                        placeholderBuilder: (_) =>
                            _buildFlagPlaceholder(country),
                      )
                    : _buildFlagPlaceholder(country),
              );
            },
          ),
          title: Text(
            country.name,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          subtitle: Text(
            '${NumberFormat('#,###').format(country.confirmed ?? 0)} cases',
            style: TextStyle(color: Colors.grey[600], fontSize: 12),
          ),
          children: [
            _buildCountryDetails(context, country),
          ],
        ),
      ),
    );
  }

  static Widget _buildFlagPlaceholder(Country country) {
    return Container(
      color: Colors.grey[300],
      child: Center(
        child: Text(
          country.name.substring(0, 2).toUpperCase(),
          style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  static Widget _buildCountryDetails(BuildContext context, Country country) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: IntrinsicHeight(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildMiniStat('Deaths', country.deaths ?? 0, country.deathsPerc,
                Colors.redAccent),
            VerticalDivider(),
            _buildMiniStat('Recovered', country.recovered ?? 0,
                country.recoveredPerc, Colors.green),
          ],
        ),
      ),
    );
  }

  static Widget _buildMiniStat(String label, int count, String perc, Color color) {
    return Column(
      children: [
        Text(label, style: TextStyle(color: Colors.grey, fontSize: 11)),
        SizedBox(height: 4),
        Text(
          NumberFormat('#,###').format(count),
          style: TextStyle(fontWeight: FontWeight.bold, color: color),
        ),
        Text(perc, style: TextStyle(fontSize: 10, color: Colors.grey)),
      ],
    );
  }
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  List<Country> _allCountries = [];
  List<Country> _displayedCountries = [];
  Global? _global;
  bool _isLoading = true;
  String? _error;
  final int _pageSize = 20;

  @override
  void initState() {
    super.initState();
    _fetchInitialData();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _fetchInitialData() async {
    try {
      final data = await fetchData();
      if (mounted) {
        setState(() {
          _global = data['global'];
          _allCountries = List<Country>.from(data['countries']);
          _displayedCountries = _allCountries.take(_pageSize).toList();
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadMore();
    }
  }

  void _loadMore() {
    if (_displayedCountries.length < _allCountries.length) {
      setState(() {
        int nextSize = _displayedCountries.length + _pageSize;
        if (nextSize > _allCountries.length) nextSize = _allCountries.length;
        _displayedCountries = _allCountries.take(nextSize).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(body: _buildLoading(context));
    }
    if (_error != null) {
      return Scaffold(body: _buildError(context, _error));
    }
    return _buildContent(context, _global!, _displayedCountries);
  }

  Widget _buildLoading(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SpinKitPulse(color: Theme.of(context).primaryColor, size: 60),
          SizedBox(height: 20),
          Text(
            'Updating statistics...',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildError(BuildContext context, dynamic error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 60, color: Colors.red),
            SizedBox(height: 16),
            Text(
              'Failed to load data',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 8),
            Text(
              error.toString(),
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(
      BuildContext context, Global global, List<Country> countries) {
    return Scaffold(
      appBar: AppBar(
        title: Text('COVID-19 Monitor',
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () => showSearch(
              context: context,
              delegate: CountrySearch(results: _allCountries),
            ),
          ),
        ],
      ),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverToBoxAdapter(
            child: _buildDashboardHeader(context, global),
          ),
          SliverPadding(
            padding: EdgeInsets.fromLTRB(16, 24, 16, 8),
            sliver: SliverToBoxAdapter(
              child: Text(
                'Affected Countries',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                if (index < countries.length) {
                  return HomeScreen._buildCountryTile(context, countries[index]);
                }
                return null;
              },
              childCount: countries.length,
            ),
          ),
          if (_displayedCountries.length < _allCountries.length)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
          SliverToBoxAdapter(child: SizedBox(height: 20)),
        ],
      ),
    );
  }

  Widget _buildDashboardHeader(BuildContext context, Global global) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      padding: EdgeInsets.fromLTRB(20, 0, 20, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Global Status',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Last Updated: ${DateFormat('MMM dd, yyyy').format(global.date ?? DateTime.now())}',
            style: TextStyle(color: Colors.white54, fontSize: 12),
          ),
          SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: _buildStatusCard(
                  'Confirmed',
                  global.confirmed ?? 0,
                  Colors.orange,
                  FontAwesomeIcons.hospitalUser,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _buildStatusCard(
                  'Recovered',
                  global.recovered ?? 0,
                  Colors.green,
                  Icons.healing,
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          _buildStatusCard(
            'Total Deaths',
            global.deaths ?? 0,
            Colors.redAccent,
            FontAwesomeIcons.faceDizzy,
            fullWidth: true,
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard(String label, int count, Color color, IconData icon,
      {bool fullWidth = false}) {
    final formatter = NumberFormat('#,###');
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Row(
        mainAxisSize: fullWidth ? MainAxisSize.max : MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
              Text(
                formatter.format(count),
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
